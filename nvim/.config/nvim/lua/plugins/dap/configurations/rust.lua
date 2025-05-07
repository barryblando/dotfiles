return {
	rust = {
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
	},
}
