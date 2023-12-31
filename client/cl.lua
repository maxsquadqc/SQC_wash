ESX = exports['es_extended']:getSharedObject()

local function cleanMoney()
    local playerId = PlayerPedId()
    local playerPos  = GetEntityCoords(playerId)
    local hasMoney = exports.ox_inventory:Search('count', 'black_money')
    local luck     = math.random(1, 10)
    local input = lib.inputDialog('washing machine', {
        {type = 'number', label = 'Min = '..Config.Min..' , Max = '..Config.Max, description = 'Clean ur dirty money bad boy'},
      })
      if not input then
        lib.notify({
            title         = 'Error Exited',
            description   = 'Canceled',
            type          = 'error',
            icon          = 'fa-solid fa-circle-exclamation'
        })
         return end
      local wash = tonumber(input[1])
    
      if not wash then
        lib.notify({
            title         = 'Error amount',
            description   = 'You didnt enter amounts ',
            type          = 'error',
            icon          = 'fa-solid fa-circle-exclamation'
        })
         return end

         if wash > hasMoney then
            lib.notify({
                title         = 'Error pocket',
                description   = 'You dont have that amount in the pocket little boy',
                type          = 'error',
                icon          = 'fa-solid fa-circle-exclamation'
            })
            return
        end

         if wash < Config.Min or wash > Config.Max then
            lib.notify({
                title         = 'Error Washing',
                description   = 'Amount must be between 10 and 100,000.',
                type          = 'error',
                icon          = 'fa-solid fa-circle-exclamation'
            })
            return
        
        end

    if hasMoney >= wash then
        for k, vector in pairs(Config.washing) do
            local dist = #(playerPos - vector.loc)

            if dist > 1.5 then
                if luck < 9 then
                    if lib.progressCircle({
                        duration       = wash / 2,
                        position       = 'bottom',
                        useWhileDead   = false,
                        canCancel      = true,
                        disable        = {car = true, move = true},
                        anim           = {
                            dict       = 'mp_player_intdrink', -- 'mp_player_intdrink'
                            clip       = 'loop_bottle'  -- 'loop_bottle'
                        }
                    }) then
                        TriggerServerEvent('sqc:server:washingMoney', luck, hasMoney, playerId, dist, playerPos, wash)
                        
                    end
                else
                    lib.notify({
                        title         = 'Washing Machine',
                        description   = 'Police have been warned get out!',
                        type          = 'error',
                        icon          = 'fa-sharp fa-solid fa-siren-on'
                    })
                end
            end
        end
   return end
end

for shop, data in pairs(Config.washing) do
    local xPlayer = ESX.GetPlayerData()
    local point = lib.points.new(data.loc, 2, {})

    function point:onEnter()
        
        lib.showTextUI('[E] - Wash money', {
            position              = "right-center",
            icon                  = 'hand',
            style                 = {
                borderRadius      = 0,
                backgroundColor   = '#00001a',
                color             = 'white'
            }
        })
        
    end

    function point:onExit() lib.hideTextUI() end

    function point:nearby()
        if self.currentDistance < 2 then
            DrawMarker(29, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
        end

        if self.currentDistance < 2 and IsControlJustPressed(0, 38) then
            TriggerServerEvent('sqc:server:check:job')
        end
    end
end

RegisterNetEvent('sqc:client:allowed:job')
AddEventHandler('sqc:client:allowed:job', function()
    cleanMoney()
end)