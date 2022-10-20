local util = require("lspconfig").util

return {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
	-- tsserver will only resolve projects with package.json
	root_dir = util.root_pattern("package.json"),
	-- settings = {
	-- 	typescript = {
	-- 		inlayHints = {
	-- 			includeInlayEnumMemberValueHints = true,
	-- 			includeInlayFunctionLikeReturnTypeHints = true,
	-- 			includeInlayFunctionParameterTypeHints = true,
	-- 			includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
	-- 			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
	-- 			includeInlayPropertyDeclarationTypeHints = true,
	-- 			includeInlayVariableTypeHints = true,
	-- 		},
	-- 	},
	-- },
}
