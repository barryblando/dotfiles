local M = {}

M.init = function()
	-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
	-- vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
end

M.opts = {
	-- if you want to open yazi instead of netrw, see below for more info
	open_for_directories = false,
	keymaps = {
		show_help = "<f1>",
		open_file_in_vertical_split = "<c-v>",
		open_file_in_horizontal_split = "<c-x>",
		open_file_in_tab = "<c-t>",
		grep_in_directory = "<c-s>",
		replace_in_directory = "<c-g>",
		cycle_open_buffers = "<tab>",
		copy_relative_path_to_selected_files = "<c-y>",
		send_to_quickfix_list = "<c-q>",
		change_working_directory = "<c-\\>",
		open_and_pick_window = "<c-o>",
	},
	yazi_floating_window_border = "single",
}

return M
