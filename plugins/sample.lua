local framework = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Supercolbat/RoBot/master/PluginFramework.lua")))
local plugin = framework:NewPlugin()
local utils = plugin:utils()

local Player = game:GetService("Players").LocalPlayer

plugin:ChatCommand(
    {"hello"},
    function()
        utils:chat("hello")
    end
)

plugin:ChatCommand(
    {"die", "kpop"},
    function()
        Player.Character.Humanoid.Health = 0
    end
)

return plugin