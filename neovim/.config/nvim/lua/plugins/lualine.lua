return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local status_ok, lualine = pcall(require, "lualine")

		if not status_ok then
			return
		end

		local icons = require("utils.icons")

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end

		-- local hl_str = function(str, hl)
		--   return "%#" .. hl .. "#" .. str .. "%*"
		-- end

		-- check if value in table
		local function contains(t, value)
			for _, v in pairs(t) do
				if v == value then
					return true
				end
			end
			return false
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = icons.diagnostics.Error, warn = icons.diagnostics.Warning },
			colored = true,
			update_in_insert = true,
			always_visible = true,
		}

		local diff = {
			"diff",
			colored = false,
			diff_color = {
				-- Same color values as the general color option can be used here.
				adadded = "DiffAdd", -- Changes the diff's added color
				modified = "DiffChange", -- Changes the diff's modified color
				removed = "DiffDelete", -- Changes the diff's removed color you
			},
			symbols = {
				added = icons.git.Add,
				modified = icons.git.Mod,
				removed = icons.git.Remove,
			}, -- Changes the symbols used by the diff.
			source = function()
				local gitsigns = vim.b.gitsigns_status_dict
				if gitsigns then
					return {
						added = gitsigns.added,
						modified = gitsigns.changed,
						removed = gitsigns.removed,
					}
				end
			end,
			cond = hide_in_width,
		}

		local mode = {
			"mode",
			fmt = function(str)
				if not string.find(str, "-") then
					return "⌞" .. str:sub(1, 1) .. "⌝"
				end

				for s1, s2 in string.gmatch(str, "(%w+)-(%w+)") do
					return "⌞" .. s1:sub(1, 1) .. "-" .. s2:sub(1, 1) .. "⌝"
				end
			end,
		}

		local filetype = {
			"filetype",
			colored = true, -- Displays filetype icon in color if set to true
			icon_only = false, -- Display only an icon for filetype
			icon = { align = "left" }, -- Display filetype icon on the right hand side
			-- icon =    {'X', align='right'}
			-- Icon string ^ in table is ignored in filetype component
		}

		local filename = {
			"filename",
			file_status = true, -- Displays file status (readonly status, modified status)
			path = 2, -- 0: Just the filename, 1: Relative path, 2: Absolute path, 3: Absolute path, with tilde as the home directory
			shorting_target = 40, -- Shortens path to leave 40 spaces in the window, for other components. (terrible name, any suggestions?)
			symbols = {
				modified = "[+]", -- Text to show when the file is modified.
				readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
				unnamed = "[No Name]", -- Text to show for unnamed buffers.
			},
		}

		local branch = {
			"branch",
			icons_enabled = true,
			icon = "",
		}

		local language_server = {
			function()
				local buf_ft = vim.bo.filetype
				local ui_filetypes = {
					"help",
					"packer",
					"neogitstatus",
					"NvimTree",
					"Trouble",
					"lir",
					"Outline",
					"neo-tree",
					"spectre_panel",
					"toggleterm",
					"DressingSelect",
					"TelescopePrompt",
					"lspinfo",
					"lsp-installer",
					"",
				}

				if contains(ui_filetypes, buf_ft) then
					if M.language_servers == nil then
						return ""
					else
						return M.language_servers
					end
				end

				local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
				local client_names = {}
				-- local copilot_active = false

				-- add client
				for _, client in pairs(clients) do
					-- if client.name ~= "copilot" and client.name ~= "null-ls" then
					if client.name ~= "null-ls" then
						table.insert(client_names, client.name)
					end

					-- if client.name == "copilot" then
					-- 	copilot_active = true
					-- end
				end

				-- add formatter
				local s = require("null-ls.sources")
				local available_sources = s.get_available(buf_ft)
				local registered = {}

				for _, source in ipairs(available_sources) do
					for method in pairs(source.methods) do
						registered[method] = registered[method] or {}
						table.insert(registered[method], source.name)
					end
				end

				local formatter = registered["NULL_LS_FORMATTING"]
				local linter = registered["NULL_LS_DIAGNOSTICS"]

				if formatter ~= nil then
					vim.list_extend(client_names, formatter)
				end

				if linter ~= nil then
					vim.list_extend(client_names, linter)
				end

				-- join client names with commas
				local client_names_str = table.concat(client_names, ", ")

				-- check client_names_str if empty
				local language_servers = ""
				local client_names_str_len = #client_names_str

				if client_names_str_len ~= 0 then
					language_servers = "  ⎢" .. client_names_str .. "⎢ "
				end

				-- if copilot_active then
				-- 	language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
				-- end

				-- if client_names_str_len == 0 and not copilot_active then
				if client_names_str_len == 0 then
					return ""
				else
					M.language_servers = language_servers
					return language_servers:gsub(", anonymous source", "")
				end
			end,
			padding = 0,
			cond = hide_in_width,
			-- separator = "%#SLSeparator#" .. " │" .. "%*",
		}

		local location = {
			"location",
			padding = 0,
			fmt = function(str)
				local currentLine = vim.fn.line(".")
				local space = ""

				if currentLine >= 100 or currentLine >= 1000 then
					space = " "
				end

				return " " .. space .. str .. " "
			end,
		}

		-- cool function for progress
		local progress = function()
			local current_line = vim.fn.line(".")
			local total_lines = vim.fn.line("$")
			local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
			local line_ratio = current_line / total_lines
			local index = math.ceil(line_ratio * #chars)
			return chars[index]
		end

		local spaces = function()
			return "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
		end

		local colors = {
			yellow = "#D79921",
			cyan = "#689D6A",
			darkblue = "#3C3836",
			green = "#98971A",
			orange = "#D65D0E",
			violet = "#a9a1e1",
			magenta = "#B16286",
			blue = "#3C8588",
			red = "#CC241D",
		}

		local lsp_progress = {
			"lsp_progress",
			colors = {
				percentage = colors.cyan,
				title = colors.cyan,
				message = colors.cyan,
				spinner = colors.cyan,
				lsp_client_name = colors.magenta,
				use = true,
			},
			separators = {
				component = " ",
				progress = " | ",
				message = { pre = "(", post = ")" },
				percentage = { pre = "", post = "%% " },
				title = { pre = "", post = ": " },
				lsp_client_name = { pre = "[", post = "]" },
				spinner = { pre = "", post = "" },
			},
			-- never show status for this list of servers;
			-- can be useful if your LSP server does not emit
			-- status messages
			hide = { "null-ls", "pyright" },
			-- by default this is false. If set to true will
			-- only show the status of LSP servers attached
			-- to the currently active buffer
			only_show_attached = true,
			display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
			timer = {
				progress_enddelay = 500,
				spinner = 1000,
				lsp_client_name_enddelay = 1000,
				attached_delay = 3000,
			},
			-- spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
			spinner_symbols = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
			message = { initializing = "Initializing…", commenced = "In Progress", completed = "Completed" },
			max_message_length = 30,
		}

		local lazy_status = {
			require("lazy.status").updates,
			cond = require("lazy.status").has_updates,
			color = { fg = "#ff9e64" },
		}

		lualine.setup({
			options = {
				icons_enabled = true,
				-- theme = require("settings.lualineTheme").theme(),
				theme = "auto",
				-- component_separators = { left = "", right = "" },
				component_separators = {
					left = "",
					right = "",
				},
				section_separators = {
					left = icons.ui.TriangleRight,
					right = icons.ui.TriangleLeft,
				},
				disabled_filetypes = { "alpha", "dashboard", "Outline", "neo-tree", "saga" },
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { branch, diff },
				lualine_c = { diagnostics }, -- lsp_progress
				-- lualine_x = { "encoding", "fileformat", "filetype" },
				-- lualine_x = { diagnostics, language_server, spaces, "encoding", filetype },
				lualine_x = { lazy_status, language_server, spaces, "encoding", filetype },
				lualine_y = { location },
				lualine_z = { progress },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = { filename, location },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = {},
		})
	end,
}
