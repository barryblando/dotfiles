return {
	name = "Cargo Build",
	desc = "Build Rust project",
	builder = function()
		return {
			cmd = { "cargo" },
			args = { "build" },
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
