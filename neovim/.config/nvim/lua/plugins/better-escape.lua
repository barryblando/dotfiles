local M = {}

M.config = function()
	-- w/ clear_empty_lines
	local clear_esc = function()
		vim.api.nvim_input("<esc>")
		local current_line = vim.api.nvim_get_current_line()
		if current_line:match("^%s+j$") then
			vim.schedule(function()
				vim.api.nvim_set_current_line("")
			end)
		end
	end

	local esc = function()
		-- Escape insert mode when jk is pressed
		if vim.bo.filetype == "toggleterm" then
			-- Type 'jk' normally when inside filetype 'Yourfiletype'
			-- <c-v> is used to avoid mappings
			return "<c-v>j<c-v>k"
		end
		return clear_esc()
	end

	require("better_escape").setup({
		timeout = vim.o.timeoutlen,
		default_mappings = false,
		mappings = {
			i = {
				j = {
					-- These can all also be functions
					k = esc,
					j = esc,
				},
				k = {
					k = esc,
					j = esc,
				},
			},
			c = {
				j = {
					k = esc,
					j = esc,
				},
				k = {
					k = esc,
					j = esc,
				},
			},
			t = {
				j = {
					k = esc,
					j = esc,
				},
				k = {
					k = esc,
					j = esc,
				},
			},
			s = {
				j = {
					k = esc,
					j = esc,
				},
				k = {
					k = esc,
					j = esc,
				},
			},
		},
	})
end

return M
