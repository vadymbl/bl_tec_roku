sub show(args as Object)
    ShowHomeScreen()
end sub

sub ShowHomeScreen()
    homeScreen = CreateObject("roSGNode", "GridView")
    homeScreen.setFields({
        style: "standard"
        posterShape: "16x9"
    })
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

sub OnItemSelected(event as Object)
    homeScreen = event.GetRoSGNode()
    ShowVideoPlayer(homeScreen.content.getChildren(-1,0), homeScreen.rowItemSelected[0], homeScreen.rowItemSelected[1])
end sub

sub ShowVideoPlayer(content as Object, rowSelected as Integer, itemSelected as Integer)
    videoNode = CreateObject("roSGNode", "MediaView")
    videoNode.content = content[rowSelected]
    videoNode.jumpToItem = itemSelected
    videoNode.isContentList = true
    videoNode.control = "play"
    m.top.componentController.callFunc("show", {
        view: videoNode
    })
end sub
