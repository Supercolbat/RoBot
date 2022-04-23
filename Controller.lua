-- Ensure that the responses will be different each run
math.randomseed(tick())

-- locals --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer


-- functions --
function parse(message)
    if message == nil then return {} end
    
    local chunks = {}
    for sb in message:gmatch("%S+") do
        table.insert(chunks, sb)
    end

    chunks = {table.unpack(chunks, 2)}
    return chunks
end

function alias(message, aliases)
    for _,a in pairs(aliases) do
        -- if message:find("^".._G.RBCONFIG["prefix"]..a.. "whatpattern?") -- pattern should check for a space or eol
        if string.sub(message, 1, string.len(a)+1) == _G.RBCONFIG["prefix"]..a then
            return true
        end
    end

    return false
end

function system(log_type, message)
    local color

    if log_type == "success" then
        color = Color3.fromRGB(0, 255, 0)
    elseif log_type == "warn" then
        color = Color3.fromRGB(255, 255, 0)
    elseif log_type == "error" then
        color = Color3.fromRGB(255, 0, 0)
    end

    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = "RoBot: " .. message,
        Color = color,
        Font = Enum.Font.SourceSans,
        FontSize = Enum.FontSize.Size18
    })
end


-- start function --
local RoBot = {}

function RoBot:start()
    -- Wait for game to fully load
    repeat wait() until game.Loaded and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

    local commands = {}

    -- Check for an improper setup
    if _G.RBCONFIG == nil then
        system("error", "You must declare _G.RBCONFIG")
    elseif _G.RBCONFIG["prefix"] == nil then
        system("error", "You are missing a prefix")
    elseif _G.RBCONFIG["plugins"] == nil then
        system("error", "You haven't included any plugins")

    -- Proceed if setup is correct
    else
        for _, p in pairs(_G.RBCONFIG["plugins"]) do
            -- Load plugin from URL
            if type(p) == "string" then
                local pl
                pcall(function()
                    pl = loadstring(game:HttpGet(p))()
                end)

                if pl then
                    for _,cmd in pairs(pl:get()) do
                        table.insert(commands, cmd)
                    end
                else
                    system("error", "Failed to load plugin: "..p)
                    return
                end

            -- Load plugin locally
            elseif type(p) == "table" then
                for _, cmd in pairs(p:get()) do
                    table.insert(commands, cmd)
                end

            else
                system("warn", "Unknown type found in plugins. '" .. type(p) .. "'")
            end
        end
    
        -- Setup events
        Players.PlayerChatted:Connect(function(chat_type, recipient, message)
            -- Prevent the bot from replying to itself
            if LocalPlayer.Name == recipient.Name then return end
            
            if message:sub(1, 1) == _G.RBCONFIG["prefix"] then
                for _, cmd in pairs(commands) do
                    if cmd["event"] == "chat" then
                        if alias(message, cmd["aliases"]) then
                            cmd["callback"]({
                                sender = recipient,
                                args   = parse(message)
                            })
                        end
                    end
                end
            end
        end)
    end

    system("success", "Successfullly initialized!")
end

return RoBot