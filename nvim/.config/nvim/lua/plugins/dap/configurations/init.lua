local M = {}

M.setup = function()
	local dap = require("dap")

	local langs = {
		require("plugins.dap.configurations.lua"),
		require("plugins.dap.configurations.rust"),
		require("plugins.dap.configurations.go"),
	}

	for _, lang_config in ipairs(langs) do
		for lang, configs in pairs(lang_config) do
			dap.configurations[lang] = vim.tbl_deep_extend("force", dap.configurations[lang] or {}, configs)
		end
	end
end

return M
