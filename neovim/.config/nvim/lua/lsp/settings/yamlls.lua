return {
	settings = {
		yaml = {
			-- other settings. note this overrides the lspconfig defaults.
			schemas = {
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.25.4-standalone-strict/all.json"] = {
					"/infra/k8s/*.yml",
					"/*.k8s.yml",
				},
				["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/main/docs-v2/content/en/schemas/v4beta1.json"] = "skaffold.yml",
				-- other schemas
			},
		},
	},
}

  -- settings = {
  --   yaml = {
  --     trace = {
  --       server = "verbose"
  --     },
  --     schemas = {
  --       ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
  --       ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
  --       ["https://json.schemastore.org/chart.json"] = "Chart.yaml",
  --       ["https://json.schemastore.org/taskfile.json"] = "Taskfile*.yml",
  --       ["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/master/docs/content/en/schemas/v2beta26.json"] = "skaffold.yaml",
  --       ["https://raw.githubusercontent.com/rancher/k3d/main/pkg/config/v1alpha3/schema.json"] = "k3d.yaml",
  --       ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.20.13/all.json"] = "/*.yaml",
  --     }
  --   }
