local urlApi = 'https://data.gateio.life/api2/1/ticker/'

local tickers = {
    'BTC_USDT',
    'USDT_CNY',
    'HNS_USDT',
    'HNS_BTC',
}
local titleFont = {name='UbuntuMonoDerivativePowerline-Regular', size=16.0}
local subMenuFont = {name='Consolas', size=14.0}
local colorRed = {hex="#d8345f"}
local colorGreen = {hex="#4cbbb9"}

local menubar = hs.menubar.new()

function updateMenu()
    local menuData = {}
    local datas = {}
    for i, ticker in ipairs(tickers) do
        hs.http.doAsyncRequest(urlApi .. ticker, "GET", nil, nil, function(code, body, htable)
            if code ~= 200 then
                print('get gateio error:' .. code) 
                return
            end
            local rawjson = hs.json.decode(body)
            datas[ticker] = rawjson
            table.insert(menuData, { title = 
                hs.styledtext.new(string.format("%9s %10.3f", ticker, rawjson.last), { font = subMenuFont })
                .. hs.styledtext.new(string.format("  %+0.2f%%", rawjson.percentChange), { font = subMenuFont, color = tonumber(rawjson.percentChange)<0 and colorGreen or colorRed })
            })
    
            menubar:setTitle(
                hs.styledtext.new(string.format("HNS: %0.2f", datas['HNS_USDT'].last * datas['USDT_CNY'].last * 4246.88), {font=titleFont})
                .. hs.styledtext.new(string.format(" %+0.2f%%", datas['HNS_USDT'].percentChange), {font=titleFont, color= tonumber(datas['HNS_USDT'].percentChange)<0 and colorGreen or colorRed})
            )
    
            menubar:setMenu(menuData)
        end)
    end
    
end

menubar:setTitle('⌛')
menubar:setTooltip("GateIO")

updateMenu()
gateioTimer = hs.timer.doEvery(60, updateMenu, true)