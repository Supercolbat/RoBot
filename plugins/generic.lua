local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local RoBot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/Controller.lua"))()
local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/PluginFramework.lua"))()
local plugin = framework:NewPlugin()
local utils = framework:utils()


function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end


plugin:ChatCommand(
    {"help"},
    function()
        utils:Chat("Hi there! I can do ;joke, ;say <message>, ;dictionary <word>, ;bring, and ;goto <player>")
        utils:Chat("Ask me for additional information on specific commands and I'll tell you!")
    end
)

plugin:ChatCommand(
    {"joke"},
    function()
        local joke = utils:HttpGet("https://v2.jokeapi.dev/joke/Miscellaneous,Dark,Pun,Spooky,Christmas?blacklistFlags=nsfw,religious,political,racist,sexist,explicit&format=txt&safe-mode")
        for line in string.gmatch(joke, "([^\n]+)") do
            print(line)
            utils:Chat(line)
        end
    end
)

plugin:ChatCommand(
    {"anyjoke"},
    function()
        local joke = utils:HttpGet("https://v2.jokeapi.dev/joke/Any?format=txt")
        for line in string.gmatch(joke, "([^\n]+)") do
            print(line)
            utils:Chat(line)
        end
    end
)

plugin:ChatCommand(
    {"d", "dictionary", "lookup"},
    function(data)
        if data["args"][1] then
            local dict = utils:HttpGet("https://api.dictionaryapi.dev/api/v2/entries/en/"..data["args"][1], true)
            if not dict then utils:Chat("API request failed! Try again later :'(") return end

            local meanings = dict[1]["meanings"]
            local chosen = meanings[utils:random(#meanings)]

            utils:Chat("("..chosen["partOfSpeech"]..") "..data["args"][1]..": "..chosen["definitions"][1]["definition"])
        else
            utils:Chat(data["sender"].Name..", you have to include the word you want to lookup!")
        end
    end
)

plugin:ChatCommand(
    {"fps"},
    function()
        local fps = Workspace:GetRealPhysicsFPS()
        utils:Chat("I'm running at " .. fps .. " FPS")
    end
)

plugin:ChatCommand(
    {"say"},
    function(data)
        utils:Chat(utils:JoinList(data["args"]))
    end
)

plugin:ChatCommand(
    {"bring", "come"},
    function(data)
        LocalPlayer.Character.HumanoidRootPart.CFrame = data["sender"].Character.HumanoidRootPart.CFrame
    end
)

plugin:ChatCommand(
    {"goto", "tp"},
    function(data)
        local player = utils:GetPlayer(data["args"][1]);
        if player then
            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
        else
            utils:Chat("Sorry, I couldn't find a player by that name!");
        end
    end
)

plugin:ChatCommand(
    {"die", "reset"},
    function(data)
        LocalPlayer.Character:BreakJoints()
    end
)

-- plugin:ChatCommand(
--     {"headsit"},
--     function(data)
--         -- https://www.github.com/EdgeIY/infiniteyield
        
--         local target = data["args"][1] ~= nil and utils:GetPlayer(data["args"][1]) or data["sender"]

--         if target == nil then
--             utils:Chat("Player not found")
--             return
--         elseif target == LocalPlayer then
--             utils:Chat("Hey I can't headsit myself >:(")
--             return
--         end

--         target = target.Character
--         local player = LocalPlayer.Character;
--         player:FindFirstChildOfClass('Humanoid').Sit = true
--         head_sit = game:GetService("RunService").Heartbeat:Connect(function()
--             if target ~= nil and getRoot(target) and getRoot(player) then
--                 if Players:FindFirstChild(utils:getPlayer(data["args"][1]).Name) and player:FindFirstChildOfClass('Humanoid').Sit == true then
--                     getRoot(player).CFrame = getRoot(target).CFrame * CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, 1.6, 0.4)
--                 else
--                     head_sit:Disconnect()
--                 end
--             end
--         end)
--     end
-- )

_G.RBCONFIG = {
    prefix=";",
    plugins={plugin},
    log=true
}

RoBot:start()