local M = {}

M.config = function()
	local icons = require("core.icons")
	-- Inside your plugin setup
	require("bqf").setup({
		auto_enable = true,
		auto_resize_height = true,
		preview = {
			win_height = 12,
			border = icons.ui.Border_Single_Line,
			winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
			show_title = true,
			delay_syntax = 50,
			winblend = 0,
		},
		func_map = {
			open = "<CR>",
			openc = "o",
			split = "s",
			vsplit = "v",
			tabdrop = "t",
		},
	})
end

return M
