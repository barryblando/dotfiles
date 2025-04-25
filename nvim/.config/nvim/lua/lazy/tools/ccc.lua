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
		opts = require("plugins.ccc").opts,
	},
}
