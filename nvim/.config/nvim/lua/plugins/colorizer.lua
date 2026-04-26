local M = {}

M.config = function()
	require("colorizer").setup({
		options = {
			parsers = {
				hex = {
					rgb = false, -- #RGB
					rgba = false, -- #RGBA
					rrggbb = true, -- #RRGGBB
					rrggbbaa = true, -- #RRGGBBAA
					aarrggbb = true, -- 0xAARRGGBB
				},
			},
		},
	})
end

return M
