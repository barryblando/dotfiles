local M = {}
local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")
local has_harpoon, harpoon = pcall(require, "harpoon")
local has_devicons, devicons = pcall(require, "nvim-web-devicons")

if not has_fzf_lua then
	error("fzf-lua is required for this integration")
end

if not has_harpoon then
	error("harpoon.nvim is required for this integration")
end

-- Function to list files from harpoon
M.harpoon_file_picker = function()
	local harpoon_list = harpoon:list()

	local function Remove(item)
		item = item or harpoon_list.config.create_list_item(harpoon_list.config)
		local Extensions = require("harpoon.extensions")
		local Logger = require("harpoon.logger")
		local items = harpoon_list.items

		if item ~= nil then
			for i = 1, harpoon_list._length do
				local v = items[i]
				-- print(vim.inspect(v))
				if harpoon_list.config.equals(v, item) then
					-- this clears list somehow
					-- items[i] = nil
					table.remove(items, i)
					harpoon_list._length = harpoon_list._length - 1

					Logger:log("HarpoonList:remove", { item = item, index = i })

					Extensions.extensions:emit(
						Extensions.event_names.REMOVE,
						{ list = harpoon_list, item = item, idx = i }
					)
					break
				end
			end
		end
	end

	local function build_lookup()
		local file_paths = {}
		local lookup = {}

		for idx, item in ipairs(harpoon_list.items) do
			local filepath = item.value
			local filename = vim.fn.fnamemodify(filepath, ":t")
			local icon = ""

			if has_devicons then
				local devicon, _ = devicons.get_icon(filename, nil, { default = true })
				icon = devicon or ""
			end

			local entry = string.format("%s %s", icon, filepath)
			table.insert(file_paths, entry)
			lookup[entry] = { path = filepath, idx = idx }
		end

		return file_paths, lookup
	end

	local function start_picker()
		local file_paths, lookup = build_lookup()

		if #file_paths == 0 then
			print("No files are marked in harpoon!")
			return
		end

		fzf_lua.fzf_exec(file_paths, {
			prompt = "󱡀 Harpoon Files ",
			multi_select = true, -- enable multi select
			winopts = {
				border = "none",
				height = 0.7,
				width = 0.6,
				preview = {
					layout = "vertical",
					vertical = "up:60%",
				},
			},
			fzf_opts = {
				["--ansi"] = true,
				["--multi"] = "", -- make multi selection allowed
				["--header"] = "<CR>: Open | <C-d>: Delete | <C-x/v>: (V)Split | <T>/<S-T>: Multi-Select | <esc>/<C-c>: Quit",
				["--preview-window"] = "up:60%,noborder", -- preview window settings
				["--border"] = "sharp",
				["--preview"] = {
					type = "cmd",
					fn = function(items)
						local item = lookup[items[1]]
						local result = nil

						if item then
							-- Check if file exists and is readable
							if vim.fn.filereadable(item.path) == 1 then
								return string.format(
									"bat --style=plain --color=always --line-range=:50 %s",
									vim.fn.shellescape(item.path)
								)
							else
								result = "No Preview Available"
							end
						end

						-- Return the preview command for FZF
						return result
					end,
				},
			},
			actions = {
				["default"] = function(selection)
					for _, sel in ipairs(selection) do
						local selected = lookup[sel]
						if selected then
							vim.cmd("edit " .. selected.path)
						end
					end
				end,
				["ctrl-d"] = function(selection)
					local to_delete = {}

					for _, sel in ipairs(selection) do
						local selected = lookup[sel]
						if selected then
							table.insert(to_delete, selected.path)
						end
					end

					if #to_delete == 0 then
						return
					end

					local choice = vim.fn.confirm("Remove selected file(s) from Harpoon?", "&Yes\n&No", 2)
					if choice == 1 then
						for _, path in ipairs(to_delete) do
							Remove({ value = path })
						end
						vim.schedule(start_picker)
					end
				end,
				["ctrl-r"] = function()
					vim.schedule(start_picker)
				end,
				["ctrl-x"] = function(selection)
					for _, sel in ipairs(selection) do
						local selected = lookup[sel]
						if selected then
							vim.cmd("split " .. selected.path)
						end
					end
				end,
				["ctrl-v"] = function(selection)
					for _, sel in ipairs(selection) do
						local selected = lookup[sel]
						if selected then
							vim.cmd("vsplit " .. selected.path)
						end
					end
				end,
			},
		})
	end

	start_picker()
end

return M
