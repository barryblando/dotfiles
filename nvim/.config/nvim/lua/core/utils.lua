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
		subsection_supported = "@function", -- Supported:
		subsection_unsupported = "@exception", -- Unsupported:
		status_ok = "@diff.plus", -- ✓
		status_fail = "@diff.minus", -- ×
		string = "String",
		number = "Number",
		type = "Type",
		capability = "@field", -- capability names (hover, completion, etc.)
	}

	local function get_client_pid(client)
		-- Check the LSP server's command (cmd)
		if client.config and client.config.cmd then
			local cmd = client.config.cmd
			local cmd_name

			-- If the command is a table, take the first element (the command)
			if type(cmd) == "table" then
				cmd_name = cmd[1]
			elseif type(cmd) == "string" then
				cmd_name = cmd
			end

			-- If the command name is valid, try to find the PID using system process tools
			if cmd_name then
				local success, handle = pcall(io.popen, "pgrep -o -f '" .. cmd_name .. "'") -- Get the oldest PID that matches
				if success and handle then
					local pid = handle:read("*a")
					handle:close()

					-- Check if pid is nil or empty
					if pid and pid ~= "" then
						return pid:match("^%s*(%d+)%s*$") -- Return the first PID found
					else
						-- Handle case where no PID is found
						return "(no PID found)"
					end
				else
					-- If pcall fails or handle is nil, return a safe fallback
					return "(failed to retrieve PID)"
				end
			end
		end

		-- Fallback if PID is not found
		return "(unknown)"
	end

	local lines = {}
	local highlights = {}

	for _, client in ipairs(clients) do
		local server_name = client.name or "Unknown"
		local pid = get_client_pid(client)
		local attached_buffers = vim.lsp.get_buffers_by_client_id(client.id) or {}

		local header_line = string.format(
			"LSP Server: %s (id: %d, pid: %s, bufnr: [%s])",
			server_name,
			client.id,
			pid,
			table.concat(attached_buffers, ", ")
		)
		table.insert(lines, header_line)
		table.insert(highlights, { line = #lines - 1, start = 0, finish = 10, group = hl.title })

		local is_attached = vim.tbl_contains(attached_buffers, bufnr)
		local status = is_attached and "Running" or (client.is_stopped and "Stopped" or "Unknown")
		table.insert(lines, "Status: " .. status)
		table.insert(highlights, { line = #lines - 1, start = 0, finish = 6, group = hl.title })
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
			local info = debug.getinfo(cmd, "n")
			local name = info and info.name or "anonymous"
			cmd_line = "(function: " .. name .. ")"
		end

		table.insert(lines, "Cmd: " .. cmd_line)
		table.insert(highlights, { line = #lines - 1, start = 0, finish = 3, group = hl.title })
		table.insert(highlights, { line = #lines - 1, start = 5, finish = 5 + #cmd_line, group = hl.string })

		if client.server_capabilities then
			local supported, unsupported = {}, {}
			for cap, available in pairs(client.server_capabilities) do
				if available then
					table.insert(supported, cap)
				else
					table.insert(unsupported, cap)
				end
			end

			table.insert(lines, "Capabilities:")
			table.insert(highlights, { line = #lines - 1, start = 0, finish = 12, group = hl.subtitle })

			table.insert(lines, "  Supported:")
			table.insert(highlights, { line = #lines - 1, start = 2, finish = 11, group = hl.subsection_supported })

			for _, cap in ipairs(supported) do
				local line = "    ✓ " .. cap
				table.insert(lines, line)
				table.insert(highlights, { line = #lines - 1, start = 4, finish = 5, group = hl.status_ok })
				table.insert(highlights, { line = #lines - 1, start = 6, finish = 8 + #cap, group = hl.capability })
			end

			table.insert(lines, "  Unsupported:")
			table.insert(highlights, { line = #lines - 1, start = 2, finish = 13, group = hl.subsection_unsupported })

			for _, cap in ipairs(unsupported) do
				local line = "    × " .. cap
				table.insert(lines, line)
				table.insert(highlights, { line = #lines - 1, start = 4, finish = 5, group = hl.status_fail })
				table.insert(highlights, { line = #lines - 1, start = 6, finish = 8 + #cap, group = hl.capability })
			end
		end
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

M.get_visual_selection = function()
	-- Only proceed if in visual mode
	local mode = vim.fn.mode()
	if not mode:match("[vV]") then -- visual, V-line, V-block
		return nil, nil
	end

	-- Get selection range
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	-- Get selected lines
	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	if #lines == 0 then
		return nil, nil
	end

	-- Handle single or multi-line selection
	if #lines == 1 then
		lines[1] = lines[1]:sub(start_pos[3], end_pos[3])
	else
		lines[1] = lines[1]:sub(start_pos[3])
		lines[#lines] = lines[#lines]:sub(1, end_pos[3])
	end

	local selection = table.concat(lines, "\n")

	-- Escape only for regex-based search (ripgrep)
	local function escape_regex(text)
		return text:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
	end

	local escaped = escape_regex(selection)

	return selection, escaped
end

return M
