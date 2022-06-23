local ok_status, signature = pcall(require, "lsp_signature")

if not ok_status then
	return
end

signature.setup({
	-- general options
	always_trigger = true,
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
})
