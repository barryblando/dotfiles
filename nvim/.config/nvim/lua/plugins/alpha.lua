local M = {}

M.opts = function()
	local path = require("plenary.path")
	local dashboard = require("alpha.themes.dashboard")
	local nvim_web_devicons = require("nvim-web-devicons")
	local cdir = vim.fn.getcwd()

	local function get_extension(fn)
		local match = fn:match("^.+(%..+)$")
		local ext = ""
		if match ~= nil then
			ext = match:sub(2)
		end
		return ext
	end

	local function icon(fn)
		local nwd = require("nvim-web-devicons")
		local ext = get_extension(fn)
		return nwd.get_icon(fn, ext, { default = true })
	end

	local function file_button(fn, sc, short_fn)
		short_fn = short_fn or fn
		local ico_txt
		local fb_hl = {}

		local ico, hl = icon(fn)
		local hl_option_type = type(nvim_web_devicons.highlight)
		if hl_option_type == "boolean" then
			if hl and nvim_web_devicons.highlight then
				table.insert(fb_hl, { hl, 0, 1 })
			end
		end
		if hl_option_type == "string" then
			table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 })
		end
		ico_txt = ico .. "  "

		local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. " <CR>")
		local fn_start = short_fn:match(".*/")
		if fn_start ~= nil then
			table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt - 2 })
		end
		file_button_el.opts.hl = fb_hl
		return file_button_el
	end

	local default_mru_ignore = { "gitcommit" }

	local mru_opts = {
		ignore = function(mpath, ext)
			return (string.find(mpath, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
		end,
	}

	--- @param start number
	--- @param cwd string optional
	--- @param items_number number optional number of items to generate, default = 10
	local function mru(start, cwd, items_number, opts)
		opts = opts or mru_opts
		items_number = items_number or 9

		local oldfiles = {}
		for _, v in pairs(vim.v.oldfiles) do
			if #oldfiles == items_number then
				break
			end
			local cwd_cond
			if not cwd then
				cwd_cond = true
			else
				cwd_cond = vim.startswith(v, cwd)
			end
			local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
			if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
				oldfiles[#oldfiles + 1] = v
			end
		end

		local special_shortcuts = { "a", "s", "d" }
		local target_width = 35

		local tbl = {}
		for i, fn in ipairs(oldfiles) do
			local short_fn
			if cwd then
				short_fn = vim.fn.fnamemodify(fn, ":.")
			else
				short_fn = vim.fn.fnamemodify(fn, ":~")
			end

			if #short_fn > target_width then
				short_fn = path.new(short_fn):shorten(1, { -2, -1 })
				if #short_fn > target_width then
					short_fn = path.new(short_fn):shorten(1, { -1 })
				end
			end

			local shortcut = ""
			if i <= #special_shortcuts then
				shortcut = special_shortcuts[i]
			else
				shortcut = tostring(i + start - 1 - #special_shortcuts)
			end

			local file_button_el = file_button(fn, " " .. shortcut, short_fn)
			tbl[i] = file_button_el
		end
		return {
			type = "group",
			val = tbl,
			opts = {},
		}
	end

	local logo = {
		[[██████╗ ███████╗████████╗██████╗  ██████╗          ██████╗ ██╗  ██╗██████╗  ██╗███████╗]],
		[[█╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═████╗        ██╔═████╗╚██╗██╔╝╚════██╗███║██╔════╝]],
		[[██████╔╝█████╗     ██║   ██████╔╝██║██╔██║        ██║██╔██║ ╚███╔╝  █████╔╝╚██║███████╗]],
		[[██╔══██╗██╔══╝     ██║   ██╔══██╗████╔╝██║        ████╔╝██║ ██╔██╗  ╚═══██╗ ██║╚════██║]],
		[[██║  ██║███████╗   ██║   ██║  ██║╚██████╔╝███████╗╚██████╔╝██╔╝ ██╗██████╔╝ ██║███████║]],
		[[╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═╝╚══════╝]],
	}

	local function lineColor(lines, popStart, popEnd)
		local out = {}
		for i, line in ipairs(lines) do
			local hi = "StartLogo" .. i
			if i > popStart and i <= popEnd then
				hi = "StartLogoPop" .. i - popStart
			elseif i > popStart then
				hi = "StartLogo" .. i - popStart
			else
				hi = "StartLogo" .. i
			end
			table.insert(out, { hi = hi, line = line })
		end
		return out
	end

	local headers = {
		lineColor(logo, 0, 6),
	}

	local function header_chars()
		math.randomseed(os.time())
		return headers[math.random(#headers)]
	end

	local function header_color()
		-- local lines = {}
		-- for i, line_chars in pairs(header_chars()) do
		-- 	local hi = "StartLogo" .. i
		-- 	local line = {
		-- 		type = "text",
		-- 		val = line_chars,
		-- 		opts = {
		-- 			hl = hi,
		-- 			shrink_margin = false,
		-- 			position = "center",
		-- 		},
		-- 	}
		-- 	table.insert(lines, line)
		-- end

		local lines = {}
		for _, lineConfig in pairs(header_chars()) do
			local hi = lineConfig.hi
			local line_chars = lineConfig.line
			local line = {
				type = "text",
				val = line_chars,
				opts = {
					hl = hi,
					shrink_margin = false,
					position = "center",
				},
			}
			table.insert(lines, line)
		end

		local output = {
			type = "group",
			val = lines,
			opts = { position = "center" },
		}

		return output
	end

	local section_mru = {
		type = "group",
		val = {
			{
				type = "text",
				val = "Recent files",
				opts = {
					hl = "SpecialComment",
					shrink_margin = false,
					position = "center",
				},
			},
			{ type = "padding", val = 1 },
			{
				type = "group",
				val = function()
					return { mru(1, cdir, 9) }
				end,
				opts = { shrink_margin = false },
			},
		},
	}

	local buttons = {
		type = "group",
		val = {
			{ type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
			{ type = "padding", val = 1 },
			dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files <cr>"),
			-- dashboard.button("d", "󰉋 " .. " Recent directories", "<cmd>Telescope zoxide list<cr>"),
			dashboard.button("r", " " .. " Recent files", "<cmd>Telescope oldfiles <cr>"),
			dashboard.button("g", " " .. " Find text", "<cmd>Telescope live_grep <cr>"),
			dashboard.button("c", " " .. " Config", "<cmd>cd ~/.config/nvim | e $MYVIMRC <cr>"),
			dashboard.button("s", " " .. " Restore Session", "<cmd>SessionRestore<cr>"),
			dashboard.button("l", "󰒲 " .. " Lazy", "<cmd>Lazy<cr>"),
			dashboard.button("q", " " .. " Quit", "<cmd>qa<cr>"),
		},
	}

	local opts = {
		layout = {
			{ type = "padding", val = 8 },
			header_color(),
			{ type = "padding", val = 2 },
			section_mru,
			{ type = "padding", val = 2 },
			buttons,
		},
		-- opts = {
		-- 	margin = 5,
		-- },
	}

	dashboard.opts = opts

	return dashboard
end

M.config = function(_, dashboard)
	-- close Lazy and re-open when the dashboard is ready
	if vim.o.filetype == "lazy" then
		vim.cmd.close()
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				require("lazy").show()
			end,
		})
	end

	require("alpha").setup(dashboard.opts)

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			vim.list_extend(dashboard.opts.layout, {
				{ type = "padding", val = 2 },
				{
					type = "text",
					val = "⚡" .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms",
					opts = { hl = "AlphaFooter", position = "center" },
				},
			})
			pcall(vim.cmd.AlphaRedraw)
		end,
	})
end

return M
