local M = {}
local icons = require("core.icons")

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

function M.open_lsp_info_floating_window()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if not clients or #clients == 0 then
		vim.notify("No active LSP clients for this buffer", vim.log.levels.WARN)
		return
	end

	-- Define your highlight groups here
	local hl = {
		title = "@label", -- for titles like "LSP Server:"
		subtitle = "@text.title", -- for secondary titles like "Capabilities:"
		subsection = "Keyword", -- Supported:, Unsupported:
		status_ok = "DiffAdd", -- ✓
		status_fail = "DiffDelete", -- ×
		string = "String",
		number = "Number",
		type = "Type",
		capability = "Type", -- capability names (hover, completion, etc.)
	}

	local lines = {}
	local highlights = {}

	for _, client in ipairs(clients) do
		local server_name = client.name or "Unknown"
		table.insert(lines, "LSP Server: " .. server_name)
		table.insert(highlights, { line = #lines - 1, start = 0, finish = 10, group = hl.title })

		table.insert(lines, string.format("Buffer #: %d", bufnr))
		table.insert(highlights, { line = #lines - 1, start = 0, finish = 7, group = hl.title })

		local attached_buffers = vim.lsp.get_buffers_by_client_id(client.id) or {}
		local is_attached = vim.tbl_contains(attached_buffers, bufnr)
		local status = is_attached and "Running" or (client.is_stopped and "Stopped" or "Unknown")

		table.insert(lines, "Status: " .. status)
		table.insert(highlights, {
			line = #lines - 1,
			start = 8,
			finish = 8 + #status,
			group = status == "Running" and hl.status_ok or hl.status_fail,
		})

		local cmd = client.config.cmd
		local cmd_line = "(external)"

		if type(cmd) == "table" then
			cmd_line = table.concat(cmd, " ")
		elseif type(cmd) == "string" then
			cmd_line = cmd
		elseif type(cmd) == "function" then
			-- Try to get function name if available
			local info = debug.getinfo(cmd, "n")
			local name = info and info.name or "anonymous"
			cmd_line = "(function: " .. name .. ")"
		end

		table.insert(lines, "Cmd: " .. cmd_line)
		table.insert(highlights, { line = #lines - 1, start = 0, finish = 3, group = hl.title })
		table.insert(highlights, { line = #lines - 1, start = 5, finish = 5 + #cmd_line, group = hl.string })

		-- Compact Capabilities
		if client.server_capabilities then
			local supported = {}
			local unsupported = {}

			for cap, available in pairs(client.server_capabilities) do
				if available then
					table.insert(supported, cap)
				else
					table.insert(unsupported, cap)
				end
			end

			-- Capabilities main title
			table.insert(lines, "Capabilities:")
			table.insert(highlights, { line = #lines - 1, start = 0, finish = 12, group = hl.subtitle })

			-- Supported section
			table.insert(lines, "  Supported:")
			table.insert(highlights, { line = #lines - 1, start = 2, finish = 11, group = hl.subsection })

			for _, cap in ipairs(supported) do
				local line = "    ✓ " .. cap
				table.insert(lines, line)
				-- table.insert(highlights, { line = #lines - 1, start = 4, finish = 5, group = hl.status_ok })
				table.insert(highlights, { line = #lines - 1, start = 6, finish = 6 + #cap, group = hl.capability })
			end

			-- Unsupported section
			table.insert(lines, "  Unsupported:")
			table.insert(highlights, { line = #lines - 1, start = 2, finish = 13, group = hl.subsection })

			for _, cap in ipairs(unsupported) do
				local line = "    × " .. cap
				table.insert(lines, line)
				-- table.insert(highlights, { line = #lines - 1, start = 4, finish = 5, group = hl.status_fail })
				table.insert(highlights, { line = #lines - 1, start = 6, finish = 6 + #cap, group = hl.capability })
			end
		end

		local attached_count = #attached_buffers

		if attached_count > 0 then
			table.insert(
				lines,
				string.format("Attached Buffers: %d [%s]", attached_count, table.concat(attached_buffers, ", "))
			)
		else
			table.insert(lines, string.format("Attached Buffers: %d", attached_count))
		end

		-- Highlights
		table.insert(highlights, { line = #lines - 1, start = 0, finish = 16, group = hl.subtitle })
		table.insert(
			highlights,
			{ line = #lines - 1, start = 18, finish = 18 + tostring(attached_count):len(), group = "Number" }
		)
	end

	-- Create buffer and window
	local float_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)

	for _, h in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(float_buf, -1, h.group, h.line, h.start, h.finish)
	end

	local width = 100
	local max_height = 40
	local height = math.min(max_height, #lines)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = icons.ui.Border_Single_Line,
	}
	local win = vim.api.nvim_open_win(float_buf, true, opts)

	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = float_buf, nowait = true, silent = true })
	vim.keymap.set("n", "<esc>", "<cmd>close<CR>", { buffer = float_buf, nowait = true, silent = true })
	vim.keymap.set("n", "<C-c>", "<cmd>close<CR>", { buffer = float_buf, nowait = true, silent = true })
end

return M
