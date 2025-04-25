return {
	"saecki/live-rename.nvim",
	init = function()
		local live_rename = require("live-rename")

		-- the following are equivalent
		vim.keymap.set("n", "<F2>", function()
			live_rename.rename({ text = "", insert = true })
		end, { desc = "LSP rename" })
	end,
}
