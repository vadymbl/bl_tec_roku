sub show(args as Object)
    ShowHomeScreen()
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
    ShowVideoPlayer(homeScreen.content, homeScreen.rowitemSelected[1])
end sub

sub ShowVideoPlayer(content as Object, itemSelected as Integer)
    videoNode = CreateObject("roSGNode", "Video")
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
