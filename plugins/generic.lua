local Player = game:GetService("Players").LocalPlayer

local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/PluginFramework.lua"))()
local plugin = framework:NewPlugin()
local utils = plugin:utils()


plugin:ChatCommand(
    {"joke"},
    function()
        local joke = utils:HttpGet("https://official-joke-api.appspot.com/random_joke", "json")
        utils:chat(joke.setup, joke.punchline)
    end
)


return plugin