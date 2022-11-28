sub show(args as Object)
    ShowHomeScreen()
end sub

sub ShowHomeScreen()
    homeScreen = CreateObject("roSGNode", "MediaView")
    homeScreen.setFields({
        style: "zoom"
        posterShape: "16x9"
    })
    homeScreen.ObserveFieldScoped("itemSelected", "OnItemSelected")
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

sub OnItemSelected(event as Object)
    homeScreen = event.GetRoSGNode()
    ShowVideoPlayer(homeScreen.content, homeScreen.itemSelected)\vadymbl\bl_tec_roku
end sub

sub ShowVideoPlayer(content as Object, itemSelected as Integer)
    videoNode = CreateObject("roSGNode", "MediaView")
    videoNode.control = "play"
    videoNode.content = content
    videoNode.contentIsPlaylist = true
    videoNode.loop = true
    videoNode.nextContentIndex = itemSelected
    videoNode.control = "skipcontent"
    m.top.componentController.callFunc("show", {
        view: videoNode
    })
end sub
