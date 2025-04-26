local M = {}

M.init = function()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local lang = args.match
			if type(lang) == "string" then
				require("plugins.overseer.template_loader").register_by_language(lang)
			else
				vim.notify("Invalid filetype in FileType autocmd", vim.log.levels.WARN)
			end
		end,
	})
end

M.config = function()
	require("overseer").setup({
		-- Setup DAP later when lazy-loading the plugin.
		dap = true,
		task_list = {
			default_detail = 2,
			direction = "bottom",
			max_width = { 600, 0.7 },
			bindings = {
				["<C-b>"] = "ScrollOutputUp",
				["<C-f>"] = "ScrollOutputDown",
				["H"] = "IncreaseAllDetail",
				["L"] = "DecreaseAllDetail",
				["<CR>"] = "RunAction",
				["<C-x>"] = "Terminate",
				-- Disable mappings I don't use.
				["g?"] = false,
				["<C-l>"] = false,
				["<C-h>"] = false,
				["{"] = false,
				["}"] = false,
			},
		},
		form = {
			win_opts = { winblend = 0 },
		},
		confirm = {
			win_opts = { winblend = 5 },
		},
		task_win = {
			win_opts = { winblend = 5 },
		},
	})
end

M.keys = function()
	return {
		{
			"<leader>oT",
			function()
				require("plugins.overseer.fuzzy_picker").pick_template_for_filetype()
			end,
			desc = "Run Task Template (Fzf-Lua)",
		},
		{
			"<leader>ow",
			"<cmd>OverseerToggle<cr>",
			desc = "Toggle task [w]indow",
		},
	}
end

return M
