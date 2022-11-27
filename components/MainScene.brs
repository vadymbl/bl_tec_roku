sub show(args as Object)
    ShowHomeScreen()
    BrightLine_LoadAPI("https://cdn-media.brightline.tv/sdk/gen2/roku/direct/pkgs/BrightLineDirect-3.0.2.pkg")
end sub

sub ShowHomeScreen()
    m.grid = CreateObject("roSGNode", "GridView")
    m.grid.SetFields({
        style: "standard",
        posterShape: "16x9"
    })

    content = CreateObject("roSGNode", "ContentNode")
    content.AddFields({
        HandlerConfigGrid: {
            name: "RootCH"
        }
    })
    m.grid.content = content
    m.grid.ObserveField("rowItemSelected", "OnGridItemSelected")
    m.top.ComponentController.CallFunc("show", {
        view: m.grid
    })
end sub

sub OnGridItemSelected(event as Object)
    grid = event.GetRoSGNode()
    selectedIndex = event.GetData()
    rowContent = grid.content.GetChild(selectedIndex[0])
    adIndex = (selectedIndex[0] * m.global.row_delimiter) + selectedIndex[1]
    ad = m.global.ads[adIndex]
    ShowVideoPlayer(rowContent, selectedIndex[1], adIndex)
end sub

sub ShowVideoPlayer(content as Object, vidIndex as Integer, adIndex as Integer)
    videoNode = CreateObject("roSGNode", "MediaView")
    videoNode.content = content
    videoNode.jumpToItem = vidIndex
    videoNode.isContentList = true
    videoNode.control = "play"

    m.top.ComponentController.CallFunc("show", {
        view: videoNode
    })

    m.currentAd = GetAdObject(adIndex)
    CreateBrightLineDirect(videoNode)
end sub

sub OnSDKChanged(event as Object)
    sdk = event.GetData()
    if sdk <> invalid and sdk.pkg <> invalid
        BrightLine_LoadAPI("pkg:/components/BrightLineDirect-3.0.2.pkg")
    end if
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
    
    m.adStartTime = ad.strtTime
    m.adDuration = ad.duration

    return {
        adId: 0315281           ' Populate from your ad
        contentId: 1426392      ' Populate from your ad
        adName: "single ad"     ' Populate from your ad
        provider: "BrightLine"  ' This must be "BrightLine" for the library to work.
        adURL: ad.url          ' This is where the ad JSON url is passed into the single-ad structure
        startAt: ad.strtTime  ' This is when in the stream's progress the ad should appear.
        duration: ad.duration  ' This is how long the ad should play.
        tracking: []
    }
end function

function GetTrackers() as Object
    return []
end function