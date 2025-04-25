return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		local Snacks = require("snacks")
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.actions.type == "move" then
					Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
				end
			end,
		})
	end,
	keys = require("plugins.snacks").keys,
	config = require("plugins.snacks").config,
}
