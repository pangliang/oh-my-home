
local menubar = hs.menubar.new()
local menuData = {}

local titleFont = {name='UbuntuMonoDerivativePowerline-Regular', size=16.0}
local subMenuFont = {name='Consolas', size=14.0}
local colorRed = {hex="#d8345f"}
local colorGreen = {hex="#4cbbb9"}

local usStock = {
    '^DJI'
    ,'^SPX'
    ,'^IXIC'
    ,'BABA'
    ,'NTES'
    ,'BAC'
    ,'C'
    ,'WFC'
    ,'DAL'
    ,'AAL'
}

local chinaStock = {
    '000001.SS'
    ,'399001.SZ'
    ,'399006.SZ'
    ,'0700.HK'
    ,'9988.HK'
    ,'9999.HK'
    ,'9618.HK'
}

function updateMenubar()
    local stocks = tonumber(os.date("%H")) >= 16 and usStock or chinaStock
    local url = string.format("https://query1.finance.yahoo.com/v7/finance/quote?symbols=%s", hs.http.encodeForQuery(table.concat(stocks, ",")))
    hs.http.asyncGet(url, nil, function(code, body, htable)
        if code ~= 200 then
            print('get weather error:' .. code)
            return
        end
        rawjson = hs.json.decode(body)
        menuData = {}
        local title = ""
        for k, v in pairs(rawjson.quoteResponse.result) do
            print(hs.inspect(v))
            local price, change, changePercent = 0
            if v.preMarketTime ~= nil and v.preMarketTime > v.regularMarketTime then
                price = v.preMarketPrice
                change = v.preMarketChange
                changePercent = v.preMarketChangePercent
            else
                price = v.regularMarketPrice
                change = v.regularMarketChange
                changePercent = v.regularMarketChangePercent
            end
            local pColor = change < 0 and colorGreen or colorRed

            if k <= 3 then
                title = title
                    ..hs.styledtext.new(
                        string.format("%10s", v.symbol)
                        ,{ font = subMenuFont }
                    )
                    ..hs.styledtext.new(
                        string.format("%s %5.2f%%", change > 0 and '↑' or '↓', changePercent)
                        ,{ font = subMenuFont, color = pColor }
                    )
                if k == 3 then
                    menubar:setTitle(title)

                    table.insert(menuData, { title = hs.styledtext.new(
                                os.date('%Y-%m-%d %H:%M:%S', v.regularMarketTime)
                                ,{ font = subMenuFont }
                            )}
                    )
                    table.insert(menuData, { title = '-' })
                end
            else
                table.insert(menuData, { title = 
                    hs.styledtext.new(
                        string.format("%-9s\t%8.2f", v.symbol, price)
                        ,{ font = subMenuFont }
                    )
                    ..hs.styledtext.new(
                        string.format("\t%s %7.2f\t%5.2f%%", change > 0 and '↑' or '↓', change, changePercent)
                        ,{ font = subMenuFont, color = pColor }
                    )
                })
            end
            
        end
        menubar:setMenu(menuData)
    end)
end

menubar:setTooltip("My Stock")
menubar:setTitle('⌛')
updateMenubar()
stockTimer = hs.timer.doEvery(60, updateMenubar, true)






