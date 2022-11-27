sub show(args as Object)
    ShowHomeScreen()
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
    ShowVideoPlayer(rowContent, selectedIndex[1])
end sub

' Subroutine no longer used
sub OnItemSelected(event as Object)
    homeScreen = event.GetRoSGNode()
    'ShowVideoPlayer(homeScreen.content, homeScreen.itemSelected)
end sub

sub ShowVideoPlayer(content as Object, index as Integer)
    ' videoNode = CreateObject("roSGNode", "Video") ' mediaPlayer
    ' videoNode.control = "play"
    ' videoNode.content = content
    ' videoNode.contentIsPlaylist = true
    ' videoNode.loop = true
    ' videoNode.nextContentIndex = itemSelected
    ' videoNode.control = "skipcontent"
    ' m.top.componentController.callFunc("show", {
    '     view: videoNode
    ' })
    videoNode = CreateObject("roSGNode", "MediaView")
    videoNode.content = content
    videoNode.jumpToItem = index
    videoNode.isContentList = true
    videoNode.control = "play"

    m.top.ComponentController.CallFunc("show", {
        view: videoNode
    })
end sub
