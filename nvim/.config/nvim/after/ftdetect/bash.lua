vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufWritePost" }, {
	pattern = "*",
	callback = function(args)
		local buf = args.buf
		local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
		if first_line:match("^#!.*/bash") then
			vim.bo[buf].filetype = "sh"
		end
	end,
})
