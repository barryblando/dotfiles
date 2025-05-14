local M = {}
local fzf = require("fzf-lua")
local scandir = require("plenary.scandir")

local function get_session_dir()
	return vim.fn.stdpath("data") .. "/sessions"
end

-- Decode %2F etc.
local function decode_url(str)
	return str:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end)
end

local function get_sessions()
	local session_dir = get_session_dir()
	local files = scandir.scan_dir(session_dir, { depth = 1, add_dirs = false })

	local entries = {}
	local lookup = {}

	for _, path in ipairs(files) do
		local filename = vim.fn.fnamemodify(path, ":t")
		local decoded = decode_url(filename) -- Human-readable display
		entries[#entries + 1] = decoded
		lookup[decoded] = { path = path } -- Real file is still encoded
	end

	return entries, lookup
end

local function delete_session(path)
	if vim.fn.filereadable(path) == 1 then
		os.remove(path)
		vim.notify("Deleted session: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
	else
		vim.notify("Session not found: " .. path, vim.log.levels.WARN)
	end
end

local function load_session(path)
	if vim.fn.filereadable(path) == 1 then
		vim.cmd("source " .. vim.fn.fnameescape(path))
		vim.notify("Loaded session: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
	else
		vim.notify("Session not found: " .. path, vim.log.levels.ERROR)
	end
end

M.session_picker = function()
	local entries, lookup = get_sessions()

	fzf.fzf_exec(entries, {
		prompt = "󱇻 Sessions❯ ",
		actions = {
			["default"] = function(selected)
				local item = lookup[selected[1]]
				if item then
					load_session(item.path)
				end
			end,
			["ctrl-d"] = function(selected)
				local count = #selected

				local msg
				if count == 1 then
					msg = string.format("Delete session '%s'?", selected[1])
				else
					msg = string.format("Delete %d sessions?", count)
				end

				local choice = vim.fn.confirm(msg, "&Yes\n&No", 2)

				if choice == 1 then
					for _, name in ipairs(selected) do
						local item = lookup[name]
						if item then
							delete_session(item.path)
						end
					end
					vim.notify("Deleted " .. count .. " session(s).", vim.log.levels.INFO)
				end
				vim.schedule(M.session_picker)
			end,
		},
		fzf_opts = {
			["--ansi"] = true,
			["--multi"] = true,
			["--header"] = "<CR>: Open | <C-d>: Delete | <T>/<S-T>: Multi-Select | <esc>/<C-c>: Quit",
		},
		winopts = {
			height = 0.4, -- 60% of screen height
			width = 0.5, -- 50% of screen width
			row = 0.5, -- 20% from the top
			col = 0.5, -- centered horizontally (1 - width)/2
		},
	})
end

return M
