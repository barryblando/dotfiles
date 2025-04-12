local icons = require("core.icons")

return {
	opts = {
		icons = {
			collapsed = icons.arrows.right,
			current_frame = icons.arrows.right,
			expanded = icons.arrows.down,
		},
		floating = { border = icons.ui.Border_Single_Line },
		layouts = {
			{
				elements = {
					{ id = "stacks", size = 0.30 },
					{ id = "breakpoints", size = 0.20 },
					{ id = "scopes", size = 0.50 },
				},
				position = "left",
				size = 40,
			},
		},
	},
}
