local M = {}

function M.init()
	local overseer = require("overseer")

	-- INFO: cargo install cargo-tarpaulin, for test-coverage
	-- Auto-run tarpaulin in Overseer for Rust
	-- vim.api.nvim_create_user_command("TestCoverageRust", function()
	-- 	overseer.run_template({
	-- 		name = "Tarpaulin Coverage",
	-- 		builder = function()
	-- 			return {
	-- 				cmd = { "cargo" },
	-- 				-- args = { "tarpaulin", "--out", "Xml" },
	-- 				args = { "tarpaulin", "--out", "lcov", "--output-dir", "coverage" },
	-- 				-- args = { "tarpaulin", "--out", "lcov", "--output-dir", "coverage", "--output", "lcov.info" },
	-- 				name = "Tarpaulin Coverage",
	-- 				components = {
	-- 					"default",
	-- 				},
	-- 			}
	-- 		end,
	-- 	}, function(task)
	-- 		if task then
	-- 			overseer.open({ enter = false })
	-- 		end
	-- 	end)
	-- end, {})

	vim.api.nvim_create_user_command("TestCoverageRust", function()
		require("overseer").run_template({
			name = "LLVM Cov",
			builder = function()
				return {
					cmd = { "cargo" },
					args = { "llvm-cov", "--lcov", "--output-path", "lcov.info" },
					name = "LLVM Coverage",
					components = {
						"default",
					},
				}
			end,
		}, function(task)
			if task then
				require("overseer").open({ enter = false })
			end
		end)
	end, {})

	-- Go Coverage Command
	vim.api.nvim_create_user_command("TestCoverageGo", function()
		overseer.run_template({
			name = "Go Coverage",
			builder = function()
				return {
					cmd = { "go" },
					args = { "test", "-coverprofile=coverage.out" },
					name = "Go Coverage",
					components = {
						"default",
					},
				}
			end,
		}, function(task)
			if task then
				overseer.open({ enter = false })
			end
		end)
	end, {})

	-- TypeScript Coverage Command
	vim.api.nvim_create_user_command("TestCoverageTypeScript", function()
		overseer.run_template({
			name = "Vitest Coverage",
			builder = function()
				return {
					cmd = { "npx" },
					args = { "vitest", "run", "--coverage" },
					name = "Vitest Coverage",
					components = {
						"default",
					},
				}
			end,
		}, function(task)
			if task then
				overseer.open({ enter = false })
			end
		end)
	end, {})
end

function M.keys()
	-- require("nio")
	local neotest = require("neotest")
	local coverage = require("coverage")
	local notify = require("notify")
	local status_ok, wk = pcall(require, "which-key")
	if not status_ok then
		return
	end

	local function run_tests_with_coverage()
		local ft = vim.bo.filetype
		neotest.run.run(vim.fn.expand("%"))

		vim.defer_fn(function()
			if ft == "rust" then
				vim.cmd("TestCoverageRust")
				coverage.load_lcov("lcov.info")
				require("lualine").refresh()
				coverage.show()
			elseif ft == "go" then
				coverage.load("coverage.out")
			elseif ft == "typescript" then
				coverage.load("coverage/lcov.info")
			end
			coverage.show()
		end, 1000)
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(args)
			local fname = vim.api.nvim_buf_get_name(args.buf)
			if
				fname:match("_test%.go$")
				or fname:match("%.test%.ts$")
				or fname:match("%.spec%.ts$")
				or fname:match("tests?/.*%.rs$")
			then
				wk.add({ { "<leader>T", group = "Test", nowait = true, remap = false, buffer = 0 } })

				vim.keymap.set("n", "<leader>Tt", function()
					neotest.run.run()
				end, { buffer = args.buf, desc = "Run nearest test" })

				vim.keymap.set("n", "<leader>Tf", function()
					neotest.run.run(vim.fn.expand("%"))
				end, { buffer = args.buf, desc = "Run file tests" })

				vim.keymap.set(
					"n",
					"<leader>Ts",
					neotest.summary.toggle,
					{ buffer = args.buf, desc = "Toggle test summary" }
				)

				vim.keymap.set("n", "<leader>To", neotest.output.open, { buffer = args.buf, desc = "Open test output" })

				vim.keymap.set(
					"n",
					"<leader>Tp",
					neotest.output_panel.toggle,
					{ buffer = args.buf, desc = "Toggle output panel" }
				)

				-- Auto-run tests + coverage in one step
				vim.keymap.set(
					"n",
					"<leader>Ta",
					run_tests_with_coverage,
					{ buffer = args.buf, desc = "Test and show coverage" }
				)

				vim.keymap.set("n", "<leader>Tc", function()
					coverage.load_lcov("lcov.info")
				end, { buffer = args.buf, desc = "Load test coverage" })

				vim.keymap.set("n", "<leader>Ts", function()
					local summary = require("coverage").summary()
					if summary and summary.covered and summary.total then
						local percent = math.floor((summary.covered / summary.total) * 100)
						notify("Coverage: " .. percent .. "%", vim.log.levels.INFO, { title = "Test Coverage" })
					else
						notify("No coverage data loaded.", vim.log.levels.WARN, { title = "Test Coverage" })
					end
				end, { buffer = args.buf, desc = "Show coverage summary" })
			end
		end,
	})
end

function M.config()
	local neotest = require("neotest")
	-- local notify = require("notify")
	local coverage = require("coverage")

	neotest.setup({
		adapters = require("plugins.testing.adapters"),
		quickfix = {
			enabled = false,
		},
		output_panel = {
			enabled = true,
			open = "botright split | resize 15",
		},
		icons = {
			passed = "",
			failed = "",
			running = "",
			skipped = "󰛃",
			unknown = "",
		},
		consumers = {
			overseer = require("neotest.consumers.overseer"),
		},
		default_strategy = "overseer",
	})

	-- vim.api.nvim_create_autocmd("User", {
	-- 	pattern = "NeotestTestFinished",
	-- 	callback = function()
	-- 		notify("Test run completed", "info", { title = "Neotest" })
	-- 		require("neotest").output_panel.open()
	-- 	end,
	-- })

	-- vim.api.nvim_create_autocmd("User", {
	-- 	pattern = "NeotestTestFinished",
	-- 	callback = function()
	-- 		notify("Test run completed", "info", { title = "Neotest" })
	-- 		require("neotest").output_panel.open()
	-- 		local ft = vim.bo.filetype
	-- 		if ft == "rust" then
	-- 			coverage.load("tarpaulin-report.xml")
	--	    coverage.load_lcov("coverage/lcov.info")
	-- 		elseif ft == "go" then
	-- 			coverage.load("coverage.out")
	-- 		elseif ft == "typescript" then
	-- 			coverage.load("coverage/lcov.info")
	-- 		end
	-- 		coverage.show()
	-- 	end,
	-- })

	coverage.setup({
		commands = true,
		auto_reload = true,
		signs = {
			covered = { hl = "CoverageCovered", text = "┃" },
			uncovered = { hl = "CoverageUncovered", text = "┃" },
		},
	})
end

function M.get_coverage_summary()
	local summary = require("coverage").summary()
	if summary and summary.covered and summary.total and summary.total > 0 then
		local percent = math.floor((summary.covered / summary.total) * 100)
		return "󰋽 " .. percent .. "%"
	end
	return ""
end

return M
