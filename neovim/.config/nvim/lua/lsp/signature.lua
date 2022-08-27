local ok_status, signature = pcall(require, "lsp_signature")

if not ok_status then
	return
end

local cfg = {
	-- general options
	always_trigger = false,
	hint_enable = false, -- virtual text hint
	bind = true,

	-- floating window

	padding = " ",
	auto_close_after = 200,
	transparency = nil,
	floating_window_above_cur_line = true,
	handler_opts = {
		border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
	},
	max_width = 80,
}

signature.setup(cfg)

signature.on_attach(cfg)
