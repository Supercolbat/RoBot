-- Get random responses each time you execute
math.randomseed(tick())


-- locals --
local RoBot = {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- functions --
function parse(message)
    local chunks = {}
    for sb in s:gmatch("%S+") do
        table.insert(chunks, sb)
    end

    chunks = {table.unpack(chunks, 2)}
    return chunks
end

function alias(message, aliases)
    for a in aliases do
        if message:match(_G.RBCONFIG.prefix..a) then
            return true
        end
    end

    return false
end

-- create start function --
function RoBot:start()
    local commands = {}

    -- Check for an improper setup
    if _G.RBCONFIG == nil then
        warn("You must declare _G.RBCONFIG")
    elseif _G.RBCONFIG.prefix == nil then
        warn("You are missing a prefix")
    elseif _G.RBCONFIG.plugins == nil then
        warn("You haven't included any plugins")
    else
        -- Load plugins
        for p in _G.RBCONFIG.plugins do
            if type(p) == "string" then
                local plugin = loadstring(HttpService(p))
                for cmd in plugin:get() do
                    table.insert(commands, cmd)
                end
            elseif type(p) == "function" then
                for cmd in p:get() do
                    table.insert(commands, cmd)
                end
            else
                warn("Unknown type found in plugins. " .. type(p))
            end
        end
    
        -- Setup events
        Players.PlayerChatted:Connect(function(chatType, recipient, message)
            if LocalPlayer.Name == recipient.Name then return end
        
            message = string.lower(message)
            if message:sub(1, 1) == _G.config.prefix then
                for cmd in commands do
                    if cmd["type"] == "chat" then
                        if alias(message, cmd["names"]) then
                            cmd["callback"](parse(message))
                        end
                    end
                end
            end
        end)
    end
end

return RoBot

--Players.PlayerAdded:Connect(function(player)end)
