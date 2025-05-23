local util = require("lspconfig").util

return {
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
				runBuildScripts = true,
			},
			-- Add clippy lints for Rust.
			checkOnSave = true,
			procMacro = {
				enable = true,
				ignored = {
					["async-trait"] = { "async_trait" },
					["napi-derive"] = { "napi" },
					["async-recursion"] = { "async_recursion" },
				},
			},
			diagnostics = {
				enable = true,
				experimental = {
					enable = true,
				},
			},
			inlayHints = {
				lifetimeElisionHints = {
					enable = true,
					useParameterNames = true,
				},
				bindingModeHints = {
					enable = true,
				},
				parameterHints = {
					enable = true,
				},
				typeHints = {
					enable = true,
				},
				chainingHints = {
					enable = true,
				},
				closingBraceHints = {
					enable = true,
				},
			},
		},
	},
}
