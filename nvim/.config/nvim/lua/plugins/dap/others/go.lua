local M = {}

-- use by plugin "leoluz/nvim-dap-go"
M.opts = {
	dap_configurations = {
		{
			type = "go",
			name = "Attach remote",
			mode = "remote",
			request = "attach",
		},
	},
	-- delve configurations
	delve = {
		path = "dlv",
		initialize_timeout_sec = 20,
		port = "${port}",
		args = {},
		build_flags = {},
		detached = vim.fn.has("win32") == 0,
		cwd = nil,
	},
	tests = {
		-- enables verbosity when running the test.
		verbose = false,
	},
}

return M
