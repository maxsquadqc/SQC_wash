ESX = exports['es_extended']:getSharedObject()
local ox_inventory = exports.ox_inventory

RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)

  end)

RegisterNetEvent('sqc:washingMoney')
AddEventHandler('sqc:washingMoney', function(chance, hasMoney, id, distance, playerPos, wash)
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
