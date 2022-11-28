sub show(args as Object)
    ShowHomeScreen()
    SceneThemeUpdate()
    BrightLine_LoadAPI("https://cdn-media.brightline.tv/sdk/gen2/roku/direct/pkgs/BrightLineDirect-3.0.2.pkg")
end sub

sub ShowHomeScreen()
    homeScreen = CreateObject("roSGNode", "GridView")
    
    
    homeScreen.ObserveFieldScoped("rowItemSelected", "OnItemSelected") 
    

    content = CreateObject("roSGNode", "ContentNode")
    content.Update({
        HandlerConfigGrid: {
                name: "RootCH"
            }
    }, true)
    homeScreen.content = content
    homeScreen.showSpinner = true
    m.top.componentController.callFunc("show", {
        view: homeScreen
    })
end sub

sub SceneThemeUpdate()
    scene = m.top.getScene()
    
end sub


sub OnItemSelected(event as Object)
    homeScreen = event.GetRoSGNode()
    
    content = homeScreen.content.getChildren(-1,0)
    rowSelected = homeScreen.rowItemSelected[0]
    itemSelected = homeScreen.rowItemSelected[1]
    videoPlayer = ShowVideoPlayer(content, rowSelected,itemSelected )
    
    ad = content[rowSelected].getChildren(-1,0)[itemSelected].ad

    m.currentAd = GetAdObject (ad)
    CreateBrightLineDirect(videoPlayer)
end sub


sub ShowVideoPlayer(content as Object, rowSelected as Integer, itemSelected as Integer) as Object
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
        print "Error"
    end if
end sub

function GetAdObject(ad as Object) as Object
    
    m.adStartTime = ad.strtTime
    m.adDuration = ad.duration
    

    return {
        adId: 0315281           ' Populate from your ad
        contentId: 1426392      ' Populate from your ad
        adName: "single ad"     ' Populate from your ad
        provider: "BrightLine"  ' This must be "BrightLine" for the library to work.
        adURL: ad.url            ' This is where the ad JSON url is passed into the single-ad structure
        startAt: ad.strtTime  ' This is when in the stream's progress the ad should appear.
        duration: ad.duration  ' This is how long the ad should play.
        tracking: []
    }
end function

function GetTrackers() as Object
    ' This is your tracking array for the spot quartiles.
    return []
end function
