local M = {}

M.config = function()
	local builtin = require("statuscol.builtin")
	require("statuscol").setup({
		relculright = true,
		setopt = true,
		segments = {
			-- {
			-- 	sign = { name = { "Diagnostic" }, maxwidth = 1, auto = false },
			-- 	click = "v:lua.ScSa",
			-- },
			-- {
			-- 	sign = {
			-- 		name = {
			-- 			"Dap",
			-- 			"neotest", --[[ "Diagnostic" ]]
			-- 		},
			-- 		maxwidth = 1,
			-- 		colwidth = 2,
			-- 		auto = true,
			-- 	},
			-- 	click = "v:lua.ScSa",
			-- },
			{
				text = { builtin.lnumfunc, " " },
				condition = { true, builtin.not_empty },
				click = "v:lua.ScLa",
			},
			{
				sign = {
					name = { ".*" },
					namespace = { "gitsigns" },
					maxwidth = 1,
					colwidth = 1,
					auto = false,
				},
				click = "v:lua.ScSa",
			},
			{
				text = { " ", builtin.foldfunc, " " },
				condition = { builtin.not_empty, true, builtin.not_empty },
				click = "v:lua.ScFa",
			},
		},
		ft_ignore = {
			"help",
			"vim",
			"alpha",
			"dashboard",
			"neo-tree",
			"Trouble",
			"noice",
			"lazy",
			"toggleterm",
		},
	})
end

return M
