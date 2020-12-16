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

function system(type_, msg)
    local color

    if type_ == "warn" then
        color = Color3.fromRGB(255, 255, 0)
    elseif type == "error" then
        color Color3.fromRGB(255, 0, 0)
    end
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage",{
            Text = "RoBot: "..msg,
            Color = color,
            Font = Enum.Font.SourceSans,
            FontSize = Enum.FontSize.Size18
        })
end


-- create start function --
local RoBot = {}

function RoBot:start()
    -- wait for game to fully load
    repeat wait() until game.Loaded and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

    local commands = {}

    -- Check for an improper setup
    if _G.RBCONFIG == nil then
        system("error", "You must declare _G.RBCONFIG")
    elseif _G.RBCONFIG["prefix"] == nil then
        system("error", "You are missing a prefix")
    elseif _G.RBCONFIG["plugins"] == nil then
        system("error", "You haven't included any plugins")

    else
        -- Load plugins
        for _,p in pairs(_G.RBCONFIG["plugins"]) do
            if type(p) == "string" then
                local pl = loadstring(game:HttpGet(p))()
                for _,cmd in pairs(pl:get()) do
                    table.insert(commands, cmd)
                end
            elseif type(p) == "table" then
                for _,cmd in pairs(p:get()) do
                    table.insert(commands, cmd)
                end
            else
                system("warn", "Unknown type found in plugins. '" .. type(p) .. "'")
            end
        end
    
        -- Setup events
        Players.PlayerChatted:Connect(function(chatType, recipient, message)
            if LocalPlayer.Name == recipient.Name then return end
            
            if message:sub(1, 1) == _G.RBCONFIG["prefix"] then
                for _,cmd in pairs(commands) do
                    if cmd["type"] == "chat" then
                        if alias(message, cmd["names"]) then
                            cmd["callback"]({
                                sender=recipient,
                                args=parse(message)
                            })
                        end
                    end
                end
            end
        end)
    end

    print("Successfullly initialized!")
end

return RoBot