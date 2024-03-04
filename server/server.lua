




RegisterServerEvent('sendToDiscord')
AddEventHandler('sendToDiscord', function(playerName)
    local embed = {
        {
            ["color"] = Config.AFKStartColor,
            ["title"] = "Player Just Went AFK.",
            ["description"] = "The Player With The Name Of " .. playerName .. " Is Now AFK!",
            ["footer"] = {
                ["text"] = "d_afksystem"
            }
        }
    }

    PerformHttpRequest(Config.DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ embeds = embed }), { ['Content-Type'] = 'application/json' })
end)


RegisterServerEvent('sendToDiscord2')
AddEventHandler('sendToDiscord2', function(playerName)
    local embed = {
        {
            ["color"] = Config.AFKStopColor,
            ["title"] = "Player Just Came Back From AFK!",
            ["description"] = "The Player With The Name Of " .. playerName .. " Is Now Not AFK!",
            ["footer"] = {
                ["text"] = "d_afksystem"
            }
        }
    }

    PerformHttpRequest(Config.DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ embeds = embed }), { ['Content-Type'] = 'application/json' })
end)
