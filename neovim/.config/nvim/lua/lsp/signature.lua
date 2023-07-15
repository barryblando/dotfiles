local ok_status, signature = pcall(require, "lsp_signature")

if not ok_status then
	return
end

local icons = require("utils.icons")

local cfg = {
	-- general options
	always_trigger = false,
	hint_enable = false, -- virtual text hint
	bind = true,
	max_width = 80,

	-- floating window

	padding = " ",
	auto_close_after = 200,
	transparency = nil,
	floating_window_above_cur_line = true,
	handler_opts = {
		border = icons.ui.Border_Single_Line,
  },
  toggle_key = '<C-k>',
  toggle_key_flip_floatwin_setting = true
}

signature.setup(cfg)

signature.on_attach(cfg)
