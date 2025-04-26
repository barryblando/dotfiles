local M = {}
local template_loader = require("plugins.overseer.template_loader")
local overseer = require("overseer")
local fzf = require("fzf-lua")
local icons = require("core.icons")

M.pick_template_for_filetype = function()
	local ft = vim.bo.filetype
	if type(ft) ~= "string" then
		vim.notify("Cannot detect filetype", vim.log.levels.WARN)
		return
	end

	local templates = template_loader.load_by_language(ft)
	if vim.tbl_isempty(templates) then
		vim.notify("No templates found for " .. ft, vim.log.levels.INFO)
		return
	end

	-- Create simple list of strings
	local lines = {}
	local lookup = {}

	for _, entry in ipairs(templates) do
		local cmd_preview = ""
		if type(entry.builder) == "function" then
			local ok, result = pcall(entry.builder)
			if ok and type(result) == "table" then
				local cmd = result.cmd or ""
				local args = result.args or {}
				local cmd_str = type(cmd) == "table" and table.concat(cmd, " ") or tostring(cmd)
				local args_str = table.concat(args, " ")
				cmd_preview = string.format("%s %s", cmd_str, args_str)
			end
		end

		local icon = "⚙️"
		local name = entry.name or "Unnamed"
		local desc = entry.desc or ""
		local display = string.format("%s %s [%s]", icon, name, desc)

		table.insert(lines, display)
		lookup[display] = {
			entry = entry,
			preview = cmd_preview,
		}
	end

	fzf.fzf_exec(lines, {
		prompt = "Overseer Task Templates (" .. ft:sub(1, 1):upper() .. ft:sub(2) .. ")> ",
		actions = {
			["default"] = function(selected)
				local sel = selected[1]
				local item = lookup[sel]
				if item then
					overseer.run_template(item.entry)
				else
					vim.notify("No template matched", vim.log.levels.WARN)
				end
			end,
		},
		fzf_opts = {
			["--ansi"] = true,
			["--preview-window"] = "up:60%,noborder",
			["--border"] = "sharp",
			["--preview"] = {
				type = "cmd",
				fn = function(items)
					local item = lookup[items[1]]
					local result = nil

					if item and type(item.entry.builder) == "function" then
						local ok, built = pcall(item.entry.builder)
						if ok and type(built) == "table" then
							result = built
						else
							result = { error = "Failed to build task" }
						end
					else
						result = { error = "No builder available" }
					end

					-- Serialize the table to a Lua-readable string
					local plines = vim.split(vim.inspect(result), "\n")
					-- Escape for shell-safe output
					local escaped = vim.tbl_map(function(line)
						return line:gsub('"', '\\"')
					end, plines)
					-- return string.format('printf "%s"', table.concat(escaped, "\\n"))
					return string.format(
						'echo "%s" | bat --language=lua --style=plain --color=always',
						table.concat(escaped, "\\n")
					)
				end,
			},
		},
		winopts = {
			border = "none",
			height = 0.4,
			width = 0.6,
			preview = {
				default = "bat",
				layout = "vertical",
				vertical = "up:60%",
			},
		},
	})
end

return M
