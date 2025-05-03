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

	dap.configurations.rust = {
		-- Standard debug binary
		{
			name = "Debug",
			type = "codelldb",
			request = "launch",
			program = function()
				-- Try to guess the binary automatically
				local crate_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				local default_path = vim.fn.getcwd() .. "/target/debug/" .. crate_name
				if vim.fn.filereadable(default_path) == 1 then
					return default_path
				end
				-- Fallback to manual input
				return vim.fn.input("Binary path: ", default_path, "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			runInTerminal = false,
		},

		-- Debug test binary (whole test file)
		{
			name = "Debug Tests",
			type = "codelldb",
			request = "launch",
			program = function()
				local crate_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				return vim.fn.getcwd() .. "/target/debug/" .. crate_name .. "-[test]"
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			runInTerminal = false,
		},

		-- Debug a specific test function
		{
			name = "Debug Test (Current Function)",
			type = "codelldb",
			request = "launch",
			program = function()
				local crate_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				return vim.fn.getcwd() .. "/target/debug/" .. crate_name .. "-[test]"
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = function()
				local test_name = vim.fn.input("Test name: ")
				return { test_name and "--test", test_name }
			end,
			runInTerminal = false,
		},

		-- Run any custom built binary
		{
			name = "Debug Custom Binary",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to binary: ", vim.fn.getcwd() .. "/target/debug/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = function()
				local args_str = vim.fn.input("Program arguments: ")
				return vim.split(args_str, " ")
			end,
			runInTerminal = false,
		},
	}

	dap.configurations["go"] = {
		-- Debug current file
		{
			type = "go",
			name = "Debug File",
			request = "launch",
			program = "${file}",
		},

		-- Debug test in current file
		{
			type = "go",
			name = "Debug Test File",
			request = "launch",
			mode = "test",
			program = "${file}",
		},

		-- Debug test function under cursor
		{
			type = "go",
			name = "Debug Nearest Test",
			request = "launch",
			mode = "test",
			program = "${file}",
			args = function()
				local func = vim.fn.input("Test function name (or leave blank): ")
				if func ~= "" then
					return { "-test.run", func }
				end
				return {}
			end,
		},

		-- Debug main package
		{
			type = "go",
			name = "Debug Main Package",
			request = "launch",
			program = "${workspaceFolder}/main.go",
		},
	}
end

return M
