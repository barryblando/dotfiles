local M = {}

M.setup = function()
	local dap = require("dap")

	dap.configurations["lua"] = {
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance",
		},
	}

	dap.configurations["rust"] = {
		{
			name = "Debug",
			type = "codelldb",
			request = "launch",
			program = function()
				-- auto-detect binary, will debug crate’s binary without prompting you every time.
				-- return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				-- or dynamically pick between different binaries

				return vim.fn.input("Binary path: ", vim.fn.getcwd() .. "/target/debug/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			runInTerminal = false,
		},
	}
end

return M
