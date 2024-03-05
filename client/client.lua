local AFK = false

--- ==== CONFIG ======

local AFKArea = Config.AFKArea -- AFK Area upon doing /startafk
local AFKBack = Config.AFKBack -- AFK Sendback area upon doing /stopafk

local AFKDisabledText = "AFK Successfully Disabled." -- Set the AFK Disabled Chat Text
local AFKEnabledText = "AFK Successfully Enabled." -- Set the AFK Enabled Chat Text

local Invincibility = true --- Set this to true if you want the player to be invincible when in the AFK Area.
local RadiusLimit = 20.0 --- Set the maximum radius distance for AFK mode.

--- ==== CONFIG ======

local AFKTextVisible = false

RegisterCommand(Config.AFKStartCmd, function(source, args, rawCommand)
    local coords = AFKArea
    StartPlayerTeleport(PlayerId(), coords.x, coords.y, coords.z, 0.0, false, true, true) 

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            if AFKTextVisible then
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.2, 0.3)
                SetTextColour(0, 255, 0, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow(0)
                SetTextOutline(0)
                SetTextEntry("STRING")
                AddTextComponentString(Config.AFKTextMessage)
                DrawText(0.450, 0.005)
            end
        end
    end)

    print(GetPlayerName(PlayerId()), " Is now AFK!")

    local playerName = GetPlayerName(PlayerId())
    TriggerServerEvent('sendToDiscord', playerName)

    SetEntityAlpha(PlayerPedId(), 51, false)

    AFK = true
    AFKTextVisible = true 

    TriggerEvent("chatMessage", "SYSTEM", {0, 255, 0}, AFKEnabledText)

    if Invincibility then
        SetEntityInvincible(PlayerPedId(), true)
        print("Player is Invincible!")
    else
        print("Didn't set invincible as the Config is off!")
    end
end)


RegisterCommand(Config.AFKStopCmd, function(source, args, rawCommand) 
    if AFK then
        ClearPrints()
        AFKTextVisible = false
        local coords2 = AFKBack
        StartPlayerTeleport(PlayerId(), coords2.x, coords2.y, coords2.z, 0.0, false, true, true) 
        AFK = false

        TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, AFKDisabledText)

        local playerName2 = GetPlayerName(PlayerId())
        TriggerServerEvent('sendToDiscord2', playerName2)
        ResetEntityAlpha(PlayerPedId())
        SetEntityInvincible(PlayerPedId(), false)
    else
        print("Player isn't AFK, Can't teleport them back.")
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if AFK then
            local playerPos = GetEntityCoords(PlayerPedId(), false)
            local distance = #(playerPos - AFKArea)

            if distance > RadiusLimit then
                TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Sorry, you can't move too far away from the AFK Area.")
                local coords2 = AFKArea
                StartPlayerTeleport(PlayerId(), coords2.x, coords2.y, coords2.z, 0.0, false, true, true) 
            end
        end
    end
end)
