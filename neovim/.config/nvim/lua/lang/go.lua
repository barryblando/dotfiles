vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "gomod", "gowork", "gotmpl" },
	callback = function()
		-- set go specific options
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.shiftwidth = 2
		-- vim.opt_local.colorcolumn = "120"
	end,
})

return {
	{
		"mfussenegger/nvim-dap",
		ft = { "go", "gomod" },
		dependencies = {
			{
				"leoluz/nvim-dap-go",
				opts = {
					dap_configurations = {
						{
							type = "go",
							name = "Attach remote",
							mode = "remote",
							request = "attach",
						},
					},
				},
			},
		},
		opts = {
			configurations = {
				go = {
					-- See require("dap-go") source for full dlv setup.
					{
						type = "go",
						name = "Debug Test (Manually Enter Test Name)",
						request = "launch",
						mode = "test",
						program = "./${relativeFileDirname}",
						args = function()
							local testname = vim.fn.input("Test Name (^regexp$ ok): ")
							return { "-test.run", testname }
						end,
					},
				},
			},
		},
	},
	{
		"andythigpen/nvim-coverage",
		ft = { "go", "gomod" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
			auto_reload = true,
			lang = {
				go = {
					coverage_file = vim.fn.getcwd() .. "/coverage.out",
				},
			},
		},
	},
	{
		"nvim-neotest/neotest",
		ft = { "go", "gomod" },
		dependencies = {
			"fredrikaverpil/neotest-golang",
			-- "marilari88/neotest-vitest",
			-- "nvim-neotest/neotest-jest",
		},
		config = function()
			local go_test_args = {
				"-v",
				-- "-count=1",
				"-race",
				-- "-p=1",
				"-parallel=1",
				"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
			}

			require("neotest").setup({
				adapters = {
					require("neotest-golang")(go_test_args),
				},
			})
		end,
	},
	{
		"crispgm/nvim-go",
		ft = { "go", "gomod" },
		init = function()
			-- Show Lint Issues without Focusing
			vim.cmd([[
      augroup NvimGo
        autocmd!
        autocmd User NvimGoLintPopupPost wincmd p
      augroup END
    ]])
		end,
		opts = {
			-- notify: use nvim-notify
			notify = false,
			-- auto commands
			auto_format = true,
			auto_lint = true,
			-- linters: revive, errcheck, staticcheck, golangci-lint
			linter = "revive",
			-- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
			linter_flags = {},
			-- lint_prompt_style: qf (quickfix), vt (virtual text)
			lint_prompt_style = "qf",
			-- formatter: goimports, gofmt, gofumpt, lsp
			formatter = "gofumpt",
			-- maintain cursor position after formatting loaded buffer
			maintain_cursor_pos = false,
			-- test flags: -count=1 will disable cache
			test_flags = { "-v" },
			test_timeout = "30s",
			test_env = {},
			-- show test result with popup window
			test_popup = true,
			test_popup_auto_leave = false,
			test_popup_width = 80,
			test_popup_height = 10,
			-- test open
			test_open_cmd = "edit",
			-- struct tags
			tags_name = "json",
			tags_options = { "json=omitempty" },
			tags_transform = "snakecase",
			tags_flags = { "-skip-unexported" },
			-- quick type
			quick_type_flags = { "--just-types" },
		},
	},
}
