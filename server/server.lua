--? Register net events
RegisterNetEvent('dualcore_healthsystem:server:UpdateMeta', function(health, armor)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local safeHealth = math.max(0, math.min(health, 200))
    local safeArmor = math.max(0, math.min(armor, 100))

    Player.Functions.SetMetaData('health', safeHealth)
    Player.Functions.SetMetaData('armor', safeArmor)

    if Config.debugThreadSpam then
        DebugPrint(('Saving metadata (Loop/Logout) ID %s -> Health: %s | Armor: %s'):format(src, safeHealth, safeArmor))
    end
end)

--? Event handlers
AddEventHandler('playerDropped', function(reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        local ped = GetPlayerPed(src)

        if DoesEntityExist(ped) then
            local health = GetEntityHealth(ped)
            local armor = GetPedArmour(ped)

            if health > 0 then
                DebugPrint(('Player with ID %s disconnected (%s). Saving -> Health: %s | Armor: %s'):format(src, reason, health, armor))

                local safeHealth = math.max(0, math.min(health, 200))
                local safeArmor = math.max(0, math.min(armor, 100))

                Player.Functions.SetMetaData('health', safeHealth)
                Player.Functions.SetMetaData('armor', safeArmor)
                Player.Functions.Save()
            else
                DebugPrint(('Player with ID %s disconnected (%s). Health is 0 (dead), won\'t be saved.'):format(src,
                    reason))
            end
        else
            DebugPrint(('Player with ID %s disconnected (%s). Entity does not exist anymore, relying on last OnPlayerUnload save.') :format(src, reason))
        end
    end
end)
