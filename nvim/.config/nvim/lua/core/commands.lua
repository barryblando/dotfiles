vim.api.nvim_create_user_command("CleanCache", function()
	local paths = {
		vim.fn.stdpath("cache"),
		vim.fn.stdpath("state"),
		vim.fn.stdpath("data"),
	}

	for _, path in ipairs(paths) do
		vim.fn.delete(path, "rf")
	end

	vim.notify("Neovim cache, state, and data cleared.\nPlease restart Neovim.", vim.log.levels.WARN)
end, {})
