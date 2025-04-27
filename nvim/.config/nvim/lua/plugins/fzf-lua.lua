local M = {}

M.config = function()
	require("fzf-lua").setup({
		file_icon_padding = " ",
		winopts = {
			border = "border-sharp",
			fullscreen = false,
			preview = {
				border = "border-sharp",
				layout = "vertical",
				vertical = "up:65%",
				scrollbar = false,
				wrap = "wrap",
			},
		},
		files = {
			-- previewer = "bat", -- or 'builtin'
			git_icons = true,
			file_icons = true,
		},
		grep = {
			rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!node_modules/*'",
		},
		git = {
			commits = {
				preview_pager = "delta --line-numbers",
			},
		},
		lsp = { code_actions = { previewer = "codeaction_native" } },
	})
end

return M
