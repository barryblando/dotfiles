local M = {}

function M.toggle_format_on_save()
	if vim.g.disable_autoformat or vim.b[vim.api.nvim_get_current_buf()].disable_autoformat then
		vim.b.disable_autoformat = false
		vim.g.disable_autoformat = false
		vim.notify("Re-enable autoformat-on-save")
	else
		vim.b.disable_autoformat = true
		vim.g.disable_autoformat = true
		vim.notify("Disable autoformat-on-save")
	end
end

function M.toggle_option(option)
	local value = not vim.api.nvim_get_option_value(option, {})
	vim.opt[option] = value
	vim.notify(option .. " set to " .. tostring(value))
end

function M.smart_quit()
	local bufnr = vim.api.nvim_get_current_buf()
	local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
	if modified then
		vim.ui.input({
			prompt = "You have unsaved changes. Quit anyway? (y/n) ",
		}, function(input)
			if input == "y" then
				vim.cmd("q!")
			end
		end)
	else
		vim.cmd("q!")
	end
end

-- basic telescope harpoon configuration
function M.harpoon_ui(harpoon_files)
	local conf = require("telescope.config").values
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

function M.collect_specs(excluded_dirs)
	local specs = {}
	local root = vim.fn.stdpath("config") .. "/lua/lazy"
	local plugin_files = vim.fn.globpath(root, "**/*.lua", false, true)

	for _, file in ipairs(plugin_files) do
		if not file:match("/lazy/init%.lua$") then
			-- exclude full paths that include any excluded pattern
			local exclude = false
			for _, pattern in ipairs(excluded_dirs) do
				if file:find("/" .. pattern .. "/") then
					exclude = true
					break
				end
			end

			if not exclude then
				local rel = file:match("lua/(.+)%.lua$")
				local mod = rel:gsub("/", ".")
				local ok, loaded = pcall(require, mod)
				if ok then
					vim.list_extend(specs, type(loaded[1]) == "table" and loaded or { loaded })
				end
			end
		end
	end

	return specs
end

return M
