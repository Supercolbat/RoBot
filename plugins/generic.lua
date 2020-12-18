local LocalPlayer = game:GetService("Players").LocalPlayer

local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/ModuleFramework.lua"))()
local module_ = framework:NewModule()
local utils = module_:utils()


module_:ChatCommand(
    {"joke"},
    function()
        local joke = utils:HttpGet("https://official-joke-api.appspot.com/random_joke", true)
        utils:chat(joke.setup .. ' ' .. joke.punchline)
    end
)

module_:ChatCommand(
    {"say"},
    function(data)
        utils:chat(utils:JoinString(data["args"]))
    end
)

module_:ChatCommand(
    {"bring"},
    function(data)
        LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[data["sender"]].Character.HumanoidRootPart.CFrame
    end
)


return module_