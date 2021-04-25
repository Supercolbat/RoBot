local LocalPlayer = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")

local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/PluginFramework.lua"))()
local plugin = framework:NewPlugin()
local utils = plugin:utils()


plugin:ChatCommand(
    {"joke"},
    function()
        local joke = utils:HttpGet("https://official-joke-api.appspot.com/random_joke", true)
        utils:Chat(joke.setup .. " " .. joke.punchline)
    end
)

plugin:ChatCommand(
    {"d", "dictionary", "lookup"},
    function(data)
        if data["args"][1] then
            local dict = utils:HttpGet("https://api.dictionaryapi.dev/api/v2/entries/en/"..data["args"][1], true)
            if not dict then utils:Chat("API request failed! Try again later :'(") return end

            local meanings = dict[1]["meanings"]
            local chosen = meanings[utils:random(#table)]

            utils:Chat("("..chosen["partOfSpeech"]..") "..data["args"][1]..": "..chosen["definitions"][1]["definition"])
        else
            utils:Chat(data["sender"]..", you have to include the word you want to lookup!")
        end
    end
)

plugin:ChatCommand(
    {"fps"},
    function()
        local fps = Workspace:GetRealPhysicsFPS()
        utils:Chat("My FPS is: " .. fps)
    end
)

plugin:ChatCommand(
    {"say"},
    function(data)
        utils:Chat(utils:JoinList(data["args"]))
    end
)

plugin:ChatCommand(
    {"bring", "comehere", "tptome"},
    function(data)
        LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[data["sender"]].Character.HumanoidRootPart.CFrame
    end
)


return plugin
