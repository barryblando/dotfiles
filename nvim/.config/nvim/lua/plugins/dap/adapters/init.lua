local M = {}

M.setup = function()
	local dap = require("dap")

	dap.adapters.nlua = function(callback, config)
		callback({
			type = "server",
			host = config.host or "127.0.0.1",
			port = config.port or 8086,
		})
	end

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
			args = { "--port", "${port}" },
		},
	}

	dap.adapters.go = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
			args = { "dap", "--listen=127.0.0.1:${port}" },
		},
	}
end

return M
