return {
	-- STATUS COLUMN CONFIG
	{
		"luukvbaal/statuscol.nvim",
		event = "VimEnter",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				setopt = true,
				segments = {
					{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
					{ text = { " " } },
					-- {
					-- 	sign = { name = { "Diagnostic" }, maxwidth = 1, auto = false },
					-- 	click = "v:lua.ScSa",
					-- },
					{
						sign = {
							name = {
								"Dap",
								"neotest", --[[ "Diagnostic" ]]
							},
							maxwidth = 1,
							colwidth = 2,
							auto = true,
						},
						click = "v:lua.ScSa",
					},
					{
						sign = {
							name = { ".*" },
							namespace = { "gitsigns" },
							maxwidth = 1,
							colwidth = 2,
							auto = false,
							-- fillchar = require("utils.icons").ui.statuscol,
							-- fillcharhl = "StatusColumnSeparator",
							-- fillcharhl = "NONE",
						},
						click = "v:lua.ScSa",
					},
					{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
					{ text = { " " } },
					-- {
					-- 	text = { " ", builtin.foldfunc, " " },
					-- 	condition = { builtin.not_empty, true, builtin.not_empty },
					-- 	click = "v:lua.ScFa",
					-- },
				},
				ft_ignore = {
					"help",
					"vim",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"noice",
					"lazy",
					"toggleterm",
				},
			})
		end,
	},

	-- FOLD
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		event = "VeryLazy",
		init = function()
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		end,
		opts = {
			-- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
			-- provider_selector = function(bufnr, filetype, buftype)
			--   return { "treesitter", "indent" }
			-- end,
			open_fold_hl_timeout = 400,
			-- close_fold_kinds = { "imports", "comment" },
			preview = {
				win_config = {
					border = { "", "─", "", "", "", "─", "", "" },
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
					jumpTop = "[",
					jumpBot = "]",
				},
			},
		},
		config = function(_, opts)
			local ufo_status_ok, ufo = pcall(require, "ufo")
			if not ufo_status_ok then
				return
			end

			-- setFoldVirtTextHandler
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local totalLines = vim.api.nvim_buf_line_count(0)
				local foldedLines = endLnum - lnum
				local suffix = (" 󰘖 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end

				local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
				suffix = (" "):rep(rAlignAppndx) .. suffix
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			opts["fold_virt_text_handler"] = handler
			ufo.setup(opts)

			-- auto fold when buffer opens
			local bufnr = vim.api.nvim_get_current_buf()
			ufo.setFoldVirtTextHandler(bufnr, handler)

			-- keymaps
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
			vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
			vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
			vim.keymap.set("n", "K", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					-- choose one of coc.nvim and nvim lsp
					vim.lsp.buf.hover()
				end
			end)
		end,
	},
}
