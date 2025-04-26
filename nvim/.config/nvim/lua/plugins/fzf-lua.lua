local M = {}

M.config = function()
	local icons = require("core.icons")
	require("fzf-lua").setup({
		file_icon_padding = " ",
		winopts = {
			border = "border-sharp",
			fullscreen = false,
			preview = {
				border = "border-sharp",
				-- vertical = "up:60%", -- or 'right:50%'
				horizontal = "bottom:60%", -- or 'left:50%'
				layout = "flex",
			},
		},
		files = {
			previewer = "bat", -- or 'builtin'
			git_icons = true,
			file_icons = true,
		},
		grep = {
			rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!node_modules/*'",
		},
		git = {
			commits = {
				-- preview_pager = "delta --line-numbers",
			},
		},
	})
end

return M
