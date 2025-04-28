local M = {}

M.config = function()
	local is_enabled = function()
		local disabled_ft = {
			"TelescopePrompt",
			"grug-far",
		}
		return not vim.tbl_contains(disabled_ft, vim.bo.filetype)
			and vim.b.completion ~= false
			and vim.bo.buftype ~= "prompt"
	end

	local function blink_highlight(ctx)
		local hl = "BlinkCmpKind" .. ctx.kind or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
		if vim.tbl_contains({ "Path" }, ctx.source_name) then
			local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
			if dev_icon then
				hl = dev_hl
			end
		end
		return hl
	end

	local icons = require("core.icons")

	require("blink.cmp").setup({
		enabled = is_enabled,
		keymap = {
			-- set to 'none' to disable the 'default' preset
			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<Tab>"] = {
				function(cmp)
					return cmp.select_next()
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = {
				function(cmp)
					return cmp.select_prev()
				end,
				"snippet_backward",
				"fallback",
			},
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-up>"] = { "scroll_documentation_up", "fallback" },
			["<C-down>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = { nerd_font_variant = "mono" },
		signature = {
			enabled = true,
			window = { show_documentation = false, border = icons.ui.Border_Single_Line },
		},
		-- cmdline = { completion = { menu = { auto_show = false } } },

		cmdline = {
			enabled = true,
			sources = function()
				local type = vim.fn.getcmdtype()

				if type == "/" or type == "?" then
					return { "buffer" }
				end
				if type == ":" or type == "@" then
					return { "cmdline", "path", "buffer" }
				end
				return {}
			end,
			completion = {
				menu = { auto_show = true },
			},
		},

		completion = {
			trigger = { show_on_keyword = true },
			-- MENU
			menu = {
				scrollbar = false,
				auto_show = is_enabled,
				border = {
					{ "󱐋", "WarningMsg" },
					"─",
					"┐",
					"│",
					"┘",
					"─",
					"└",
					"│",
				},
				winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
				cmdline_position = function()
					if vim.g.ui_cmdline_pos ~= nil then
						local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
						return { pos[1] - 1, pos[2] }
					end
					local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
					return { vim.o.lines - height, 0 }
				end,
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						-- { "kind" }, -- <- Useful for debugging highlights/completion types.
						-- { "source_name" }, -- <- Useful for debugging sources.
					},
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local lspkind = require("lspkind")
								local icon = ctx.kind_icon

								if vim.tbl_contains({ "path", "copilot" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									if vim.tbl_contains({ "spell", "cmdline", "markdown" }, ctx.source_name) then
										icon = lspkind.symbolic(ctx.source_name, { mode = "symbol" })
									else
										icon = lspkind.symbolic(ctx.kind, {
											mode = "symbol",
										})
									end
								end

								return icon .. " "
							end,
							highlight = function(ctx)
								return blink_highlight(ctx)
							end,
						},
						kind = {
							highlight = function(ctx)
								return blink_highlight(ctx)
							end,
						},
					},
				},
			},
			-- DOCUMENTATION
			documentation = {
				auto_show = true,
				window = {
					border = {
						{ "", "DiagnosticHint" },
						"─",
						"┐",
						"│",
						"┘",
						"─",
						"└",
						"│",
					},
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
				},
			},
		},

		snippets = { preset = "luasnip" },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer", "env", "cmp_yanky" },
			providers = {
				cmdline = {
					-- ignores cmdline completions when executing shell commands
					enabled = function()
						return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
					end,
				},
				path = {
					name = "Path",
					module = "blink.cmp.sources.path",
					score_offset = 25,
					-- When typing a path, I would get snippets and text in the
					-- suggestions, I want those to show only if there are no path
					-- suggestionsa
					fallbacks = { "snippets", "buffer" },
					-- min_keyword_length = 2,
					opts = {
						trailing_slash = false,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = true,
					},
				},
				buffer = {
					opts = {
						-- get all buffers, even ones like neo-tree
						-- get_bufnrs = vim.api.nvim_list_bufs,
						-- or (recommended) filter to only "normal" buffers
						get_bufnrs = function()
							return vim.tbl_filter(function(bufnr)
								return vim.bo[bufnr].buftype == ""
							end, vim.api.nvim_list_bufs())
						end,
					},
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				env = {
					name = "Env",
					module = "blink-cmp-env",
					opts = {
						item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
						show_braces = false,
						show_documentation_window = true,
					},
				},
				cmp_yanky = {
					name = "cmp_yanky",
					module = "blink.compat.source",
					score_offset = -3,

					-- this table is passed directly to the proxied completion source
					-- as the `option` field in nvim-cmp's source config
					--
					-- this is NOT the same as the opts in a plugin's lazy.nvim spec
					opts = {
						-- this is an option from cmp_yanky
						-- only suggest items which match the current filetype
						onlyCurrentFiletype = false,

						-- If you'd like to use a `name` that does not exactly match nvim-cmp,
						-- set `cmp_name` to the name you would use for nvim-cmp, for instance:
						-- cmp_name = "digraphs"
						-- then, you can set the source's `name` to whatever you like.
					},
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	})
end

return M
