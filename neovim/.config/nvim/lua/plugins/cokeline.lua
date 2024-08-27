return {
	"willothy/nvim-cokeline",
	config = function()
		local status_ok, cokeline = pcall(require, "cokeline")

		if not status_ok then
			return
		end

		local icons = require("utils.icons")
		local ns = vim.api.nvim_create_namespace("cokeline_diagnostics")

		local get_hl_attr = require("cokeline.hlgroups").get_hl_attr
		local mappings = require("cokeline/mappings")

		local normal_fg = get_hl_attr("Normal", "fg")
		local comment_fg = get_hl_attr("Comment", "fg")
		local error_fg = get_hl_attr("DiagnosticSignError", "fg")
		local warning_fg = get_hl_attr("DiagnosticSignWarn", "fg")

		local red = vim.g.terminal_color_1
		local yellow = vim.g.terminal_color_3

		local diagnostic_fg = function(buffer)
			return (buffer.diagnostics.errors ~= 0 and "#f2594b")
				or (buffer.diagnostics.warnings ~= 0 and "#e9b143")
				or nil
		end

		local components = {
			space = {
				text = " ",
				truncation = { priority = 1 },
			},

			two_spaces = {
				text = "  ",
				truncation = { priority = 1 },
			},

			left_bracket = {
				text = "⌞",
				truncation = { priority = 1 },
				fg = diagnostic_fg,
			},

			right_bracket = {
				text = "⌝",
				truncation = { priority = 1 },
				fg = diagnostic_fg,
			},

			separator = {
				text = function(buffer)
					return buffer.index ~= 1 and "▏" or ""
				end,
				truncation = { priority = 1 },
			},

			devicon = {
				text = function(buffer)
					return (mappings.is_picking_focus() or mappings.is_picking_close()) and buffer.pick_letter .. " "
						or buffer.devicon.icon
				end,
				fg = function(buffer)
					return (mappings.is_picking_focus() and yellow)
						or (mappings.is_picking_close() and red)
						or buffer.devicon.color
				end,
				style = function(_)
					return (mappings.is_picking_focus() or mappings.is_picking_close()) and "italic,bold" or nil
				end,
				truncation = { priority = 1 },
			},

			index = {
				text = function(buffer)
					return buffer.index .. ":"
				end,
				truncation = { priority = 1 },
			},

			unique_prefix = {
				text = function(buffer)
					return buffer.unique_prefix
				end,
				fg = comment_fg,
				-- style = "italic",
				style = function(buffer)
					return ((buffer.is_focused and buffer.diagnostics.errors ~= 0) and "undercurl") -- "bold,italic"
						or (buffer.is_focused and "NONE") -- "bold,italic"
						or (buffer.diagnostics.errors ~= 0 and "undercurl")
						or nil
				end,
				truncation = {
					priority = 3,
					direction = "left",
				},
			},

			filename = {
				text = function(buffer)
					return buffer.filename
				end,
				style = function(buffer)
					return ((buffer.is_focused and buffer.diagnostics.errors ~= 0) and "bold,undercurl") -- "bold,italic"
						or (buffer.is_focused and "NONE") -- "bold,italic"
						or (buffer.diagnostics.errors ~= 0 and "undercurl")
						or nil
				end,
				fg = diagnostic_fg,
				truncation = {
					priority = 2,
					direction = "left",
				},
			},

			diagnostics = {
				text = function(buffer)
					return (
						buffer.diagnostics.errors ~= 0
						and "⌜" .. icons.diagnostics.Error .. buffer.diagnostics.errors .. "⌟"
					)
						or (buffer.diagnostics.warnings ~= 0 and "⌜" .. icons.diagnostics.Warning .. buffer.diagnostics.warnings .. "⌟")
						or ""
				end,
				fg = diagnostic_fg,
				truncation = { priority = 1 },
			},

			close_or_unsaved = {
				text = function(buffer)
					return (
						(buffer.is_modified and (buffer.diagnostics.errors ~= 0 or buffer.diagnostics.warnings ~= 0))
						and "⌞●⌝"
					)
						or buffer.is_modified and "⌜●⌟"
						or "" -- "×"
				end,
				fg = function(buffer)
					return buffer.is_modified and "#e5c463" or nil
				end,
				delete_buffer_on_left_click = true,
				truncation = { priority = 1 },
			},

			is_readonly = {
				text = function(buffer)
					if buffer.is_readonly then
						return ""
					end
					return ""
				end,
			},
		}

		cokeline.setup({
			show_if_buffers_are_at_least = 2,
			mappings = {
				cycle_prev_next = true,
			},
			default_hl = {
				fg = function(buffer)
					-- return buffer.is_focused and get_hl_attr("Normal", "fg") or get_hl_attr("Comment", "fg")
					return buffer.is_focused and "#ebdbb2" or "#928374"
				end,
				bg = "None",
				-- bg = get_hl_attr("None", "bg"),
			},
			buffers = {
				-- filter_valid = function(buffer) return buffer.type ~= 'terminal' end,
				-- filter_visible = function(buffer) return buffer.type ~= 'terminal' end,
				new_buffers_position = "next",
			},
			rendering = {
				max_buffer_width = 30,
			},
			components = {
				components.space,
				-- components.devicon,
				-- components.space,
				-- components.index,
				components.left_bracket,
				components.unique_prefix,
				components.filename,
				components.right_bracket,
				components.diagnostics,
				-- components.space,
				-- components.is_readonly,
				-- components.space,
				components.close_or_unsaved,
				components.is_readonly,
				-- components.space,
			},
		})
	end,
}
