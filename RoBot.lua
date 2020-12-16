-- Get random responses each time you execute
math.randomseed(tick())

-- locals --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- functions --
function parse(message)
    local chunks = {}
    for sb in message:gmatch("%S+") do
        table.insert(chunks, sb)
    end

    chunks = {table.unpack(chunks, 2)}
    return chunks
end

function alias(message, aliases)
    for _,a in pairs(aliases) do
        if string.sub(message, 1, string.len(a)+1) == _G.RBCONFIG["prefix"]..a then
            return true
        end
    end

    return false
end

-- create start function --
local RoBot = {}

function RoBot:start()
    local commands = {}

    -- Check for an improper setup
    if _G.RBCONFIG == nil then
        warn("RoBot: You must declare _G.RBCONFIG")
    elseif _G.RBCONFIG["prefix"] == nil then
        warn("RoBot: You are missing a prefix")
    elseif _G.RBCONFIG["plugins"] == nil then
        warn("RoBot: You haven't included any plugins")

    else
        -- Load plugins
        for _,p in pairs(_G.RBCONFIG["plugins"]) do
            if type(p) == "string" then
                local plugin = loadstring(game:HttpGet((p)))
                for _,cmd in pairs(plugin:getcommands()) do
                    table.insert(commands, cmd)
                end
            elseif type(p) == "table" then
                for _,cmd in pairs(p:getcommands()) do
                    table.insert(commands, cmd)
                end
            else
                warn("RoBot: Unknown type found in plugins. '" .. type(p) .. "'")
            end
        end
    
        -- Setup events
        Players.PlayerChatted:Connect(function(chatType, recipient, message)
            if LocalPlayer.Name == recipient.Name then return end
            
            if message:sub(1, 1) == _G.RBCONFIG["prefix"] then
                for _,cmd in pairs(commands) do
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
