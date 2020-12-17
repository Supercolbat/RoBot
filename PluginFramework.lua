-- locals --
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PluginFramework = {}


-- framework --
function PluginFramework:NewPlugin()
    local framework = {} -- For subcommands
    local commands = {} -- Where commands are stored to later be interpreted.

    function framework:ChatCommand(command, callback)
        table.insert(commands, {type="chat", names=command, callback=callback})
    end

    function framework:get() return commands end

    -- Add utils for basic functions
    function framework:utils()
        local utils = {}

        function utils:chat(message, target) -- target is optional
            local Event = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
            Event:FireServer(message, target and target or "All")
        end

        function HttpGet(link, mode)
            local content
            local success, response = pcall(function()
                content = game:HttpGet(link)
            end)
            if not success then warn("RoBot: Failed to HttpGet") end
            return string.lower(mode) == "json" and HttpService:JSONDecode(content) or content
        end

        return utils
    end

    return framework
end

return PluginFramework