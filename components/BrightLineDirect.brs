#const debug = false

' ===> BrightLine SDK load and usage
sub BrightLine_LoadAPI(pkgUrl as String)
    print "Channel _____BrightLineDirect:BrightLine_LoadAPI"
    m.brightlineLoaded = false
    ' Cleaning previous version of the lib
    BrightLine_Cleanup()
    ' Load the SDK using component library
    m.adlib = CreateObject("roSGNode", "ComponentLibrary")
    m.adlib.ObserveField("loadStatus", "BrightLine_LoadStatus")
    m.adlib.SetField("uri", pkgUrl)
end sub

sub BrightLine_Cleanup()
    ' Invalidate previous instance of BrightLineDirect
    m.top.RemoveChild(m.BrightLineDirect)
    m.BrightLineDirect = invalid
end sub

sub BrightLine_LoadStatus()
    print " _____onAdLibLoadStatusChanged: " m.adlib.loadStatus
    print "m.adlib: " m.adlib

    ' Here we check the load status of the component library
    if (m.adlib.loadStatus = "ready")
        m.brightlineLoaded = true
    else if m.adlib.loadStatus = "failed" then
        m.brightlineLoaded = false
    end if
end sub

sub BrightLine_CreateBLDirect()
    ' Making sure previous SDK instance is removed and cleaned by garbage collector
    BrightLine_Cleanup()
    ' Creating the BrightLine SDK
    m.BrightLineDirect = CreateObject("roSGNode", "BrightLineDirect:BL_init")
    ' m.BrightLineDirect.showDebug = true
    m.top.AppendChild(m.BrightLineDirect)
    ' Set config ID to BLDirect to initialize it (it will be provided, for testing 1018 can be used)
    ' This is critical part, channel must set config id before setting ad
    m.BrightLineDirect.configID = "1018"
    ' We observe the "state" field of the library. This will direct us to make it visible and focused, or not.
    m.BrightLineDirect.ObserveField("state", "BrightLine_OnStateChange")
    ' This is the event listener. This observer is optional and channel can ommit it in most cases.
    ' It tells you when BrightLineDirect expanding and collapsing the microsite.
    m.BrightLineDirect.ObserveField("event", "BrightLine_OnEvent")
end sub

sub BrightLine_OnStateChange(msg as Object)
    state = msg.getData()
    print "~~~~~ onBrightLineDirectStateChange", state
    if state = "initialized" then
        print "BrightLine INIT"
        ' Lib is initialized, here we can provide our ad object.
        ' Ad will be shown according to startAt field of the ad object, based on video position
        m.BrightLineDirect.ad = m.currentAd
    else if state = "showing" then
        print "BrightLine SHOWING"
        ' BrightLineDirect needs focus when it's in it's "showing" state
        m.BrightLineDirect.SetFocus(true)
    else if state = "ready" then
        print "BrightLine READY"
        ' Ready is set when lib is initialized and not showing ad.
        ' Send focus back to whatever you want.
        ' In this case we're using the video player.
        m.top.componentController.currentView.SetFocus(true)
    else if state = "ad_selector_completed" then
        ' To not show stream-stitched ad after ad selector we can skip to needed position in this callback
        m.top.componentController.currentView.seek = m.adStartTime + m.adDuration
    else if state = "exited" then
        ' BrightLine has received an "exit" signal
        ' this is the equivalent of pressing the "back" key in a stream.
        print "BrightLine EXITED"
        ' this will close player screen
        m.top.componentController.currentView.exited = true
        m.BrightLineDirect.visible = false
    end if
end sub

sub BrightLine_OnEvent(msg as Object)
    ' Callback for events coming from the BrightLineDirect library.
    blEvent = msg.GetData()
    print "Channel _____onBrightLineAPI_event", blEvent
    if blEvent.type = "UI"
        ' This type of events are fired when library UI was changed
        ' Currently it fires only when microsite is opened/closed
        if blEvent.value = "expanded"
            ' microsite was opened to full screen
        else if blEvent.value = "collapsed"
            ' microsite was collapsed and closed
        end if
    else if blEvent.type = "DL"
        ' This event is fired only by Conversion Template. It indicates when user presses on template
        ' blEvent.value will contain deeplink string for this conversion screen
    end if
end sub