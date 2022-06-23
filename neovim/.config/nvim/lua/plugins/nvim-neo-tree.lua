local ok_status, neotree = pcall(require, "neo-tree")

if not ok_status then
	return
end

local function openWithFocus(state)
	local node = state.tree:get_node()
	if require("neo-tree.utils").is_expandable(node) then
		state.commands["toggle_node"](state)
	else
		state.commands["open"](state)
		vim.cmd("Neotree reveal")
	end
end

neotree.setup({
	close_if_last_window = false,
	use_popups_for_input = false,
	close_floats_on_escape_key = false,
	-- popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	default_component_configs = {
		container = {
			enable_character_fade = true,
		},
		indent_size = 1,
		name = {
			trailing_slash = true,
		},
	},
	window = {
		position = "float",
		width = "30%",
		popup = {
			position = { col = "100%", row = "2" },
			size = function(state)
				local root_name = vim.fn.fnamemodify(state.path, ":~")
				local root_len = string.len(root_name) + 4
				return {
					width = math.max(root_len, 50),
					height = vim.o.lines - 6,
				}
			end,
		},
		mappings = {
			["<2-leftmouse>"] = openWithFocus,
			["<cr>"] = openWithFocus,
			-- relative path in add prompt
			a = {
				"add",
				config = { show_path = "relative" },
			},
			A = {
				-- "add_directory",
				-- config = { show_path = "relative" },
				"add",
				config = { show_path = "absolute" },
			},
		},
	},
	filesystem = {
		group_empty_dirs = true,
		bind_to_cwd = false,
		hijack_netrw_behavior = "open_default",
		use_libuv_file_watcher = true,
		filtered_items = {
			hide_dotfiles = false,
			never_show = { ".git" },
		},
	},
	buffers = {
		follow_current_file = true, -- This will find and focus the file in the active buffer every
		-- time the current file is changed while the tree is open.
		group_empty_dirs = true, -- when true, empty folders will be grouped together
		show_unloaded = true,
		window = {
			mappings = {
				["bd"] = "buffer_delete",
				["<bs>"] = "navigate_up",
				["."] = "set_root",
			},
		},
	},
	event_handlers = {
		{
			-- auto close
			event = "file_opened",
			handler = function(file_path)
				require("neo-tree").close_all()
			end,
		},
		{
			-- show netrw hijacked buffer in buffer list
			event = "neo_tree_buffer_enter",
			handler = function()
				vim.schedule(function()
					local position = vim.api.nvim_buf_get_var(0, "neo_tree_position")
					if position == "current" then
						vim.bo.buflisted = true
					end
				end)
			end,
		},
		{
			event = "file_open_requested",
			handler = function(args)
				local state = args.state
				local path = args.path
				local open_cmd = args.open_cmd or "edit"

				-- use last window if possible
				local suitable_window_found = false
				local nt = require("neo-tree")
				if nt.config.open_files_in_last_window then
					local prior_window = nt.get_prior_window()
					if prior_window > 0 then
						local success = pcall(vim.api.nvim_set_current_win, prior_window)
						if success then
							suitable_window_found = true
						end
					end
				end

				-- find a suitable window to open the file in
				if not suitable_window_found then
					if state.window.position == "right" then
						vim.cmd("wincmd t")
					else
						vim.cmd("wincmd w")
					end
				end
				local attempts = 0
				while attempts < 4 and vim.bo.filetype == "neo-tree" do
					attempts = attempts + 1
					vim.cmd("wincmd w")
				end
				if vim.bo.filetype == "neo-tree" then
					-- Neo-tree must be the only window, restore it's status as a sidebar
					local winid = vim.api.nvim_get_current_win()
					local width = require("neo-tree.utils").get_value(state, "window.width", 40, false)
					vim.cmd("vsplit " .. path)
					vim.api.nvim_win_set_width(winid, width)
				else
					vim.cmd(open_cmd .. " " .. path)
				end

				-- If you don't return this, it will proceed to open the file using built-in logic.
				return { handled = true }
			end,
		},
	},
})
