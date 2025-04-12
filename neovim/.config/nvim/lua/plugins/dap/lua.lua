local M = {}

M.init = function()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "lua",
		callback = function()
			vim.schedule(function()
				vim.keymap.set("n", "<leader>da", function()
					vim.cmd('lua require("osv").launch({ port = 8086 })')
				end, { desc = "[d]ebug lua [a]dapter", silent = true })
			end)
		end,
	})
end

return M
