local M = {}

local function open_and_close()
	local overseer = require("overseer")

	-- Open the task window.
	overseer.open({ enter = false })

	-- Close it after 10 seconds (if not inside the window).
	vim.defer_fn(function()
		if vim.bo.filetype ~= "OverseerList" then
			overseer.close()
		end
	end, 10 * 1000)
end

M.opts = {
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
}

M.keys = {
	{
		"<leader>ow",
		"<cmd>OverseerToggle<cr>",
		desc = "toggle task [w]indow",
	},
	{
		"<leader>or",
		function()
			local overseer = require("overseer")

			local tasks = overseer.list_tasks({ recent_first = true })
			if vim.tbl_isempty(tasks) then
				vim.notify("No tasks found", vim.log.levels.WARN)
			else
				overseer.run_action(tasks[1], "restart")
				open_and_close()
			end
		end,
		desc = "[r]estart last task",
	},
	{
		"<leader>ot",
		function()
			require("overseer").run_template({}, function(task)
				if task then
					open_and_close()
				end
			end)
		end,
		desc = "run [t]ask",
	},
}

return M
