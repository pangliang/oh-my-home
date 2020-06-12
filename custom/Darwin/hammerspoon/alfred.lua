
local log = hs.logger.new('alfred', 'debug')
local alfred = {}
local plugins = plugins or {}


plugins.lock = {
    title = "电脑锁屏",
    completionCallback = function(value)
        log.f("lock: %s", hs.inspect(value))
        hs.caffeinate.lockScreen()
    end
}

plugins.calc = {
    title = "calc",
    choices = function(query)
        local choices = {}
        if query == nil or query == "" then
            return choices
        end
    
        -- Filter out commas and dollar signs
        query, _ = query:gsub("[%,%$]", "")
    
        -- We need to determine if the query only contains mathematical calculations
        -- To do this we'll see if it matches the inverse of that set of characters
        if string.match(query, "[^%d^%.^%+^%-^/^%*^%^^ ^%(^%)]") == nil then
            local compile_result, fn = load("return " .. query)
            if type(compile_result) == "function" then
                local result = compile_result()
                table.insert(choices, {text=result, value=result})
            end
        end
        return choices
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
    if plugin.argRequired == false or nil ~= arg then
        plugin.completionCallback(arg)
    else
        alfred.chooser:queryChangedCallback(function (queryStr)
            log.f("plugin.choices queryChangedCallback: %s", queryStr)
            local choices = {}
            if plugin.choices then
                for i, d in ipairs(plugin.choices(queryStr)) do
                    if nil ~= string.match(d.text, queryStr) or nil ~= string.match(d.subText, queryStr) then
                        d.plugin = chosen.plugin
                        d.value = string.format("%s %s", chosen.plugin, d.value)
                        hs.fnutils.concat(choices, {d})
                    end
                end
            end
            if #choices == 0 then
                hs.fnutils.concat(choices, {{ text = plugin.title, subText = queryStr, plugin = chosen.plugin, value = string.format("%s %s", chosen.plugin, queryStr)}})
            end
            alfred.chooser:choices(choices)
        end)
        alfred.chooser:show()
    end
end)
chooser:searchSubText(true)

hs.hotkey.bind({ 'ctrl' }, 'g', function()
    chooser:placeholderText("输入指令")
    chooser:queryChangedCallback(function (queryStr)
        log.f("queryChangedCallback: %s", queryStr)
        local choices = {}
        for plugin_name, plugin in pairs(plugins) do
            if nil ~= string.match(plugin_name, "^"..queryStr) or nil ~= string.match(queryStr, "^".. plugin_name) then
                local datas = {{ text = plugin.title, subText = plugin.subText, plugin = plugin_name, value = string.format("%s", queryStr)}}
                hs.fnutils.concat(choices, datas)
            end
        end
        chooser:choices(choices)
    end)
    chooser:show()
end)

alfred.chooser = chooser