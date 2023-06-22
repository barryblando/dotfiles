return {
	settings = {
		yaml = {
			-- other settings. note this overrides the lspconfig defaults.
			-- Alternative: https://github.com/someone-stole-my-name/yaml-companion.nvim
			schemas = {
				-- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.3-standalone-strict/all.json"] = {
				-- 	"/infra/k8s/*.yml",
				-- 	"/*.k8s.yml",
				-- },
				kubernetes = "*.yaml",
				["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/main/docs-v2/content/en/schemas/v4beta6.json"] = "skaffold.yml",
				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
				["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
				["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
				["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
				["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
				["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
				["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
				["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
				["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
				["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
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
