local M = {}
local template_loader = require("plugins.overseer.template_loader")
local overseer = require("overseer")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

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

	-- pickers
	-- 	.new({}, {
	-- 		prompt_title = "Overseer Task Templates (" .. ft .. ")",
	-- 		finder = finders.new_table({
	-- 			results = templates,
	-- 			entry_maker = function(entry)
	-- 				return {
	-- 					value = entry,
	-- 					display = entry.desc or entry.name or "Unnamed Template",
	-- 					ordinal = (entry.name or "") .. " " .. (entry.desc or ""),
	-- 				}
	-- 			end,
	-- 		}),
	-- 		sorter = conf.generic_sorter({}),
	-- 		attach_mappings = function(prompt_bufnr, _) -- (prompt_bufnr, map)
	-- 			actions.select_default:replace(function()
	-- 				local selection = action_state.get_selected_entry()
	-- 				actions.close(prompt_bufnr)
	-- 				if selection and selection.value then
	-- 					overseer.run_template(selection.value)
	-- 				else
	-- 					vim.notify("No template selected", vim.log.levels.WARN)
	-- 				end
	-- 			end)
	-- 			return true
	-- 		end,
	-- 	})
	-- 	:find()

	pickers
		.new({}, {
			prompt_title = "Overseer Task Templates (" .. ft .. ")",
			finder = finders.new_table({
				results = templates,
				entry_maker = function(entry)
					local cmd_preview = ""
					if type(entry.builder) == "function" then
						local ok, result = pcall(entry.builder)
						if ok and type(result) == "table" then
							local cmd = result.cmd or ""
							local args = result.args or {}

							-- Handle if cmd is a string or a table
							local cmd_str = type(cmd) == "table" and table.concat(cmd, " ") or tostring(cmd)
							local args_str = table.concat(args, " ")
							cmd_preview = string.format("%s %s", cmd_str, args_str)
						end
					end

					local icon = "⚙️"
					local name = entry.name or "Unnamed"
					local desc = entry.desc or ""
					return {
						value = entry,
						display = string.format("%s %s [%s]", icon, name, desc),
						ordinal = table.concat({ name, desc, cmd_preview }, " "),
						preview_command = cmd_preview,
					}
				end,
			}),
			previewer = require("telescope.previewers").new_buffer_previewer({
				define_preview = function(self, entry)
					local cmd = entry.preview_command or "No preview available"
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(cmd, "\n"))
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection and selection.value then
						overseer.run_template(selection.value)
					else
						vim.notify("No template selected", vim.log.levels.WARN)
					end
				end)
				return true
			end,
		})
		:find()
end

return M
