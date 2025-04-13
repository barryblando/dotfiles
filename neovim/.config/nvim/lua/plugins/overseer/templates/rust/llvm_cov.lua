return {
	name = "Generate LLVM_COV report",
	desc = "Generate coverage report using llvm-cov",
	builder = function()
		return {
			cmd = "cargo",
			args = {
				"llvm-cov",
				"--lcov",
				"--output-path",
				"lcov.info",
				"--workspace",
			},
			name = "LLVM Coverage Report",
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
			-- Only enable this task in Rust projects
			-- return vim.fn.filereadable("Cargo.toml") == 1
			return true
		end,
	},
	metadata = {
		languages = { "rust" },
	},
}
