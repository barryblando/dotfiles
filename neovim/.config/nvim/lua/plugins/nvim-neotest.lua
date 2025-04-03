return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		{
			"stevearc/overseer.nvim",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = { "go", "rs", "js", "ts" },
			callback = function()
				vim.schedule(function()
					local status_ok, wk = pcall(require, "which-key")
					if not status_ok then
						return
					end

					wk.add({ { "<leader>T", group = "Test", nowait = true, remap = false, buffer = 0 } })

					vim.keymap.set("n", "<leader>Tt", function()
						vim.cmd('lua require("neotest").run.run(vim.fn.expand "%")')
					end, { desc = "Neotest | Run File", silent = true, buffer = true })

					vim.keymap.set("n", "<leader>TT", function()
						vim.cmd('lua require("neotest").run.run(vim.loop.cwd())')
					end, { desc = "Neotest | Run All Test Files", silent = true, buffer = true })

					vim.keymap.set("n", "<leader>Tr", function()
						vim.cmd('lua require("neotest").run.run()')
					end, { desc = "Neotest | Run Nearest", silent = true, buffer = true })

					vim.keymap.set("n", "<leader>Td", function()
						vim.cmd('lua require("neotest").run.run { strategy = "dap" }')
					end, { desc = "Neotest | Run Dap", silent = true, buffer = true })

					vim.keymap.set("n", "<leader>Ts", function()
						vim.cmd('lua require("neotest").summary.toggle()')
					end, { desc = "Neotest | Toggle Summary", silent = true, buffer = true })

					vim.keymap.set("n", "<leader>To", function()
						vim.cmd('lua require("neotest").output.open { enter = true, auto_close = true }')
					end, { desc = "Neotest | Show Output", silent = true, buffer = true })

					vim.keymap.set("n", "<leader>TO", function()
						vim.cmd('lua require("neotest").output_panel.toggle()')
					end, { desc = "Neotest | Toggle Output Panel", silent = true, buffer = true })

					vim.keymap.set("n", "<leader>TS", function()
						vim.cmd('lua require("neotest").run.stop()')
					end, { desc = "Neotest | Stop", silent = true, buffer = true })
				end)
			end,
		})
	end,
	config = function()
		require("neotest").setup({
			consumers = {
				overseer = require("neotest.consumers.overseer"),
			},
			overseer = {
				enabled = true,
				-- When this is true (the default), it will replace all neotest.run.* commands
				force_default = false,
			},
		})
	end,
}
