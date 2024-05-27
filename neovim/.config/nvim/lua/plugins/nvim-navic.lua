return {
	-- lsp symbol navigation for lualine. This shows where
	-- in the code structure you are - within functions, classes,
	-- etc - in the statusline.
	"SmiteshP/nvim-navic",
	enabled = false, -- NOTE: remove for dropbar alternative but after neovim 0.10 releases
	lazy = true,
	config = function()
		local status_ok, navic = pcall(require, "nvim-navic")
		if not status_ok then
			return
		end

		local icons = require("utils.icons")

		-- vim.api.nvim_set_hl(0, "WinBarSeparator", { fg = "#111fff" })
		-- vim.api.nvim_set_hl(0, "NavicSeparator", {default = true, bg = "#000000", fg = "#ffffff"})
		-- local fg = vim.api.nvim_get_hl_by_name('DiffAdd', 0).background
		-- local bg = vim.api.nvim_get_hl_by_name('DiffAdd', 0).foreground

		local space = ""

		if vim.fn.has("mac") == 1 then
			space = " "
		end

		-- Customized config
		navic.setup({
			icons = {
				["File"] = "%#CmpItemKindFile#" .. icons.kind.File .. "%*" .. space,
				["Module"] = "%#CmpItemKindModule#" .. icons.kind.Module .. "%*" .. space,
				["Namespace"] = "%#CmpItemKindClass#" .. icons.kind.Class .. "%*" .. space,
				["Package"] = "%#CmpItemKindProperty#" .. icons.ui.Package .. "%*" .. space,
				["Class"] = "%#CmpItemKindKeyword#" .. icons.kind.Class .. "%*" .. " ",
				["Method"] = "%#CmpItemKindMethod#" .. icons.kind.Method .. "%*" .. space,
				["Property"] = "%#CmpItemKindProperty#" .. icons.kind.Property .. "%*" .. space,
				["Field"] = "%#CmpItemKindField#" .. icons.kind.Field .. "%*" .. space,
				["Constructor"] = "%#CmpItemKindConstructor#" .. icons.kind.Constructor .. "%*" .. space,
				["Enum"] = "%#CmpItemKindEnum#" .. icons.kind.Enum .. "%*" .. space,
				["Interface"] = "%#CmpItemKindInterface#" .. icons.kind.Interface .. "%*" .. space,
				["Function"] = "%#CmpItemKindFunction#" .. icons.kind.Function .. "%*" .. space,
				["Variable"] = "%#CmpItemKindVariable#" .. icons.kind.Variable .. "%*" .. space,
				["Constant"] = "%#CmpItemKindConstant#" .. icons.kind.Constant .. "%*" .. space,
				["String"] = "%#CmpItemKindUnit#" .. icons.type.String .. "%*" .. space,
				["Number"] = "%#CmpItemKindUnit#" .. icons.type.Number .. "%*" .. space,
				["Boolean"] = "%#CmpItemKindUnit#" .. icons.type.Boolean .. "%*" .. space,
				["Array"] = "%#CmpItemKindUnit#" .. icons.ui.Calendar .. "%*" .. space,
				["Object"] = "%#CmpItemKindClass#" .. icons.type.Object .. "%*" .. space,
				["Key"] = "%#CmpItemKindKeyword#" .. icons.kind.Keyword .. "%*" .. space,
				["Null"] = "%#CmpItemKindUnit#" .. icons.type.Null .. "%*" .. space,
				["EnumMember"] = "%#CmpItemKindEnumMember#" .. icons.kind.EnumMember .. "%*" .. space,
				["Struct"] = "%#CmpItemKindStruct#" .. icons.kind.Struct .. "%*" .. space,
				["Event"] = "%#CmpItemKindEvent#" .. icons.kind.Event .. "%*" .. space,
				["Operator"] = "%#CmpItemKindOperator#" .. icons.kind.Operator .. "%*" .. space,
				["TypeParameter"] = "%#CmpItemKindTypeParameter#" .. icons.kind.TypeParameter .. "%*" .. space,
			},
			separator = "" .. icons.ui.ChevronRight .. " ",
			depth = 5,
			-- depth_limit_indicator = "..",
			highlight = true,
		})
	end,
}
