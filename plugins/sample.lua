local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/plugin.lua"))
local plugin = PluginFramework:NewPlugin()

plugin:ChatCommand(
	{"random"},
	function()
		plugin:utils:chat("hello")
	end
)

return plugin