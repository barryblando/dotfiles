return {
	"pmizio/typescript-tools.nvim",
	enabled = true,
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {
		setttings = {
			separate_diagnostic_server = true,
			publish_diagnostic_on = "change",
			tsserver_file_preferences = {
				includeInlayParameterNameHints = "all",
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
	},
}
