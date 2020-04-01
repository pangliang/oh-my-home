-- 监控配置文件变动, 自动加载
function reloadConfig(files)
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            hs.reload()
            return
        end
    end
end
myWatcher = hs.pathwatcher.new("~/.hammerspoon/", reloadConfig):start()
hs.alert.show("配置重新加载完成")

-- 允许按appname 搜索
hs.application.enableSpotlightForNameSearches(true)
