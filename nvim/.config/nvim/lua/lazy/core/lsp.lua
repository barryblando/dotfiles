return {
	"neovim/nvim-lspconfig", -- enable LSP
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"b0o/schemastore.nvim", -- providing access to the SchemaStore catalog.
		{
			"j-hui/fidget.nvim",
			-- enabled = false,
			opts = {
				progress = {
					display = {
						done_icon = "",
					},
				},
				notification = {
					window = {
						winblend = 0, -- &winblend for the window
					},
				},
			},
		},
	},
}
