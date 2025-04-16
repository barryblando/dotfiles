return {
	name = "Cargo Test",
	desc = "Using cargo-nextest",
	builder = function()
		return {
			cmd = { "cargo" },
			args = { "nextest", "run", "--no-fail-fast" },
			components = {
				"default",
				{ "on_output_quickfix", open = true },
				"on_result_diagnostics",
				"unique",
				"on_complete_notify",
			},
		}
	end,
	metadata = {
		languages = { "rust" },
	},
}
