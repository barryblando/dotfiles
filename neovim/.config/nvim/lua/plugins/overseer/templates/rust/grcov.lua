return {
	name = "Generate GRCOV report",
	desc = "Generate coverage report using grcov",
	builder = function()
		return {
			cmd = "grcov",
			args = {
				".",
				"--binary-path",
				"./target/debug/",
				"-s",
				".",
				"-t",
				"lcov",
				"--branch",
				"--ignore-not-existing",
				"-o",
				"lcov.info",
			},
			env = {
				CARGO_INCREMENTAL = "0",
				RUSTFLAGS = "-C instrument-coverage",
				LLVM_PROFILE_FILE = "coverage-%p-%m.profraw",
			},
			name = "grcov coverage",
			components = {
				"default",
				"on_output_quickfix",
				"on_result_diagnostics",
				"unique",
			},
		}
	end,
	condition = {
		callback = function()
			-- Only enable in Rust projects, optional
			return vim.fn.filereadable("Cargo.toml") == 1
		end,
	},
	metadata = {
		languages = { "rust" },
	},
}
