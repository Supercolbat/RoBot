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
        if message:find("^" .. _G.RBCONFIG["prefix"] ..a.. "%f[%A]") then
            return a
        end
    end

    return nil
end

function system(type_, msg)
    local color

    if type_ == "success" then
        color = Color3.fromRGB(0, 255, 0)
    elseif type_ == "warn" then
        color = Color3.fromRGB(255, 255, 0)
    elseif type_ == "error" then
        color = Color3.fromRGB(255, 0, 0)
    end

    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
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
        for i,p in pairs(_G.RBCONFIG["plugins"]) do
            if type(p) == "string" then
                local pl
                pcall(function()
                    --[[local matches = {
                        p:find("pastebin%.com/(%w%w%w%w%w%w%w%w)"),
                        p:find("github.com/(%w+)/(%w+)/blob/(.+)")
                    } -- lua pattern matching is painful. i'll need a sophisticated regex library
                    for i,m in ipairs(matches) do
                        _,_,m = m
                        
                        if m ~= nil then
                            if i == 1 then
                                p = "https://pastebin.com/raw/"..p.sub(m)
                            elseif i == 2 then
                                p = "https://raw.githubusercontent.com/%1/%2/%3"
                            end
                        end
                    end
                    --]]
                    pl = loadstring(game:HttpGet(p))()
                end)

                if pl ~= nil then
                    for _,cmd in pairs(pl:get()) do
                        table.insert(commands, cmd)
                    end
                else
                    system("error", "Failed to load plugin: " .. p)
                    return
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
                for i,cmd in ipairs(commands) do
                    if cmd["event"] == "chat" then
                        local cmdname = alias(message, cmd["aliases"])
                        --if not _G.RBCONFIG.PluginConfig.disabled [cmdname] then
                            if cmdname ~= nil then
                                cmd["callback"]({
                                    sender = recipient.Name,
                                    args   = parse(message)
                                })
                            end
                        --end
                    end
                end
            end
        end)
    end

    system("success", "Successfullly initialized!")
end

return RoBot