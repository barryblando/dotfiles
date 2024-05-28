return {
	"Bekaboo/dropbar.nvim",
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	-- event = "VeryLazy",
	keys = {
		{
			"<leader>w",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Winbar pick",
		},
	},
	init = function()
		vim.ui.select = require("dropbar.utils.menu").select
	end,
	opts = function()
		local menu_utils = require("dropbar.utils.menu")
		local icons = require("utils.icons")

		-- Closes all the windows in the current dropbar.
		local function close()
			local menu = menu_utils.get_current()
			while menu and menu.prev_menu do
				menu = menu.prev_menu
			end
			if menu then
				menu:close()
			end
		end

		return {
			general = {
				-- Remove the 'OptionSet' event since it causes weird issues with modelines.
				attach_events = { "BufWinEnter", "BufWritePost" },
				update_events = {
					-- Remove the 'WinEnter' event since I handle it manually for just
					-- showing the full dropbar in the current window.
					win = { "CursorMoved", "CursorMovedI", "WinResized" },
				},
			},
			icons = {
				ui = {
					-- Tweak the spacing around the separator.
					-- bar = { separator = "  " }, -- use this when in x,y,z position in lualine
					bar = { separator = " ❯ " },
					menu = { separator = "" },
				},
				-- Keep the LSP icons used in other parts of the UI.
				-- kinds = {
				-- 	symbols = vim.tbl_map(function(symbol)
				-- 		return symbol .. " "
				-- 	end, icons.kind),
				-- },
				kinds = {
					use_devicons = true,
				},
			},
			bar = {
				pick = {
					-- Use the same labels as flash.
					pivots = "asdfghjklqwertyuiopzxcvbnm",
				},
				sources = function()
					local sources = require("dropbar.sources")
					local utils = require("dropbar.utils.source")
					--[[ local filename = {
            get_symbols = function(buff, win, cursor)
              local symbols = sources.path.get_symbols(buff, win, cursor)
              return { symbols[#symbols] }
            end,
          } ]]

					return {
						-- filename,
						{
							get_symbols = function(buf, win, cursor)
								if vim.api.nvim_get_current_win() ~= win then
									return {}
								end

								if vim.bo[buf].ft == "markdown" then
									return sources.markdown.get_symbols(buf, win, cursor)
								end
								return utils.fallback({ sources.lsp, sources.treesitter }).get_symbols(buf, win, cursor)
							end,
						},
					}
				end,
			},
			menu = {
				win_configs = { border = icons.ui.Border_Single_Line },
				keymaps = {
					-- Navigate back to the parent menu.
					["h"] = "<C-w>c",
					-- Expands the entry if possible.
					["l"] = function()
						local menu = menu_utils.get_current()
						if not menu then
							return
						end
						local row = vim.api.nvim_win_get_cursor(menu.win)[1]
						local component = menu.entries[row]:first_clickable()
						if component then
							menu:click_on(component, nil, 1, "l")
						end
					end,
					-- "Jump and close".
					["o"] = function()
						local menu = menu_utils.get_current()
						if not menu then
							return
						end
						local cursor = vim.api.nvim_win_get_cursor(menu.win)
						local entry = menu.entries[cursor[1]]
						local component = entry:first_clickable(entry.padding.left + entry.components[1]:bytewidth())
						if component then
							menu:click_on(component, nil, 1, "l")
						end
					end,
					-- Close the dropbar entirely with <esc> and q.
					["q"] = close,
					["<esc>"] = close,
				},
			},
		}
	end,
	config = function(_, opts)
		local bar_utils = require("dropbar.utils.bar")

		require("dropbar").setup(opts)

		-- Better way to do this? Follow up in https://github.com/Bekaboo/dropbar.nvim/issues/76
		vim.api.nvim_create_autocmd("WinEnter", {
			desc = "Refresh window dropbars",
			callback = function()
				-- Refresh the dropbars except when entering the dropbar itself.
				if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].winbar == 1 then
					bar_utils.exec("update")
				end
			end,
		})
	end,
}
