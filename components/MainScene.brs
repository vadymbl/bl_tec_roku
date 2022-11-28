sub show(args as Object)
    ShowHomeScreen()
    BrightLine_LoadAPI("https://cdn-media.brightline.tv/sdk/gen2/roku/direct/pkgs/BrightLineDirect-3.0.2.pkg")
end sub

sub ShowHomeScreen()
    homeScreen = CreateObject("roSGNode", "GridView")
    homeScreen.ObserveFieldScoped("rowitemSelected", "OnItemSelected")
    content = CreateObject("roSGNode", "ContentNode")
    content.Update({
        HandlerConfigGrid: {
                name: "RootCH"
            }
    }, true)
    homeScreen.content = content
    m.top.componentController.callFunc("show", {
        view: homeScreen
    })
end sub

sub OnItemSelected(event as Object)
    homeScreen = event.GetRoSGNode()
    'ShowVideoPlayer(homeScreen.content.getChildren(-1,0), homeScreen.rowItemSelected[0], homeScreen.rowItemSelected[1])
    StartBrightLinePlayback(homeScreen.content.getChildren(-1,0), homeScreen.rowItemSelected[0], homeScreen.rowItemSelected[1])
end sub


sub StartBrightLinePlayback(content as Object, rowSelected as Integer, itemSelected as Integer)
    print itemSelected
    videoPlayer = ShowVideoPlayer(content, rowSelected, itemSelected)
    m.currentAd = GetAdObject (itemSelected)
    CreateBrightLineDirect(videoPlayer)
end sub


sub ShowVideoPlayer(content as Object, rowSelected as Integer, itemSelected as Integer) as object
    videoNode = CreateObject("roSGNode", "MediaView")
    videoNode.content = content[rowSelected]
    videoNode.jumpToItem = itemSelected
    videoNode.isContentList = true
    videoNode.control = "play"
    m.top.componentController.callFunc("show", {
        view: videoNode
    })
    return videoNode
end sub

sub CreateBrightLineDirect(videoNode as Object)
    if m.brightlineLoaded then
        ' Creating the BrightLine SDK
        BrightLine_CreateBLDirect()
        ' Here are three examples of "setting an action object"
        ' Set a pointer to the stream player, player must be set before setting the ad
        ' Player should be actual video node that will do playback
        m.BrightLineDirect.action = {video: videoNode}
        ' Set the width of the UI
        m.BrightLineDirect.action = {width: 1280}
        ' Set the height of the UI
        m.BrightLineDirect.action = {height: 720}
        ' Here we set the trackers object
        m.BrightLineDirect.trackers = GetTrackers()
        ' We can make BrightLineDirect visible now.
        ' We'll use m.BrightLineDirect.state callback to set ad and focus.
        m.BrightLineDirect.visible = true
    else 
        print "ERR -> BrightLine SDK is not loaded yet."
    end if
end sub

function GetAdObject(adSelected as Integer) as Object
    ad = m.global.ads[adSelected]
    return {
        adId: 0315281           ' Populate from your ad
        contentId: 1426392      ' Populate from your ad
        adName: "single ad"     ' Populate from your ad
        provider: "BrightLine"  ' This must be "BrightLine" for the library to work.
        adURL: ad.url            ' This is where the ad JSON url is passed into the single-ad structure
        startAt: ad.strtTime  ' This is when in the stream's progress the ad should appear.
        duration:ad.duration  ' This is how long the ad should play.
        tracking: [{
            event: "AdStart"
            time: 12
            url: "http://www.foo.com/track"
            triggered: false
        },
        {
            event: "AdComplete"
            time: 42
            url: "http://www.foo.com/track"
            triggered: false
        }]
    }
end function

function GetTrackers() as Object
    ' This is your tracking array for the spot quartiles.
    return [
        {
            type:"Impression"
            url:"http://events.brightline.tv/track?data=%7B%22type%22%3A%22impression%22%2C%22valid%22%3Atrue%2C%22ad_id%22%3A2344293%7D"
            time:"12"
            triggered: false
        },

        {
            type:"FirstQuartile"
            url:"http://events.brightline.tv/track?data=%7B%22type%22%3A%22duration%22%2C%22duration_type%22%3A%22impression%22%2C%22percent_complete%22%3A25%2C%22ad_id%22%3A2344293%7D"
            time:"18"
            triggered: false
        },

        {
            type:"Midpoint"
            url:"http://events.brightline.tv/track?data=%7B%22type%22%3A%22duration%22%2C%22duration_type%22%3A%22impression%22%2C%22percent_complete%22%3A50%2C%22ad_id%22%3A2344293%7D"
            time:"27"
            triggered: false
        },

        {
            type:"ThirdQuartile"
            url:"http://events.brightline.tv/track?data=%7B%22type%22%3A%22duration%22%2C%22duration_type%22%3A%22impression%22%2C%22percent_complete%22%3A75%2C%22ad_id%22%3A2344293%7D"
            time:"33"
            triggered: false
        },

        {
            type:"Complete"
            url:"http://events.brightline.tv/track?data=%7B%22type%22%3A%22duration%22%2C%22duration_type%22%3A%22impression%22%2C%22percent_complete%22%3A100%2C%22ad_id%22%3A2344293%7D"
            time:"42"
            triggered: false
        },
    ]
end function