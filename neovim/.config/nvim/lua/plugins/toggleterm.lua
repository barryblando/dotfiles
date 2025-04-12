local M = {}

M.init = function()
	local Terminal = require("toggleterm.terminal").Terminal

	local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

	function _LAZYGIT_TOGGLE()
		lazygit:toggle()
	end

	local lazydocker = Terminal:new({ cmd = "lazydocker", hidden = true })

	function _LAZYDOCKER_TOGGLE()
		lazydocker:toggle()
	end

	local node = Terminal:new({ cmd = "node", hidden = true })

	function _NODE_TOGGLE()
		node:toggle()
	end

	local ncdu = Terminal:new({ cmd = "gdu-go", hidden = true })

	function _GDU_TOGGLE()
		ncdu:toggle()
	end

	local btop = Terminal:new({ cmd = "btop --utf-force", hidden = true })

	function _BTOP_TOGGLE()
		btop:toggle()
	end

	local python = Terminal:new({ cmd = "python3", hidden = true })

	function _PYTHON_TOGGLE()
		python:toggle()
	end

	local cargo_run = Terminal:new({ cmd = "cargo run", hidden = true })

	function _CARGO_RUN()
		cargo_run:toggle()
	end

	local cargo_test = Terminal:new({ cmd = "cargo test", hidden = true })

	function _CARGO_TEST()
		cargo_test:toggle()
	end
end

M.config = function()
	local status_ok, toggleterm = pcall(require, "toggleterm")
	if not status_ok then
		return
	end

	local icons = require("core.icons")

	toggleterm.setup({
		size = 20,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = true,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = icons.ui.Border_Single_Line,
			winblend = 0,
			highlights = {
				border = "Normal",
				background = "Normal",
			},
		},
		winbar = {
			enabled = false,
			name_formatter = function(term) --  term: Terminal
				return term.name
			end,
		},
	})
end

return M
