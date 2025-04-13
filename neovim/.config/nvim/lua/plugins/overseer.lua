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
	-- local overseer = require("overseer")
	-- local template_loader = require("plugins.overseer.template_loader")
	--
	-- -- Helper to create a language-specific keymap
	-- local function run_template_by_language(lang, key, desc, args)
	-- 	vim.keymap.set("n", key, function()
	-- 		local templates = template_loader.load_by_language(lang)
	--
	-- 		if #templates == 0 then
	-- 			vim.notify("No " .. lang .. " task templates found", vim.log.levels.WARN)
	-- 			return
	-- 		end
	--
	-- 		vim.ui.select(templates, {
	-- 			prompt = "Select " .. lang:gsub("^%l", string.upper) .. " task template",
	-- 			format_item = function(item)
	-- 				return item.name or item.desc
	-- 			end,
	-- 		}, function(choice)
	-- 			if choice then
	-- 				vim.notify("Running task: " .. choice.name, vim.log.levels.INFO)
	-- 				overseer.run_template({ name = choice.name })
	-- 			end
	-- 		end)
	-- 	end, { buffer = args.buf, desc = desc })
	-- end
	--
	-- vim.api.nvim_create_autocmd("BufEnter", {
	-- 	callback = function(args)
	-- 		local fname = vim.api.nvim_buf_get_name(args.buf)
	-- 		local filetype = vim.bo.filetype
	-- 		local desc = ({
	-- 			["rust"] = "Run [R]ust task template",
	-- 			["go"] = "Run [G]o task template",
	-- 			["typescript"] = "Run [T]ypeScript task template",
	-- 		})[filetype]
	--
	-- 		-- RUN tasks only on tests
	-- 		if
	-- 			fname:match("_test%.go$")
	-- 			or fname:match("%.test%.ts$")
	-- 			or fname:match("%.spec%.ts$")
	-- 			or fname:match("tests?/.*%.rs$")
	-- 		then
	-- 			run_template_by_language(filetype, "<leader>o" .. filetype:sub(1, 1), desc, args)
	-- 		end
	-- 	end,
	-- })

	-- vim.keymap.set("n", "<leader>oT", function()
	-- 	require("plugins.overseer.fuzzy_picker").pick_template_for_filetype()
	-- end, { desc = "Run Task Template (Telescope)" })

	return {
		{
			"<leader>oT",
			function()
				require("plugins.overseer.fuzzy_picker").pick_template_for_filetype()
			end,
			desc = "Run Task Template (Telescope)",
		},
		{
			"<leader>ow",
			"<cmd>OverseerToggle<cr>",
			desc = "Toggle task [w]indow",
		},
	}
end

return M
