return {
	go = {
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
	},
}
