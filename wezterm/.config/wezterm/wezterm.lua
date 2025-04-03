local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- TODO: Remove this when https://github.com/wez/wezterm/issues/5067 is fixed.
config.enable_wayland = false

-- Support for undercurl, etc.
config.term = 'wezterm'

config.front_end = "OpenGL"

config.font = wezterm.font_with_fallback({
	{
		family = "MonoLisa",
		weight = "Regular",
		harfbuzz_features = { "calt=1", "liga=1", "frac=0", "zero=1", "ss02=1", "ss03=1", "ss06=1", "ss07=0", "ss08=1", "ss10=1", "ss11=1", "ss12=1" },
	},
	"JetBrains Mono",
})

config.font_rules = {
	-- Similarly, a fancy bold+italic font
	{
		italic = true,
		intensity = "Bold",
		font = wezterm.font_with_fallback({
			{
				family = "MonoLisa",
				weight = "Medium",
				italic = true,
				harfbuzz_features = { "calt=1", "liga=1", "frac=0", "zero=1", "ss02=1", "ss03=1", "ss06=1", "ss07=0", "ss08=1", "ss10=1", "ss11=1", "ss12=1" },
			},
			"JetBrains Mono",
		}),
	},

	-- Make regular bold text a different color to make it stand out even more
	{
		intensity = "Bold",
		font = wezterm.font_with_fallback({
			{
				family = "MonoLisa",
				harfbuzz_features = { "calt=1", "liga=1", "frac=0", "zero=1", "ss02=1", "ss03=1", "ss06=1", "ss07=0", "ss08=1", "ss10=1", "ss11=1", "ss12=1" },
			},
			"JetBrains Mono",
		}),
	},
}

config.font_size = 12
config.freetype_load_target = "HorizontalLcd"

config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.initial_rows = 60
config.initial_cols = 170

config.color_scheme = "gruvbox_material_dark_hard"
config.color_schemes = {
	["gruvbox_material_dark_hard"] = {
		foreground = "#D4BE98",
		background = "#1D2021",
		cursor_bg = "#D4BE98",
		cursor_border = "#D4BE98",
		cursor_fg = "#1D2021",
		selection_bg = "#D4BE98",
		selection_fg = "#3C3836",

		ansi = { "#1d2021", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b482", "#d4be98" },
		brights = { "#eddeb5", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b482", "#d4be98" },
	},
}

config.window_background_opacity = 0
config.win32_system_backdrop = 'Mica'

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.enable_tab_bar = true
config.enable_scroll_bar = false
config.tab_bar_at_bottom = true
config.window_frame = {
	font = wezterm.font({ family = "MonoLisa", weight = "Regular" }),
	font_size = 12.0,
	active_titlebar_bg = "#333333",
	inactive_titlebar_bg = "#333333",
}

config.colors = {
	selection_bg = "white",
	selection_fg = "black",
	tab_bar = {
		-- https://wezfurlong.org/wezterm/config/appearance.html
		background = "#0b0022",
		active_tab = {
			bg_color = "#1D2021",
			fg_color = "#D4BE98",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#3C3836",
			fg_color = "#808080",
		},
		inactive_tab_hover = {
			bg_color = "#D4BE98",
			fg_color = "#1D2021",
			italic = true,
		},
		new_tab = {
			bg_color = "#1D2021",
			fg_color = "#808080",
		},

		new_tab_hover = {
			bg_color = "#D4BE98",
			fg_color = "#909090",
			-- italic = true,
		},
	},
}

config.use_ime = true
config.exit_behavior = "Close"

config.ssh_domains = {
	{
		name = 'my.server',
		remote_address = '127.0.0.1:3154',
		username = 'bblando0x15',
		multiplexing = 'None',

		ssh_option = {
			identityfile = '"C:\\Users\\Retr0_0x315\\.ssh\\authorize_keys"',
		},

		-- When multiplexing == "None", default_prog can be used
		-- to specify the default program to run in new tabs/panes.
		-- Due to the way that ssh works, you cannot specify default_cwd,
		-- but you could instead change your default_prog to put you
		-- in a specific directory.
		default_prog = { 'zsh' },

		-- assume that we can use syntax like:
		-- "env -C /some/where $SHELL"
		-- using whatever the default command shell is on this
		-- remote host, so that shell integration will respect
		-- the current directory on the remote host.
		assume_shell = 'Posix',

		connect_automatically = true,
		no_agent_auth = true,
		remote_wezterm_path = "/usr/bin/wezterm"
	},
}

-- default_domain = "WSL:WLinux",
config.default_domain = "my.server"

-- Keybindings.
config.disable_default_key_bindings = true
local mods = 'ALT|SHIFT'
config.keys = {
	{ mods = mods,  key = 'x', action = act.ActivateCopyMode },
	{ mods = mods,  key = 'd', action = act.ShowDebugOverlay },
	{ mods = mods,  key = 'v', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
	{ mods = mods,  key = 's', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
	{ mods = mods,  key = 'h', action = act.ActivatePaneDirection 'Left' },
	{ mods = mods,  key = 'l', action = act.ActivatePaneDirection 'Right' },
	{ mods = mods,  key = 'k', action = act.ActivatePaneDirection 'Up' },
	{ mods = mods,  key = 'j', action = act.ActivatePaneDirection 'Down' },
	{ mods = mods,  key = 't', action = act.SpawnTab 'CurrentPaneDomain' },
	{ mods = mods,  key = 'q', action = act.CloseCurrentPane { confirm = true } },
	{ mods = mods,  key = 'y', action = act.CopyTo 'Clipboard' },
	{ mods = mods,  key = 'p', action = act.PasteFrom 'Clipboard' },
	{ mods = 'ALT', key = '1', action = act.ActivateTab(0) },
	{ mods = 'ALT', key = '2', action = act.ActivateTab(1) },
	{ mods = 'ALT', key = '3', action = act.ActivateTab(2) },
	{ mods = 'ALT', key = '4', action = act.ActivateTab(3) },
	{ mods = 'ALT', key = '5', action = act.ActivateTab(4) },
}

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end

	return zoomed .. index .. "Retr0_0x315"
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- local pane = tab.active_pane
	-- local title = baseName(pane.foreground_process_name) .. " "

	if tab.is_active then
		return {
			{ Text = " Terminal" .. "[" .. tab.tab_index .. "]" },
		}
	end

	local has_unseen_output = false

	for _, pane in ipairs(tab.panes) do
		if pane.has_unseen_output then
			has_unseen_output = true
			break
		end
	end
	if has_unseen_output then
		return {
			{ Background = { Color = "#D8A657" } },
			{ Text = " Terminal" .. "[" .. tab.tab_index .. "]" },
		}
	end

	return " Terminal" .. "[" .. tab.tab_index .. "]"
end)

return config
