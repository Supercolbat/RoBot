-- locals --
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PluginFramework = {}


-- framework --
function PluginFramework:NewPlugin()
    local framework = {} -- Framework subcommands
    local commands = {} -- Plugin command storage

    function framework:ChatCommand(command, callback)
        table.insert(commands, {event="chat", aliases=command, callback=callback})
    end

    function framework:get() return commands end

    return framework
end

-- utility functions --
function PluginFramework:utils()
    local utils = {}

    function utils:Chat(message, target) -- target is optional
        local Event = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
        Event:FireServer(message, target and target or "All")
    end

    function utils:JoinList(list, separator) -- separator is ' ' by default
        return table.concat({table.unpack(list)}, separator and separator or ' ')
    end

    function utils:HttpGet(url, as_json)
        local content
        local success, response = pcall(function()
            content = game:HttpGet(url)
        end)

        if not success then
            warn("RoBot: Failed to HttpGet")
            return false
        end

        return as_json and HttpService:JSONDecode(content) or content
    end

    function utils:GetPlayer(name)
        local Name = string.lower(name)
        for _,v in pairs(Players:GetPlayers()) do
            if string.match(string.lower(v.Name), "^"..Name) then
                return v
            end
        end
    end

    function utils:random(max)
        math.randomseed(tick())
        return math.random(max)
    end

    return utils
end

return PluginFramework