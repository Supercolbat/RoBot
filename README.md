# What is RoBot?
RoBot is a Roblox framework for making client-sided chatbots.
Be aware that this is still very much a work in progress.

# How to use the RoBot Framework
Read **[Disclaimer](https://github.com/Supercolbat/RoBot#disclaimer)** before proceeding.

If all you care about is using premade RoBot bots, then this is how you do it. First, you'll need to create a global variable named `_G.RBCONFIG`. This is where you will setup the bot's configuration. 

There are two variables that you have to set in the config, that being `prefix` and `plugins`. Despite the name, plugins are necessary. They can come in the form of URLs or Plugin functions. Plugins might add their own variables to the config so make sure to read on how to setup that specific plugin.

Here's an example of what a simple setup should look like.
```lua
_G.RBCONFIG = {
    prefix = "!",
    plugins = {"https://github.com/Supercolbat/RoBot/plugins/sample.lua"}
}

RoBot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/RoBot.lua", true))()

RoBot.start()
```
# How to make RoBot Plugins
RoBot comes with a framework for making plugins, however you will have to import/loadstring a different file. Note that you can do the same steps even if you want the plugin to be in the same script where you created `_G.RBCONFIG`, which from now on will be called the controller.

The first thing you want to do is import the framework and create a new plugin as shown below.
```lua
local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/PluginFramework.lua", true))()
local plugin = framework:NewPlugin()
local utils = plugin:utils()
```
As of right now, the only supported command is `:ChatCommand`, which adds a command and lets you specify how the bot should respond. This is the syntax of the command.
```lua
plugin:ChatCommand(
    {"command", "aliases"},
    function()
        -- code
    end
)
```
Once you have finished, you have two options. If this plugin is in the same file as the controller, then add the `plugin` variable in plugins.
```lua
_G.RBCONFIG = {
    prefix = "!",
    plugins = {plugin}
}
```
Otherwise, add `return plugin` at the end of the file. Then you can add a link to the file in the plugins variable.

Here's an example plugin if you are still confused *(don't worry if you are)*.
```lua
local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/Supercolbat/RoBot/master/plugin.lua"))
local plugin = PluginFramework:NewPlugin()
local utils = plugin:utils()

plugin:ChatCommand(
	{"random"},
	function()
		utils:chat("hello")
	end
)

return plugin
```

> A more detailed explanation will be provided once a wiki page is created. I'll clarify everything in it.

# Disclaimer
This script was not intended to be used in game development. Instead, this script is directed towards Roblox exploiters/scripters who know what they are doing.

Using cheats come with the risk of getting your account banned. In this case, those cheats are script injectors/executors. I highly advise against using free script executors as they are the most likely to put your account at risk, but most importantly, they could possibly be infected with malware. Others aren't malicious but leech money from you by forcing you to watch advertisements through a key-login system. The executor I use and recommend is [Synapse X](x.synapse.to), however it's been having a few issues recently. No matter what precautions you take or what executor you use, your account can still get banned. If you want your main account to remain safe, use alt accounts as opposed to your main account.

Again, proceed with caution.

# FAQ
I haven't encountered anything that might be asked as of right now.

# TODO
- [ ] Create a wiki page
- [ ] Give the user more control over the bot
- [ ] Actually make the framework?

---
> Special thanks to [ViniDalvino](https://github.com/ViniDalvino) who made the [Roblox Bible Bot](https://github.com/ViniDalvino/roblox-bible-bot/), which is what inspired me to make RoBot.
