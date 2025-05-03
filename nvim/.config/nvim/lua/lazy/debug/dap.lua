local icons = require("core.icons")

for name, sign in pairs(icons.dap) do
	local sign_value = type(sign) == "table" and sign or { sign }
	vim.fn.sign_define("Dap" .. name, {
		text = sign_value[1] .. " ",
		texthl = sign_value[2] or "DiagnosticInfo",
		linehl = sign_value[3],
		numhl = sign_value[3],
	})
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			{ "rcarriga/nvim-dap-ui", opts = require("plugins.dap.ui").opts },
			{ "theHamsta/nvim-dap-virtual-text", opts = require("plugins.dap.virtual-text").opts },
			{ "jbyuki/one-small-step-for-vimkind", init = require("plugins.dap.lang.lua").init },
			-- {
			-- 	"leoluz/nvim-dap-go",
			-- 	opts = require("plugins.dap.lang.go").opts,
			-- },
		},
		keys = require("core.keymaps").setup_dap_keymaps(),
		config = require("plugins.dap").config,
	},
}
