local wezterm = require("wezterm")

return {
	hide_tab_bar_if_only_one_tab = true,
	font = wezterm.font_with_fallback({
		{
			family = "MonoLisa Static-Script",
			harfbuzz_features = { "calt=1", "liga=1", "zero=1", "ss02=1", "ss10=1", "ss11=1", "ss12=1" },
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
					family = "MonoLisa Static-Script",
					weight = "Regular",
					italic = true,
					-- harfbuzz_features = { "calt=1", "liga=1", "zero=1", "ss02=1" },
					harfbuzz_features = { "calt=1", "liga=1", "zero=1", "ss02=1", "ss10=1", "ss11=1", "ss12=1" },
				},
				"JetBrains Mono",
			}),
		},

		-- Make regular bold text a different color to make it stand out even more
		{
			intensity = "Bold",
			font = wezterm.font_with_fallback({
				{
					family = "MonoLisa Static-Script",
					weight = "Regular",
					-- harfbuzz_features = { "calt=1", "liga=1", "zero=1", "ss02=1" },
					harfbuzz_features = { "calt=1", "liga=1", "zero=1", "ss02=1", "ss10=1", "ss11=1", "ss12=1" },
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

	initial_rows = 58,
	initial_cols = 166,

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
		font = wezterm.font({ family = "MonoLisa Static-Script", weight = "Regular" }),

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
	window_background_opacity = 0.99,

	use_fancy_tab_bar = true,
	enable_tab_bar = true,
	enable_scroll_bar = false,
	tab_bar_at_bottom = true,

	window_padding = {
		left = "15px",
		right = "15px",
		top = "15px",
		bottom = "15px",
	},

	enable_wayland = true,
	use_ime = true,
	exit_behavior = "Close",

	-- ssh_domains = {
	-- 	{
	-- 		-- This name identifies the domain
	-- 		name = "bblando0x15.dev",
	-- 		-- The hostname or address to connect to. Will be used to match settings
	-- 		-- from your ssh config file
	-- 		remote_address = "172.29.174.62",
	-- 		-- The username to use on the remote host
	-- 		username = "bblando0x15",
	-- 	},
	-- },

	-- default_domain = "bblando0x15.dev",

	-- unix_domains = {
	-- 	{
	-- 		name = "wsl",
	-- 		-- Override the default path to match the default on the host win32
	-- 		-- filesystem.  This will allow the host to connect into the WSL
	-- 		-- container.
	-- 		socket_path = "/mnt/c/Users/Retr0_0x315/.local/share/wezterm/sock",
	-- 		-- NTFS permissions will always be "wrong", so skip that check
	-- 		skip_permissions_check = true,
	-- 	},
	-- },

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
	},
}
