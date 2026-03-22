--? Functions
local function RefreshHudVisuals()
    local ped = PlayerPedId()
    local healthValue = math.max(0, GetEntityHealth(ped) - 100)
    local armorValue = GetPedArmour(ped)

    exports['dualcore_hud']:updateHud('health', healthValue)
    exports['dualcore_hud']:updateHud('armor', armorValue)
    DebugPrint('HUD synchronized: Health: ' .. healthValue .. ' | Armor: ' .. armorValue)
end

--? Register net events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    DebugPrint('OnPlayerLoaded event executed. Preparing health system...')
    local PlayerData = QBCore.Functions.GetPlayerData()

    local savedHealth = PlayerData.metadata['health']
    local savedArmor = PlayerData.metadata['armor']

    DebugPrint(('DB data -> Health: %s | Armor: %s'):format(tostring(savedHealth), tostring(savedArmor)))

    CreateThread(function()
        while not IsScreenFadedIn() do
            Wait(500)
        end

        if Config.hasToWait then
            DebugPrint('Screen visible. Waiting ' .. Config.waitTime .. ' for the other scripts to load...')
            Wait(Config.waitTime)
        else
            DebugPrint('Screen visible. Applying statuses')
        end

        local ped = PlayerPedId()

        if savedHealth and savedHealth > 0 then
            SetEntityHealth(ped, savedHealth)
            DebugPrint('Initial health applied: ' .. savedHealth)
        end

        if savedArmor then
            SetPedArmour(ped, savedArmor)
            DebugPrint('Initial armor applied: ' .. savedArmor)
        end

        if Config.useDualcoreHud then
            RefreshHudVisuals()
        elseif Config.useHudUpdate then
            CustomHudUpdate()
        else
            DebugPrint('Nothing to do here with your hud <3')
        end

        if savedHealth and savedHealth > 0 then
            local ticks = 0
            while ticks < 10 do
                Wait(1000)
                ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)

                if currentHealth > savedHealth and currentHealth >= 200 then
                    DebugPrint('Warning! Some other script revived the player. Re-applying saved health: ' .. savedHealth)
                    SetEntityHealth(ped, savedHealth)
                end
                ticks = ticks + 1
            end
        end

        DebugPrint('Health loading finalized successfully')
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    local ped = PlayerPedId()

    if not IsEntityDead(ped) then
        local currentHealth = GetEntityHealth(ped)
        local currentArmor = GetPedArmour(ped)
        DebugPrint(('Logout detected. Saving -> Health: %s | Armor: %s'):format(currentHealth, currentArmor))
        TriggerServerEvent('dualcore_healthsystem:server:UpdateMeta', currentHealth, currentArmor)
    end
end)

--? Threads
CreateThread(function()
    local lastHealth = -1
    local lastArmor = -1

    while true do
        Wait(60000)

        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()

            if not IsEntityDead(ped) then
                local currentHealth = GetEntityHealth(ped)
                local currentArmor = GetPedArmour(ped)
                if currentHealth ~= lastHealth or currentArmor ~= lastArmor then
                    TriggerServerEvent('dualcore_healthsystem:server:UpdateMeta', currentHealth, currentArmor)
                    lastHealth = currentHealth
                    lastArmor = currentArmor
                end
            end
        end
    end
end)
