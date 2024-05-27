-- Filetypes in which to highlight color codes.
local colored_fts = {
	"cfg",
	"css",
	"conf",
	"lua",
	"scss",
}

-- Create Color Code.
return {
	{
		"uga-rosa/ccc.nvim",
		ft = colored_fts,
		cmd = "CccPick",
		opts = function()
			local ccc = require("ccc")
			local icons = require("utils.icons")
			-- Use uppercase for hex codes.
			ccc.output.hex.setup({ uppercase = true })
			ccc.output.hex_short.setup({ uppercase = true })

			return {
				highlighter = {
					auto_enable = true,
					filetypes = colored_fts,
				},
				win_opts = {
					border = icons.ui.Border_Single_Line,
				},
			}
		end,
	},
}
