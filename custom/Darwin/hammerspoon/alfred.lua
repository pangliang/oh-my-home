
local workflow = workflow or {}

workflow.lock = {
    title = "电脑锁屏", subText = nil,
    completionCallback = function(chosen)
        hs.caffeinate.lockScreen()
    end
}

local log = hs.logger.new('alfred', 'debug')
local chooser = hs.chooser.new(function(chosen)
    if nil == chosen or nil == workflow[chosen.modelName] then
        return
    end
    local w = workflow[chosen.modelName]
    if nil ~= w.completionCallback then
        w.completionCallback(chosen)
    elseif nil ~= w.chooser then
        w.chooser:show()
    end
end)
chooser:placeholderText("输入指令")
chooser:searchSubText(true)

chooser:queryChangedCallback(function (queryStr)
    log.f("queryChangedCallback: %s", queryStr)
    local choices = {}
    for modelName, model in pairs(workflow) do
        if nil ~= string.match(modelName, "^"..queryStr) or nil ~= string.match(queryStr, "^"..modelName) then
            table.insert(choices, {text = model.title, subText = model.subText, modelName = modelName})
        end
    end
    chooser:choices(choices)
    chooser:refreshChoicesCallback()
end)

hs.hotkey.bind({ 'alt' }, "f", function()
    chooser:show()
end)