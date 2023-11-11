ESX = exports['es_extended']:getSharedObject()

function animChance()
    local playerId = PlayerPedId()
    local playerC  = GetEntityCoords(playerId)
    local hasMoney = exports.ox_inventory:Search('count', 'black_money')
    local luck     = math.random(1, 10)

    local input = lib.inputDialog('washing machine', {
        {type = 'number', label = 'Min = 10 , Max 100k', description = 'Clean ur dirty money bad boy'},
      })

      if not input then
        lib.notify({
            title         = 'Error Exited',
            description   = 'Canceled',
            type          = 'error',
            icon          = 'fa-solid fa-money-bill-1-wave'
        })
         return end
      local wash = tonumber(input[1])
    
      if not wash then
        lib.notify({
            title         = 'Error amount',
            description   = 'You didnt enter amounts',
            type          = 'error',
            icon          = 'fa-solid fa-money-bill-1-wave'
        })
         return end

         if wash > hasMoney then
            lib.notify({
                title         = 'Error pocket',
                description   = 'You dont have that amount in the pocket little boy',
                type          = 'error',
                icon          = 'fa-solid fa-money-bill-1-wave'
            })
            return
        end

         if wash < 10 or wash > 100000 then
            lib.notify({
                title         = 'Error Washing (10-100k)',
                description   = 'Amount must be between 10 and 100,000.',
                type          = 'error',
                icon          = 'fa-solid fa-money-bill-1-wave'
            })
            return
        end


    if hasMoney >= wash then
        for k, vector in pairs(Config.washing) do
            local dist = #(playerC - vector)

            if dist >= 1 then
                if luck < 9 then
                    if lib.progressCircle({
                        duration       = wash / 2,
                        position       = 'bottom',
                        useWhileDead   = false,
                        canCancel      = false,
                        disable        = {car = true, move = true},
                        anim           = {
                            dict       = 'mp_player_intdrink', -- 'mp_player_intdrink'
                            clip       = 'loop_bottle'  -- 'loop_bottle'
                        }
                    }) then
                        TriggerServerEvent('sqc:washingMoney', luck, hasMoney, playerId, dist, playerC, wash)
                        
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

for k, v in pairs(Config.washing) do

    local point = lib.points.new(v, 5, {})

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
        if self.currentDistance < 3 then
            DrawMarker(29, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
        end

        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            animChance()
        end
    end
end