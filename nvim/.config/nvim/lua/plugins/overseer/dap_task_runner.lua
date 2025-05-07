local M = {}

local overseer = require("overseer")
local dap = require("dap")

function M.run_with_task(task_name, dap_config)
	-- Run Overseer build task first
	overseer.run_template({ name = task_name }, function(task)
		if not task then
			vim.notify("Overseer task not found: " .. task_name, vim.log.levels.ERROR)
			return
		end

		-- Wait for task to complete
		overseer.on_task_complete(task, function(status)
			if status == "SUCCESS" then
				dap.run(dap_config)
			else
				vim.notify("Build failed: skipping debug", vim.log.levels.WARN)
			end
		end)
	end)
end

return M
