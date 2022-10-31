sub init()
    m.list = m.top.FindNode("list")
    m.top.ObserveFieldScoped("focusedChild", "OnFocusChanged")
    m.top.ObserveFieldScoped("content", "OnContentChanged")
end sub

sub OnFocusChanged()
    if m.top.HasFocus()
        m.list.SetFocus(true)
    end if
end sub

sub OnContentChanged()
    m.list.content = m.top.content
end sub
