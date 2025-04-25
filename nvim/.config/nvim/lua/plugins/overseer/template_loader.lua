local M = {}

-- Recursively collect templates from nested folders
function M.load_all()
	local templates = {}
	local root = vim.fn.stdpath("config") .. "/lua/plugins/overseer/templates"
	local template_paths = vim.fn.globpath(root, "**/*.lua", true, true)

	for _, file in ipairs(template_paths) do
		local ok, tpl = pcall(dofile, file)
		if ok and type(tpl) == "table" then
			table.insert(templates, tpl)
		else
			vim.notify("Failed to load template: " .. file, vim.log.levels.ERROR)
		end
	end

	return templates
end

-- Load only templates matching a language in their metadata
function M.load_by_language(lang)
	if type(lang) ~= "string" then
		vim.notify("Invalid language type for template loader", vim.log.levels.WARN)
		return {}
	end
	local all_templates = M.load_all()
	local filtered = {}

	lang = lang:lower()

	for _, tpl in ipairs(all_templates) do
		local metadata = tpl.metadata or {}
		local languages = metadata.languages or {}
		for _, l in ipairs(languages) do
			if l:lower() == lang then
				table.insert(filtered, tpl)
				break
			end
		end
	end

	return filtered
end

-- Register templates on demand for the current filetype
function M.register_by_language(lang)
	local overseer = require("overseer")
	local templates = M.load_by_language(lang)
	for _, tpl in ipairs(templates) do
		overseer.register_template(tpl)
	end
end

-- Auto-register all found templates with Overseer
function M.register_all()
	local overseer = require("overseer")
	local templates = M.load_all()
	for _, tpl in ipairs(templates) do
		overseer.register_template(tpl)
	end
end

return M
