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
	-- Get the current buffer number
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get active LSP clients attached to the current buffer
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	-- Handle the case where no LSP clients are active
	if not clients or #clients == 0 then
		vim.notify("No active LSP clients for this buffer", vim.log.levels.WARN)
		return
	end

	local info = {}

	-- Collecting LSP server info
	for _, client in ipairs(clients) do
		-- General info
		table.insert(info, string.format("LSP Server: %s", client.name))

		-- Buffer number (this assumes you're working with the current buffer)
		table.insert(info, string.format("Buffer #: %d", bufnr))

		-- Cmd info (LSP startup command)
		local cmd = client.config.cmd or {}
		local cmd_str = table.concat(cmd, " ")
		table.insert(info, string.format("Cmd: %s", cmd_str))

		-- Status (running or stopped)
		table.insert(info, string.format("Status: %s", client.is_stopped and "Stopped" or "Running"))

		-- Server capabilities (you can further format this for better readability)
		local capabilities = client.resolved_capabilities or {}
		table.insert(info, string.format("Capabilities:"))
		for cap, available in pairs(capabilities) do
			table.insert(info, string.format("  - %s: %s", cap, available and "Yes" or "No"))
		end

		-- Attachments (buffer it is attached to)
		local buffers = client.attached_buffers or {}
		table.insert(info, string.format("Attached Buffers: %d", #buffers))
		for _, buf in ipairs(buffers) do
			table.insert(info, string.format("  - Buffer %d", buf))
		end

		-- Additional Info: If there's any other specific info you'd like to add
		-- For example, you could show a list of supported features like textDocument/hover, etc.
	end

	-- Create the floating window
	local content = table.concat(info, "\n")
	local bufnrN = vim.api.nvim_create_buf(false, true) -- create a new buffer
	vim.api.nvim_buf_set_lines(bufnrN, 0, -1, false, vim.split(content, "\n"))

	-- Get window dimensions
	local width = 100
	local height = math.min(20, #info)

	-- Create the floating window
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = icons.ui.Border_Single_Line,
	}

	local win_id = vim.api.nvim_open_win(bufnrN, true, opts)
	-- You can add additional window actions like keymaps or timers here if needed

	vim.api.nvim_buf_set_keymap(bufnrN, "n", "q", ":close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(bufnrN, "n", "<esc>", ":close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(bufnrN, "n", "<C-c>", ":close<CR>", { noremap = true, silent = true })
end

return M
