return {
	settings = {
		gopls = {
			-- main readme: https://github.com/golang/tools/blob/master/gopls/doc/features/README.md
			--
			-- for all options, see:
			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
			-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
			-- for more details, also see:
			-- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
			-- https://github.com/golang/tools/blob/master/gopls/README.md
			analyses = {
				fieldalignment = false, -- annoying
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			completeUnimported = true,
			directoryFilters = { "-**/node_modules", "-**/.git", "-.vscode", "-.idea", "-.vscode-test" },
			gofumpt = true,
			semanticTokens = true,
			staticcheck = true,
			usePlaceholders = true,
		},
	},
}
