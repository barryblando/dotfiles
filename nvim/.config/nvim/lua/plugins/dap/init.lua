local M = {}

M.config = function()
	local dap = require("dap")
	local dapui = require("dapui")

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.attach["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.launch["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.after.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close({})
	end

	-- Overseer integration
	require("overseer").patch_dap(true)
	require("dap.ext.vscode").json_decode = require("overseer.json").decode

	-- Load adapters and configurations
	require("plugins.dap.adapters").setup()
	require("plugins.dap.configurations").setup()

	require("dap.ext.vscode").load_launchjs(nil, {
		["codelldb"] = { "rust" },
		["pwa-node"] = { "typescript", "javascript" },
	})
end

return M
