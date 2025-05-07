local M = {}

local Path = require("plenary.path")
local scan = require("plenary.scandir")
local fzf = require("fzf-lua")

-- Find all executable files in target/debug (ignores .d/.rlib etc.)
function M.rust_binary_picker(callback)
	local target_dir = vim.fn.getcwd() .. "/target/debug"
	local files = scan.scan_dir(target_dir, {
		depth = 1,
		add_dirs = false,
		search_pattern = function(entry)
			return not entry:match("%.d$") and not entry:match("%.rlib$")
		end,
	})

	if #files == 0 then
		vim.notify("No Rust binaries found in target/debug", vim.log.levels.WARN)
		return
	end

	local rel_files = vim.tbl_map(function(path)
		return Path:new(path):make_relative(target_dir)
	end, files)

	fzf.fzf_exec(rel_files, {
		prompt = "Select binary> ",
		actions = {
			["default"] = function(selected)
				local full = target_dir .. "/" .. selected[1]
				callback(full)
			end,
		},
	})
end

return M
