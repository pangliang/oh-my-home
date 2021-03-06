local urlApi = 'https://www.tianqiapi.com/api/?version=v1&appid=' .. tianqiapi_appid .. '&appsecret=' .. tianqiapi_appsecret
local menubar = hs.menubar.new()
local menuData = {}

local weaEmoji = {
    lei = '⛈',
    qing = '☀️',
    shachen = '😷',
    wu = '🌫',
    xue = '❄️',
    yu = '🌧',
    yujiaxue = '🌨',
    yun = '☁️',
    zhenyu = '🌧',
    yin = '⛅️',
    default = ''
}

function getWeather()
    hs.http.doAsyncRequest(urlApi, "GET", nil, nil, function(code, body, htable)
        if code ~= 200 then
            print('get weather error:' .. code)
            return
        end
        rawjson = hs.json.decode(body)
        city = rawjson.city
        menuData = {}
        for k, v in pairs(rawjson.data) do
            if k == 1 then
                menubar:setTitle(string.format("%s %s-%s", weaEmoji[v.wea_img], v.tem2, v.tem1))
                titlestr = string.format("%s %s %s 🌡️%s 💧%s 💨%s 🌬 %s %s", city, weaEmoji[v.wea_img], v.day, v.tem, v.humidity, v.air, v.win_speed, v.wea)
                table.insert(menuData, { title = titlestr })
                table.insert(menuData, { title = '-' })
            else
                -- titlestr = string.format("%s %s %s %s", v.day, v.wea, v.tem, v.win_speed)
                titlestr = string.format("%s %s %s 🌡️%s-%s 🌬%s %s", city, weaEmoji[v.wea_img], v.day, v.tem2, v.tem1, v.win_speed, v.wea)
                item = { title = titlestr }
                table.insert(menuData, item)
            end
        end
        menubar:setMenu(menuData)
    end)
end

menubar:setTooltip("Weather Info")
menubar:setTitle('⌛')
getWeather()
weatherTimer = hs.timer.doEvery(3600, getWeather, true)