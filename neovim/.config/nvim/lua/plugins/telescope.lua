return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-telescope/telescope-media-files.nvim",
		-- "nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	lazy = true,
	keys = require("core.keymaps").setup_telescope_keymaps(),
	config = function()
		local status_ok, telescope = pcall(require, "telescope")
		if not status_ok then
			return
		end

		local actions = require("telescope.actions")
		telescope.load_extension("media_files")
		local icons = require("utils.icons")

		local fb_actions = require("telescope").extensions.file_browser.actions

		telescope.setup({
			defaults = {
				file_ignore_patterns = { ".git", "node_modules", "vendor" },

				prompt_prefix = icons.ui.Telescope .. " ",
				selection_caret = " ",
				path_display = { "smart" },
				borderchars = icons.ui.Border_Chars_Single_Line,

				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,

						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,

						["<C-c>"] = actions.close,

						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,

						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,

						["<c-d>"] = require("telescope.actions").delete_buffer,

						-- ["<C-u>"] = actions.preview_scrolling_up,
						-- ["<C-d>"] = actions.preview_scrolling_down,

						["<PageUp>"] = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,

						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-l>"] = actions.complete_tag,
						["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
					},

					n = {
						["<esc>"] = actions.close,
						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,

						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
						["H"] = actions.move_to_top,
						["M"] = actions.move_to_middle,
						["L"] = actions.move_to_bottom,

						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,
						["gg"] = actions.move_to_top,
						["G"] = actions.move_to_bottom,

						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,

						["<PageUp>"] = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,

						["?"] = actions.which_key,
					},
				},
			},
			pickers = {
				-- Default configuration for builtin pickers goes here:
				-- picker_name = {
				--   picker_config_key = value,
				--   ...
				-- }
				-- Now the picker_config_key will be applied every time you call this
				-- builtin picker
				find_files = {
					find_command = {
						"fd",
						".",
						"--type",
						"file",
						"--hidden",
						"--strip-cwd-prefix",
					},
				},
			},
			extensions = {
				media_files = {
					-- filetypes whitelist
					-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
					filetypes = { "png", "webp", "jpg", "jpeg" },
					find_cmd = "rg", -- find command (defaults to `fd`)
				},
				file_browser = {
					-- set this to true if you don't have any file explorer plugin installed when starting nvim
					hijack_netrw = false,
					mappings = {
						["i"] = {
							["<A-c>"] = fb_actions.create, -- create file/folder at current path
							["<A-r>"] = fb_actions.rename, -- rename
							["<A-d>"] = fb_actions.remove, -- delete
							["<A-y>"] = fb_actions.copy, -- copy
							["<A-m>"] = fb_actions.move, -- move
							["<C-w>"] = fb_actions.goto_cwd, -- go to current working dir
							["<C-g>"] = fb_actions.goto_parent_dir, -- parent dir
						},
						["n"] = {
							-- unmap toggling `fb_actions.toggle_browser`
							f = false, -- false so it won't conflict with which_key
						},
					},
				},
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
				-- ["ui-select"] = {
				--   require("telescope.themes").get_dropdown({
				--     previewer = false,
				--     -- even more opts
				--     borderchars = {
				--       { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
				--       prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
				--       results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
				--       preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
				--     },
				--   }),
				-- },
			},
		})

		-- telescope.load_extension("ui-select")
		telescope.load_extension("file_browser")
		telescope.load_extension("fzf")
		telescope.load_extension("notify")
		telescope.load_extension("harpoon")
	end,
}
