return {
	settings = {
		yaml = {
			-- other settings. note this overrides the lspconfig defaults.
			schemas = {
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.1-standalone-strict/all.json"] = {
					"/infra/k8s/*.yml",
					"/*.k8s.yml",
				},
				["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/master/docs/content/en/schemas/v2beta29.json"] = "skaffold.yml",
				-- other schemas
			},
		},
	},
}
