local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

vim.schedule(function()
	local common_opts = { buffer = true, nowait = true, remap = false }

	-- Define the keymaps and their properties
	local keymaps = {
		{ "<leader>l", group = "LSP", icon = { icon = " " } },
		{ "<leader>lr", "<cmd>RustAnalyzer restart<cr>", desc = "Restart Server" },
	}

	-- Iterate through the keymaps and add common options
	local combined_keymaps = {}
	for _, map in ipairs(keymaps) do
		local combined_map = vim.tbl_extend("force", map, common_opts)
		table.insert(combined_keymaps, combined_map)
	end

	wk.add(combined_keymaps)
end)
