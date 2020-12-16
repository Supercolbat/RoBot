local Player = game:GetService("Players").LocalPlayer

local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/PluginFramework.lua"))()
local plugin = framework:NewPlugin()
local utils = plugin:utils()


plugin:ChatCommand(
    {"hello"},
    function()
        utils:chat("hello")
    end
)

plugin:ChatCommand(
    {"steal"},
    function(data)
        if data["args"][1] == "bobux" then
            utils:chat("what if i steal YOUR bobux?")
        elseif data["args"][1] == "money" then
            utils:chat("i dont see any rich people here to steal from")
        else
            utils:chat("no i dont steal "..table.concat({table.unpack(data["args"])}, ' '))
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