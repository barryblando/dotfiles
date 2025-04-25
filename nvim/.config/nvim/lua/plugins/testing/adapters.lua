return {
	require("neotest-rust")({
		args = { "--no-capture" },
		dap_adapter = "codelldb",
		-- Enable cargo-nextest
		-- cargo_args = { "nextest", "run", "--no-fail-fast" },
		cargo_args = { "--all-features" },
		use_nextest = true,
		env = {
			-- Enable source-based coverage
			CARGO_INCREMENTAL = "0",
			RUSTFLAGS = "-C instrument-coverage",
			LLVM_PROFILE_FILE = "coverage-%p-%m.profraw",
		},
		-- Optional: override how output is read (required if nextest output parsing changes)
	}),
	require("neotest-go")({
		args = { "-count=1", "-timeout=30s" },
	}),
	require("neotest-vitest")({
		is_test_file = function(file_path)
			return file_path:match(".*%.test%.ts$") or file_path:match(".*%.spec%.ts$")
		end,
		filter_dir = function(name, _rel_path, _root)
			return name ~= "node_modules"
		end,
		vitestCommand = "npx vitest",
		env = { VITEST_COVERAGE = "true" },
	}),
}
