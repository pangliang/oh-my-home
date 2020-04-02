
local log = hs.logger.new('alfred', 'debug')
local alfred = {}
local plugins = plugins or {}


plugins.lock = {
    title = "电脑锁屏",
    completionCallback = function(value)
        log.f("lock: %s", hs.inspect(value))
        --hs.caffeinate.lockScreen()
    end
}

local chooser = hs.chooser.new(function(chosen)
    log.f("completionCallback: %s", hs.inspect(chosen))
    alfred.chooser:query('')
    if nil == chosen or nil == plugins[chosen.plugin] then
        log.f("chosen.plugin not found")
        return
    end
    local plugin = plugins[chosen.plugin]
    local arg = string.match(chosen.value, "^"..chosen.plugin.." (.+)")
    if not plugin.argRequired or nil ~= arg then
        plugin.completionCallback(arg)
    else
        if plugin.choices then
            alfred.chooser:queryChangedCallback()
            local datas = plugin.choices("")
            for i, d in ipairs(datas) do
                d.plugin = chosen.plugin
                d.value = string.format("%s %s", chosen.plugin, d.value)
            end
            alfred.chooser:choices(datas)
        else
            alfred.chooser:queryChangedCallback(function (queryStr)
                alfred.chooser:choices({{ text = plugin.title, plugin = chosen.plugin, value = chosen.plugin.." "..queryStr}})
            end)
        end

        alfred.chooser:show()
    end
end)
chooser:placeholderText("输入指令")
chooser:searchSubText(true)

hs.hotkey.bind({ 'ctrl' }, "g", function()
    chooser:queryChangedCallback(function (queryStr)
        log.f("queryChangedCallback: %s", queryStr)
        local choices = {}
        for plugin_name, plugin in pairs(plugins) do
            if nil ~= string.match(plugin_name, "^"..queryStr) or nil ~= string.match(queryStr, "^".. plugin_name) then
                local datas = plugin.choices and plugin.choices(queryStr) or { { text = plugin.title, subText = plugin.subText, plugin = plugin_name, value = queryStr}}
                for i, d in ipairs(datas) do
                    d.plugin = plugin_name
                    d.value = string.format("%s %s", plugin_name, d.value)
                end
                hs.fnutils.concat(choices, datas)
            end
        end
        chooser:choices(choices)
    end)
    chooser:show()
end)

alfred.chooser = chooser