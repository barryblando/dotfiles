local M = {}

function M.init()
	local overseer = require("overseer")

	-- Go Coverage Command
	vim.api.nvim_create_user_command("TestCoverageGo", function()
		overseer.run_task({
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
		overseer.run_task({
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
	local overseer = require("overseer")
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
				overseer.run_task({ name = "Generate LLVM_COV report" })
				coverage.load(true)
				-- require("lualine").refresh()
			elseif ft == "go" then
				-- TODO: Make template coverage for Go
				coverage.load("coverage.out")
			elseif ft == "typescript" then
				-- TODO: Make template coverage for Typescript/JavaScript
				coverage.load("coverage/lcov.info")
			end
			coverage.show()
		end, 1000)
	end

	local function has_test_files()
		local patterns = {
			"**/tests/*.rs",
			"**/*_test.rs",
			"**/*.spec.ts",
			"**/*.test.ts",
			"**/*_test.go",
		}

		for _, pat in ipairs(patterns) do
			local matches = vim.fn.glob(pat, true, true)
			if #matches > 0 then
				return true
			end
		end

		return false
	end

	local function is_test_buffer(bufname)
		return bufname:match("tests?/")
			or bufname:match("_test%.")
			or bufname:match("%.spec%.")
			or bufname:match("%.test%.")
	end

	-- SET TESTS KEYMAPS
	local function set_tests_keymaps(args)
		wk.add({ { "<leader>T", group = "Test", nowait = true, remap = false, buffer = 0 } })

		vim.keymap.set("n", "<leader>Tt", function()
			neotest.run.run()
		end, { buffer = args.buf, desc = "Run nearest test" })

		vim.keymap.set("n", "<leader>Tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { buffer = args.buf, desc = "Run file tests" })

		vim.keymap.set("n", "<leader>Ts", neotest.summary.toggle, { buffer = args.buf, desc = "Toggle test summary" })

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
	end

	-- SET COVERAGE KEYMAPS
	local function set_coverage_keymaps(args)
		wk.add({ { "<leader>T", group = "Test", nowait = true, remap = false, buffer = 0 } })

		vim.keymap.set("n", "<leader>Tl", function()
			require("coverage").load(true)
		end, { buffer = args.buf, desc = "Load Test Coverage" })

		vim.keymap.set("n", "<leader>Tt", function()
			require("coverage").toggle()
		end, { buffer = args.buf, desc = "Toggle Coverage View" })

		vim.keymap.set("n", "<leader>Ts", function()
			-- Defer summary check to wait for parsing to complete
			vim.defer_fn(function()
				local summary = coverage.summary()
				if summary and summary.covered and summary.total and summary.total > 0 then
					local percent = math.floor((summary.covered / summary.total) * 100)
					vim.notify("Coverage: " .. percent .. "%", vim.log.levels.INFO, { title = "Test Coverage" })
				end
			end, 100) -- Wait 100ms to ensure parsing is done
		end, { buffer = args.buf, desc = "Show coverage summary" })
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(args)
			local bufname = vim.api.nvim_buf_get_name(args.buf)
			if has_test_files() and is_test_buffer(bufname) then
				set_tests_keymaps(args)
			elseif has_test_files() and not is_test_buffer(bufname) then
				set_coverage_keymaps(args)
			end
		end,
	})
end

function M.config()
	local neotest = require("neotest")
	-- local notify = require("notify")
	local coverage = require("coverage")
	local icons = require("core.icons")

	neotest.setup({
		adapters = require("plugins.testing.adapters"),
		quickfix = {
			enabled = true,
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
		signs = {
			covered = { hl = "CoverageCovered", text = "┃" },
			uncovered = { hl = "CoverageUncovered", text = "┃" },
		},
		summary = {
			width_percentage = 0.75,
			height_percentage = 0.5,
			borders = icons.ui.Border_Solid_Line,
			window = {
				winhighlight = "Normal:CoveragePopup,FloatBorder:CoveragePopup",
				winblend = 0,
			},
			min_coverage = 80.0,
		},
	})
end

return M
