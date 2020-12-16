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
    {"steal"},
    function(args)
        if args[1] == "bobux" then
            utils:chat("how about i steal yours?")
        elseif args[1] == "money" then
            utils:chat("i dont see any rich people here to steal from")
        else
            utils:chat("no i dont steal "..args[1])
        end
    end
)

plugin:ChatCommand(
    {"die"},
    function()
        Player.Character.Humanoid.Health = 0
    end
)

return plugin