local M = {}

M.config = function()
	local git_settings = {}
	for _, section in ipairs({ "commits", "bcommits", "branches", "stash", "status", "tag", "blame" }) do
		git_settings[section] = {
			winopts = { preview = { border = "border-bottom" } },
			preview_pager = "delta --line-numbers",
		}
	end
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
		git = git_settings,
		lsp = { code_actions = { previewer = "codeaction_native" } },
	})
end

return M
