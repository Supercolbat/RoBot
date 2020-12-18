local Player = game:GetService("Players").LocalPlayer

local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/ModuleFramework.lua"))()
local module_ = framework:NewModule()
local utils = module_:utils()


module_:ChatCommand(
    {"hello"},
    function()
        utils:chat("hello")
    end
)

module_:ChatCommand(
    {"steal"},
    function(data)
        if data["args"][1] == "bobux" then
            utils:chat("what if i steal YOUR bobux?")
        elseif data["args"][1] == "money" then
            utils:chat("i dont see any rich people here to steal from")
        else
            utils:chat("what is "..utils:JoinString(data["args"]))
        end
    end
)

module_:ChatCommand(
    {"die"},
    function()
        Player.Character.Humanoid.Health = 0
    end
)


return module_