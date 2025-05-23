return {
	"saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	dependencies = { { "nvim-lua/plenary.nvim" } },
	opts = {
		popup = {
			-- autofocus = true,
			style = "minimal",
			border = "rounded",
			show_version_date = false,
			show_dependency_version = true,
			max_height = 30,
			min_width = 20,
			padding = 1,
		},
	},
}
