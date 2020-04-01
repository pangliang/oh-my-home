--- 窗口位置
hs.grid.setGrid('8x4')
hs.grid.ui.showExtraKeys = false
hs.window.animationDuration = 0

-- 预览grid
hs.hotkey.bind({"alt", "shift"}, "w", function()
    hs.grid.toggleShow(nil, false)
end)

-- 左半屏
hs.hotkey.bind({"alt"}, "a", function()
    hs.grid.set(hs.window.focusedWindow(), '0,0 4x4')
end)

--右半屏
hs.hotkey.bind({"alt"}, "d", function()
    hs.grid.set(hs.window.focusedWindow(), '4,0 4x4')
end)

--满屏
hs.hotkey.bind({"alt"}, "w", function()
    hs.grid.set(hs.window.focusedWindow(), '0,0 8x4')
end)

--中间
hs.hotkey.bind({"alt"}, "s", function()
    hs.grid.set(hs.window.focusedWindow(), '1,0 6x4')
end)

--左上
hs.hotkey.bind({"alt"}, "q", function()
    hs.grid.set(hs.window.focusedWindow(), '0,0 4x2')
end)

--左下
hs.hotkey.bind({"alt"}, "z", function()
    hs.grid.set(hs.window.focusedWindow(), '0,2 4x2')
end)

--右上
hs.hotkey.bind({"alt"}, "e", function()
    hs.grid.set(hs.window.focusedWindow(), '4,0 4x2')
end)

--右下
hs.hotkey.bind({"alt"}, "c", function()
    hs.grid.set(hs.window.focusedWindow(), '4,2 4x2')
end)