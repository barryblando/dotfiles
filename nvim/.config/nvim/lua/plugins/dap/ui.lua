local icons = require("core.icons")

return {
	opts = {
		icons = {
			collapsed = icons.arrows.right,
			current_frame = icons.arrows.right,
			expanded = icons.arrows.down,
		},
		floating = { border = icons.ui.Border_Single_Line },
		-- layouts = {
		-- {
		-- 	elements = {
		-- 		{ id = "stacks", size = 0.30 },
		-- 		{ id = "breakpoints", size = 0.20 },
		-- 		{ id = "scopes", size = 0.50 },
		-- 	},
		-- 	position = "left",
		-- 	size = 40,
		-- },
		-- INFO: Alternative layout
		-- {
		-- 	elements = {
		-- 		{ id = "stacks", size = 0.40 },
		-- 		{ id = "breakpoints", size = 0.20 },
		-- 		{ id = "scopes", size = 0.40 },
		-- 		{ id = "watches", size = 0.20 },
		-- 	},
		-- 	position = "left",
		-- 	size = 50,
		-- },
		-- {
		-- 	elements = {
		-- 		{ id = "console", size = 0.20 },
		-- 		{ id = "repl", size = 0.50 },
		-- 	},
		-- 	position = "bottom",
		-- 	size = 10,
		-- },
		-- },
	},
}
