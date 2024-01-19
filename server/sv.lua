local QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory
local DISCORD_WEBHOOK_URL = Config.DiscordWebhook

function SendDiscordWebhookMessage(source, wash, percent)
    local data = {
        embeds = {
            {
                title = "Washing machine logs",
                description = string.format("Player ID: %s\nMoney Washed: %s\nReceived: %s", source, wash, percent),
                color = 65280, -- Optional: Color for the embed in decimal format
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ') -- Optional: Timestamp in ISO 8601 format
            }
        }
    }
    PerformHttpRequest(DISCORD_WEBHOOK_URL, function(statusCode, responseData, headers)
        -- Handle the response here (optional)
        print("Discord webhook message sent:", statusCode)
        print(responseData)
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end
RegisterNetEvent('sqc:server:check:job')
AddEventHandler('sqc:server:check:job', function()
 local source = source
 local xPlayer = QBCore.Functions.GetPlayer(source)
 local hasJob = false

if Config.jobRestriction then
 for _ , v in ipairs(Config.whiteListJobs) do
   if xPlayer.getJob().name == v then
    TriggerClientEvent('sqc:client:allowed:job', source)
    hasJob = true
    return
   end
end
end
if not Config.jobRestriction then
    TriggerClientEvent('sqc:client:allowed:job', source)
    return
end
if not hasJob then
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Washing machine',
        description = 'You dont have the required job to do this.',
        duration = 5000,
        type = 'error',
        icon = 'fa-solid fa-money-bill-1-wave'
    })
end
end)
RegisterNetEvent('sqc:server:washingMoney')
AddEventHandler('sqc:server:washingMoney', function(chance, hasMoney, id, distance, playerPos, wash)
    if chance      == nil then return end
    if hasMoney    == nil then return end
    if id          == nil then return end
    if distance    == nil then return end
    if playerPos   == nil then return end
    if wash        == nil then return end

    local source    = source
    local sourcePed = GetPlayerPed(source)
    local sourcePos = GetEntityCoords(sourcePed)
    local countItem = ox_inventory:Search(source, 'count', 'black_money')
    local percent   = wash * Config.percentage

    if countItem <= 10 then
        return
    else
        if ox_inventory:CanCarryItem(source, 'money', percent) then
            ox_inventory:RemoveItem(source, 'black_money', wash)
            ox_inventory:AddItem(source, 'money', percent)
            SendDiscordWebhookMessage(source, wash, percent)
        end
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Washing machine',
            description = 'You have washed '..wash..' and received '..percent,
            duration = 4000,
            type = 'success',
            icon = 'fa-solid fa-money-bill-1-wave'
        })
    end
end)
