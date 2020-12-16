local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PluginFramework = {}

function PluginFramework:NewPlugin()
    local framework = {} -- For subcommands
    local commands = {} -- Where commands are stored to later be interpreted.

    function framework:ChatCommand(command, callback)
        table.insert(commands, {type="chat", names=command, callback=callback})
    end

    function framework:getcommands() return commands end

    -- Add utils for basic functions
    function framework:utils()
        local utils = {}

        function utils:chat(message, target) -- target is optional
            local Event = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
            Event:FireServer(message, target and target or "All")
        end

        return utils
    end

    return framework
end

return PluginFramework