ESX = exports['es_extended']:getSharedObject()
local ox_inventory = exports.ox_inventory
local DISCORD_WEBHOOK_URL = Config.DiscordWebhook

function SendDiscordWebhookMessage(source, wash, percent)
    local data = {
        embeds = {
            {
                title = "Washing machine logs",
                description = string.format("Player ID: %s\nMoney Washed: %s\nReceived: %s", source, wash, percent),
                color = 65280,
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
            }
        }
    }
    PerformHttpRequest(DISCORD_WEBHOOK_URL, function(statusCode, responseData, headers)
        if statusCode == 200 then
            print("Discord webhook message sent successfully")
        else
            print("Failed to send Discord webhook message:", statusCode)
            print(responseData)
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/JSON' })
end

RegisterNetEvent('sqc:server:check:job')
AddEventHandler('sqc:server:check:job', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if not Config.jobRestriction or IsJobWhitelisted(xPlayer.getJob().name) then
        TriggerClientEvent('sqc:client:allowed:job', source)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Washing machine',
            description = 'You do not have the required job to do this.',
            duration = 5000,
            type = 'error',
            icon = 'fa-solid fa-money-bill-1-wave'
        })
    end
end)

function IsJobWhitelisted(jobName)
    for _, v in ipairs(Config.whiteListJobs) do
        if jobName == v then
            return true
        end
    end
    return false
end

RegisterNetEvent('sqc:server:washingMoney')
AddEventHandler('sqc:server:washingMoney', function(chance, hasMoney, id, distance, playerPos, wash)
    if not chance or not hasMoney or not id or not distance or not playerPos or not wash then
        return
    end

    local source = source
    local sourcePed = GetPlayerPed(source)
    local sourcePos = GetEntityCoords(sourcePed)
    local countItem = ox_inventory:Search(source, 'count', 'black_money')
    local percent = wash * Config.percentage

    if countItem > 10 and ox_inventory:CanCarryItem(source, 'money', percent) then
        ox_inventory:RemoveItem(source, 'black_money', wash)
        ox_inventory:AddItem(source, 'money', percent)
        SendDiscordWebhookMessage(source, wash, percent)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Washing machine',
            description = string.format('You have washed %s and received %s', wash, percent),
            duration = 4000,
            type = 'success',
            icon = 'fa-solid fa-money-bill-1-wave'
        })
    end
end)
