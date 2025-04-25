local M = {}

M.opts = {
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
}

M.config = function(_, opts)
	local ufo_status_ok, ufo = pcall(require, "ufo")
	if not ufo_status_ok then
		return
	end

	local handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = (" 󰘖 %d "):format(endLnum - lnum)
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
end

return M
