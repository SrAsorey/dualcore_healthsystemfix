--? Core function
-- This thing it's not obligatory but I have a little toc with organization hehe <3
QBCore = exports['qb-core']:GetCoreObject()

--? Debug function
function DebugPrint(msg)
    if Config.debug then print("[Dualcore Health Fixes] " .. msg) end
end

if GetCurrentResourceName() ~= 'dualcore_healthsystemfix' then
    print('^1=======================================================^7')
    print('^1[ERROR] Execution bloqued for security.^7')
    print('^1[ERROR] The script has to be named: "dualcore_healthsystemfix"^7')
    print('^1=======================================================^7')
    print("^3Script start fail: Don\'t change the resource name please, be king and give me credits.")
end