--- 测试用
hs.hotkey.bind({ 'ctrl', 'shift' }, "d", function()
    local win = hs.window.focusedWindow()
    local info = string.format("App path:        %s\nApp name:      %s\nIM source id:  %s",
            win:application():path(),
            win:application():name(),
            hs.keycodes.currentSourceID())

    hs.alert.show(info)
    hs.notify.new({ title = "appinfo", informativeText = info }):send()
end
)
