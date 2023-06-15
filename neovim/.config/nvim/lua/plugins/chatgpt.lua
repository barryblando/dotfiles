return {
	"jackMort/ChatGPT.nvim",
	enabled = false,
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local icons = require("utils.icons")
		require("chatgpt").setup({
			api_key_cmd = "pass show api/tokens/openai",
			chat = {
				sessions_window = {
					border = {
						style = icons.ui.Border_Single_Line,
					},
				},
			},
			popup_window = {
				border = {
					style = icons.ui.Border_Single_Line,
				},
			},
			system_window = {
				border = {
					style = icons.ui.Border_Single_Line,
				},
			},
			popup_input = {
				prompt = "  ",
				border = {
					style = icons.ui.Border_Single_Line,
				},
			},
			settings_window = {
				border = {
					style = icons.ui.Border_Single_Line,
				},
			},
		})
	end,
}
