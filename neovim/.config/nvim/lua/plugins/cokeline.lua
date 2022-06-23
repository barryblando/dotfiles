local status_ok, cokeline = pcall(require, "cokeline")

if not status_ok then
	return
end

local icons = require("utils.icons")

local get_hex = require("cokeline/utils").get_hex
local mappings = require("cokeline/mappings")

local comments_fg = get_hex("Comment", "fg")
local errors_fg = get_hex("DiagnosticSignError", "fg")
local warnings_fg = get_hex("DiagnosticSignWarn", "fg")

local red = vim.g.terminal_color_1
local yellow = vim.g.terminal_color_3

local components = {
	space = {
		text = " ",
		truncation = { priority = 1 },
	},

	two_spaces = {
		text = "  ",
		truncation = { priority = 1 },
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
			return buffer.index .. ": "
		end,
		truncation = { priority = 1 },
	},

	unique_prefix = {
		text = function(buffer)
			return buffer.unique_prefix
		end,
		fg = comments_fg,
		style = "italic",
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
			return ((buffer.is_focused and buffer.diagnostics.errors ~= 0) and "bold,italic")
				or (buffer.is_focused and "bold,italic")
				or (buffer.diagnostics.errors ~= 0 and "bold")
				or nil
		end,
		truncation = {
			priority = 2,
			direction = "left",
		},
	},

	diagnostics = {
		text = function(buffer)
			return (buffer.diagnostics.errors ~= 0 and " " .. icons.diagnostics.Error .. buffer.diagnostics.errors)
				or (buffer.diagnostics.warnings ~= 0 and " " .. icons.diagnostics.Warning .. buffer.diagnostics.warnings)
				or ""
		end,
		fg = function(buffer)
			return (buffer.diagnostics.errors ~= 0 and errors_fg)
				or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
				or nil
		end,
		truncation = { priority = 1 },
	},

	close_or_unsaved = {
		text = function(buffer)
			return buffer.is_modified and "●" or "×"
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
				return " 🔒"
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
			return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Comment", "fg")
		end,
		-- bg = "none",
		bg = get_hex("None", "bg"),
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
		components.devicon,
		components.space,
		components.unique_prefix,
		components.filename,
		components.diagnostics,
		components.two_spaces,
		components.close_or_unsaved,
		components.is_readonly,
		components.space,
		-- space,
		-- {
		-- 	text = function(buffer)
		-- 		return buffer.devicon.icon
		-- 	end,
		-- 	fg = function(buffer)
		-- 		return buffer.devicon.color
		-- 	end,
		-- },
		-- {
		-- 	text = function(buffer)
		-- 		return buffer.filename
		-- 	end,
		-- 	fg = function(buffer)
		-- 		if buffer.is_focused then
		-- 			return "#78dce8"
		-- 		end
		-- 		if buffer.is_modified then
		-- 			return "#e5c463"
		-- 		end
		-- 		if buffer.diagnostics.errors ~= 0 then
		-- 			return "#fc5d7c"
		-- 		end
		-- 	end,
		-- 	style = function(buffer)
		-- 		return buffer.is_focused and "italic,bold" or nil
		-- 	end,
		-- },
		-- {
		-- 	text = function(buffer)
		-- 		if buffer.is_readonly then
		-- 			return " 🔒"
		-- 		end
		-- 		return ""
		-- 	end,
		-- },
		-- space,
	},
})
