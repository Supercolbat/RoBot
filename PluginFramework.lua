-- locals --
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PluginFramework = {}


-- framework --
function PluginFramework:NewPlugin()
    local framework = {} -- For subcommands
    local commands = {} -- Where commands are stored to later be interpreted.

    function framework:ChatCommand(command, callback)
        table.insert(commands, {event="chat", aliases=command, callback=callback})
    end

    function framework:get() return commands end

    -- Add utils for basic functions
    function framework:utils()
        local utils = {}

        function utils:chat(message, target) -- target is optional
            local Event = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
            Event:FireServer(message, target and target or "All")
        end

        function utils:JoinString(list, separator)
            return table.concat({table.unpack(list)}, separator and separator or ' ')
        end

        function HttpGet(link, json)
            local content
            local success, response = pcall(function()
                content = game:HttpGet(link)
            end)
            if not success then warn("RoBot: Failed to HttpGet") return false end
            return json and HttpService:JSONDecode(content) or content
        end

        return utils
    end

    return framework
end

return PluginFramework