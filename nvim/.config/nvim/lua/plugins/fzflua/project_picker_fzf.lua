-- dependencies
local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")
if not has_fzf_lua then
	error("fzf-lua is a dependency of project-fzf")
	return
end

local has_project = pcall(require, "project_nvim")
if not has_project then
	error("project_nvim is a dependency of project-fzf")
	return
end

local history = require("project_nvim.utils.history")
local project = require("project_nvim.project")
local config = require("project_nvim.config")

local M = {}

local function format_for_display(project_path)
	local name = project_path:match("/([^/]+)$")
	return name, string.format("%-30s %s", name, project_path)
end

local function get_project_data(projects_data, selection)
	if not selection or #selection < 1 then
		return
	end

	local selected = selection[1]
	local data = projects_data[selected]

	if data == nil then
		error("selected entry does not have data in the backing store. should not be possible")
		return {}
	end

	return data
end

local function change_working_directory_by_selection(projects_data, selection)
	local data = get_project_data(projects_data, selection)
	if data == nil then
		return false, {}
	end
	local cd_successful = project.set_pwd(data.path, "fzf-lua")
	return cd_successful, data
end

function M.project_picker()
	local recent_projects = history.get_recent_projects()
	for i = 1, math.floor(#recent_projects / 2) do
		recent_projects[i], recent_projects[#recent_projects - i + 1] =
			recent_projects[#recent_projects - i + 1], recent_projects[i]
	end

	local projects_display = {}
	local projects_data = {}
	for _, project_path in ipairs(recent_projects) do
		local name, display = format_for_display(project_path)
		table.insert(projects_display, display)
		projects_data[display] = {
			name = name,
			path = project_path,
		}
	end

	fzf_lua.fzf_exec(projects_display, {
		prompt = " Projects ",
		fzf_opts = {
			["--ansi"] = true,
			["--header"] = "select a project to change directory",
			["--preview-window"] = "up:60%,noborder",
			["--preview"] = {
				type = "cmd",
				fn = function(items)
					local selection = items[1]
					if not selection then
						return 'echo "No Preview Available"'
					end

					-- Extract the path part
					local path = selection:match("(%S+)$") -- match the last "word" (path)

					if not path or path == "" then
						return 'echo "No Preview Available"'
					end

					-- Expand ~ to $HOME
					path = path:gsub("^~", vim.env.HOME)

					local output_lines = nil

					if vim.fn.executable("eza") == 1 then
						output_lines = vim.fn.systemlist({ "eza", "--color=always", "--tree", "--level=2", path })
					end

					if not output_lines or vim.tbl_isempty(output_lines) then
						return 'echo "No preview available. Install eza."'
					end

					local escaped = vim.tbl_map(function(line)
						return line:gsub('"', '\\"')
					end, output_lines)

					return string.format('echo "%s"', table.concat(escaped, "\\n"))
				end,
			},
		},
		winopts = {
			height = 0.6,
			width = 0.6,
		},
		actions = {
			default = function(selection)
				local cd_successful, _ = change_working_directory_by_selection(projects_data, selection)
				local opts = { hidden = config.options.show_hidden }

				if cd_successful then
					fzf_lua.files(opts)
				end
			end,
			["ctrl-s"] = function(selection)
				local cd_successful, _ = change_working_directory_by_selection(projects_data, selection)
				local opts = { hidden = config.options.show_hidden }

				if cd_successful then
					fzf_lua.live_grep(opts)
				end
			end,
			["ctrl-r"] = function(selection)
				local cd_successful, data = change_working_directory_by_selection(projects_data, selection)
				if data == nil then
					return
				end

				local opts = {
					cwd = data.path,
					cwd_only = true,
					hidden = config.options.show_hidden,
				}

				if cd_successful then
					fzf_lua.oldfiles(opts)
				end
			end,
			["ctrl-d"] = function(selection)
				local data = get_project_data(projects_data, selection)
				if data == nil then
					return
				end

				local choice = vim.fn.confirm("delete '" .. data.name .. "' from project list?", "&yes\n&no", 2)

				if choice == 1 then
					history.delete_project({ value = data.path })
					M.project_picker()
				end
			end,
			["ctrl-w"] = function(selection)
				local _, _ = change_working_directory_by_selection(projects_data, selection)
			end,
		},
	})
end

return M
