vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "tsconfig.json", "tsconfig.*.json" },
	callback = function()
		vim.cmd("setlocal filetype=jsonc")
	end,
})
