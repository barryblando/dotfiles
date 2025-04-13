return {
	name = "Cargo Clippy",
	desc = "Run clippy for linting",
	builder = function()
		return {
			cmd = { "cargo" },
			args = { "clippy" },
			components = {
				"default",
				"on_result_diagnostics",
				"on_result_notify",
			},
		}
	end,
	metadata = {
		languages = { "rust" },
	},
}
