local wezterm = require("wezterm")

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "pwsh.exe", "-NoLogo" },
		-- cwd = "C:\\Program Files\\PowerShell\\7\\",
	})

	-- Enumerate any WSL distributions that are installed and add those to the menu
	local success, wsl_list, wsl_err = wezterm.run_child_process({ "wsl.exe", "-l" })
	-- `wsl.exe -l` has a bug where it always outputs utf16:
	-- https://github.com/microsoft/WSL/issues/4607
	-- So we get to convert it
	wsl_list = wezterm.utf16_to_utf8(wsl_list)

	for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
		-- Skip the first line of output; it's just a header
		if idx > 1 then
			-- Remove the "(Default)" marker from the default line to arrive
			-- at the distribution name on its own
			local distro = line:gsub(" %(Default%)", "")

			-- Add an entry that will spawn into the distro with the default shell
			table.insert(launch_menu, {
				label = distro .. " (WSL default shell)",
				args = { "wsl.exe", "--distribution", distro, "--exec", "usr/bin/bash", "-l" },
			})

			-- Here's how to jump directly into some other program; in this example
			-- its a shell that probably isn't the default, but it could also be
			-- any other program that you want to run in that environment
			table.insert(launch_menu, {
				label = distro .. " (WSL zsh login shell)",
				args = { "wsl.exe", "--distribution", distro, "--exec", "usr/bin/zsh", "-l" },
			})
		end
	end
end

function baseName(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

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

return {
	front_end = "OpenGL",
	launch_menu = launch_menu,
	hide_tab_bar_if_only_one_tab = true,
	font = wezterm.font_with_fallback({
		{
			family = "MonoLisa Variable",
			harfbuzz_features = { "calt=1", "liga=1", "frac=1", "zero=1", "ss02=1", "ss03=1", "ss06=1", "ss07=1", "ss08=1", "ss10=1", "ss11=1", "ss12=1" },
		},
		"JetBrains Mono",
	}),

	font_rules = {
		-- Similarly, a fancy bold+italic font
		{
			italic = true,
			intensity = "Bold",
			font = wezterm.font_with_fallback({
				{
					family = "MonoLisa Variable",
					weight = "Regular",
					italic = true,
					harfbuzz_features = { "calt=1", "liga=1", "frac=1", "zero=1", "ss02=1", "ss03=1", "ss06=1", "ss07=1", "ss08=1", "ss10=1", "ss11=1", "ss12=1" },
				},
				"JetBrains Mono",
			}),
		},

		-- Make regular bold text a different color to make it stand out even more
		{
			intensity = "Bold",
			font = wezterm.font_with_fallback({
				{
					family = "MonoLisa Variable",
					weight = "Regular",
					harfbuzz_features = { "calt=1", "liga=1", "frac=1", "zero=1", "ss02=1", "ss03=1", "ss06=1", "ss07=1", "ss08=1", "ss10=1", "ss11=1", "ss12=1" },
				},
				"JetBrains Mono",
			}),
		},
	},

	font_size = 12,
	freetype_load_target = "HorizontalLcd",

	default_cursor_style = "BlinkingBlock",
	animation_fps = 1,
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",

	initial_rows = 60,
	initial_cols = 170,

	color_scheme = "gruvbox_material_dark_hard",
	color_schemes = {
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
	},

	window_frame = {
		-- The font used in the tab bar.
		-- Roboto Bold is the default; this font is bundled
		-- with wezterm.
		-- Whatever font is selected here, it will have the
		-- main font setting appended to it to pick up any
		-- fallback fonts you may have used there.
		font = wezterm.font({ family = "MonoLisa Variable", weight = "Regular" }),

		-- The size of the font in the tab bar.
		-- Default to 10. on Windows but 12.0 on other systems
		font_size = 12.0,

		-- The overall background color of the tab bar when
		-- the window is focused
		active_titlebar_bg = "#333333",

		-- The overall background color of the tab bar when
		-- the window is not focused
		inactive_titlebar_bg = "#333333",
	},

	colors = {
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
	},

	window_background_opacity = 0,
	win32_system_backdrop = 'Mica',

	use_fancy_tab_bar = true,
	enable_tab_bar = true,
	enable_scroll_bar = false,
	tab_bar_at_bottom = true,

	-- window_padding = {
	-- 	left = "15px",
	-- 	right = "15px",
	-- 	top = "15px",
	-- 	bottom = "15px",
	-- },

	enable_wayland = true,
	use_ime = true,
	exit_behavior = "Close",

	ssh_domains = {
		{
			name = 'my.server',
			remote_address = '172.28.50.187:2222',
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
	},

	default_domain = "WSL:WLinux",
	-- default_domain = "my.server",

	keys = {
		-- capital C so it won't conflict buffer window, CTRL-SHIFT + C to copy
		{ key = "C", mods = "CTRL", action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }) },

		-- paste from the clipboard
		{ key = "V", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },

		-- paste from the primary selection
		{ key = "V", mods = "CTRL", action = wezterm.action({ PasteFrom = "PrimarySelection" }) },

		-- close current pane
		{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

		-- split vertical pane
		{
			key = "%",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},

		-- nightly version
		-- This will create a new split and run the `top` program inside it
		-- {key="-", mods="ALT|SHIFT", action=wezterm.action{SplitPane={
		--   direction="Down",
		-- }}},
	},
}
