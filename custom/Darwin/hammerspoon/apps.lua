-- 启动/获得应用焦点

function toggleActivate(app)
    if(not app:isFrontmost() or app:isHidden()) then
        app:activate()
    else
        app:hide()
    end
end

-- 钉钉
hs.hotkey.bind({"ctrl"}, "d", function()
    toggleActivate(hs.application.get('钉钉'))
end)

-- chrome
hs.hotkey.bind({"ctrl"}, "q", function()
    toggleActivate(hs.application.get('Google Chrome'))
end)

-- watcher
hs.application.watcher.new(function (appName, eventType, appObject)
    print(string.format("app:%s, event:%s, obj:%s", appName, eventType, appObject))
end):start()