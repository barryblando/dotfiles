return {
	"akinsho/toggleterm.nvim",
	config = function()
		local status_ok, toggleterm = pcall(require, "toggleterm")
		if not status_ok then
			return
		end

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
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
				-- border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
				-- border = "curved",
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

		function _G.set_terminal_keymaps()
			local opts = { noremap = true }
			-- toggleterm esc keymap doesn't work if this one's set
			-- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
			-- disable this as it makes long press with `j` not rendering until sometime after the key release.
			-- see https://github.com/akinsho/toggleterm.nvim/issues/63 for more details
			-- vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

		function _LAZYGIT_TOGGLE()
			lazygit:toggle()
		end

		local lazydocker = Terminal:new({ cmd = "lazydocker", hidden = true })

		function _LAZYDOCKER_TOGGLE()
			lazydocker:toggle()
		end

		local lazynpm = Terminal:new({ cmd = "lazynpm", hidden = true })

		function _LAZYNPM_TOGGLE()
			lazynpm:toggle()
		end

		local node = Terminal:new({ cmd = "node", hidden = true })

		function _NODE_TOGGLE()
			node:toggle()
		end

		local ncdu = Terminal:new({ cmd = "gdu", hidden = true })

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
	end,
}
