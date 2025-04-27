M = {}

------------------------
--   YANKY KEYMAPS    --
------------------------
function M.setup_yanky_keymaps()
	return {
		{ "<leader>p", "<cmd>YankyRingHistory<cr>", mode = { "n", "x" }, desc = "Open Yank History" },
		{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
		{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
		{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
		{ "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
		{ "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
		{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
		{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
		{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
		{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
		{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
		{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
		{ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
		{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
		{ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
		{ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
	}
end

------------------------
--    LSP KEYMAPS     --
------------------------
function M.setup_lsp_keymaps(bufnr)
	local keymap_buf = vim.api.nvim_buf_set_keymap
	local keymaps = {
		{ "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Buf Definition" },
		{ "gD", "<cmd>FzfLua lsp_definitions<CR>", "LSP Definition" },
		{ "K", "<cmd>lua vim.lsp.buf.hover() <CR>", "Hover Documentation" },
		{ "gI", "<cmd>FzfLua lsp_implementations<CR>", "LSP Implementations" },
		{ "gr", "<cmd>FzfLua lsp_references<CR>", "LSP References" },
		{ "gl", "<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>", "Open Diagnostic (Float)" },
		{ "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
		{ "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", "Code Action" },
		{ "<leader>lf", "<cmd>lua require('conform').format({ async = true })<cr>", "Format" },
		{ "<leader>lF", "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
		{ "<leader>lh", "<cmd>IlluminateToggle<cr>", "Toggle Doc HL" },
		{ "<leader>li", "<cmd>LspInfo<cr>", "Info" },
		{
			"<leader>ld",
			"<cmd>FzfLua diagnostics_document<cr>",
			"Document Diagnostics",
		},
		{
			"<leader>lw",
			"<cmd>FzfLua diagnostics_workspace<cr>",
			"Workspace Diagnostics",
		},
		{ "<leader>lj", "<cmd>lua vim.diagnostic.jump({count=1, float=true})<cr>", "Next Diagnostic" },
		{ "<leader>lk", "<cmd>lua vim.diagnostic.jump({count=-1, float=true})<cr>", "Prev Diagnostic" },
		{
			"<leader>ll",
			"<cmd>lua vim.lsp.codelens.run()<cr>",
			"CodeLens Action",
		},
		{ "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", "Quickfix" },
		{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		{ "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", "Document Symbols" },
		{
			"<leader>lS",
			"<cmd>FzfLua lsp_live_workspace_symbols<cr>",
			"Workspace Symbols",
		},
	}

	for _, v in ipairs(keymaps) do
		keymap_buf(bufnr, "n", v[1], v[2], { desc = v[3], nowait = true, noremap = true, silent = true })
	end

	vim.keymap.set("n", "<leader>lH", function()
		-- Check if the inlay hint API exists
		if not vim.lsp.inlay_hint or not vim.lsp.inlay_hint.is_enabled then
			vim.notify("Inlay hint API not available", vim.log.levels.WARN)
			return
		end

		-- Get current enabled state
		local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr })

		-- Reverse logic: assume inlay is enabled by default, so disable first
		local new_state = not enabled
		vim.lsp.inlay_hint.enable(new_state, { bufnr })

		-- Force statusline update
		vim.cmd("redrawstatus")

		vim.notify("Inlay hints " .. (new_state and "enabled" or "disabled"))
	end, { desc = "Toggle Inlay Hints" })

	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = false })' ]])
end

------------------------
--    DAP KEYMAPS     --
------------------------
function M.setup_dap_keymaps()
	return {
		{
			"<leader>dd",
			function()
				require("overseer").run_template({}, function(task)
					if task then
						require("plugins.overseer").open_and_close()
						-- Start debugging after task is started
						require("dap").continue()
					end
				end)
			end,
			desc = "[d]ebug with task",
		},
		{
			"<leader>db",
			-- ".",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "[d]ebug toggle [b]reakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "[d]ebug [B]reakpoint",
		},
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug | Continue (start here)",
		},
		{
			"<F6>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug | Step Into",
		},
		{
			"<F7>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug | Step Over",
		},
		{
			"<F8>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug | Step Out",
		},
		-- INFO: Disable step back and restart, dap adapters I use doesn't support time travel debugging
		-- {
		-- 	"<F9>",
		-- 	function()
		-- 		require("dap").step_back()
		-- 	end,
		-- 	desc = "Debug | Step Back",
		-- },
		-- {
		-- 	"<leader>dR",
		-- 	function()
		-- 		require("dap").restart()
		-- 	end,
		-- 	desc = "Debug | Restart",
		-- },
		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "[d]ebug [C]ursor",
		},
		{
			"<leader>dg",
			function()
				require("dap").goto_()
			end,
			desc = "[d]ebug [g]o to line",
		},
		{
			"<leader>dj",
			function()
				require("dap").down()
			end,
			desc = "[d]ebug [j]ump down",
		},
		{
			"<leader>dk",
			function()
				require("dap").up()
			end,
			desc = "[d]ebug [k]ump up",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "[d]ebug [l]ast",
		},
		{
			"<leader>dp",
			function()
				require("dap").pause()
			end,
			desc = "[d]ebug [p]ause",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "[d]ebug toggle [r]epl",
		},
		{
			"<leader>dc",
			function()
				require("dap").clear_breakpoints()
			end,
			desc = "[d]ebug [c]lear breakpoints",
		},
		{
			"<leader>ds",
			function()
				require("dap").session()
			end,
			desc = "[d]ebug [s]ession",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "[d]ebug [t]erminate",
		},
		{
			"<F9>",
			function()
				local dap = require("dap")
				local dapui = require("dapui")
				dap.terminate()
				dap.disconnect()
				dapui.close()
			end,
			desc = "[d]ebug Force [T]erminate",
		},
		{
			"<leader>du",
			"<cmd>lua require'dapui'.toggle()<cr>",
			desc = "[d]ebug [u]i",
			silent = true,
		},
		{
			"<leader>dw",
			function()
				-- require("dap.ui.widgets").hover()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end,
			desc = "[d]ebug [w]idgets",
		},
	}
end

------------------------
-- TOGGLETERM KEYMAPS --
------------------------
function M.setup_toggleterm_keymaps()
	return {
		{ "<leader>t1", ":1ToggleTerm<cr>", desc = "1", nowait = true, remap = false },
		{ "<leader>t2", ":2ToggleTerm<cr>", desc = "2", nowait = true, remap = false },
		{ "<leader>t3", ":3ToggleTerm<cr>", desc = "3", nowait = true, remap = false },
		{ "<leader>t4", ":4ToggleTerm<cr>", desc = "4", nowait = true, remap = false },
		{ "<leader>tb", "<cmd>lua _BTOP_TOGGLE()<cr>", desc = "Btop", nowait = true, remap = false },
		{ "<leader>td", "<cmd>lua _LAZYDOCKER_TOGGLE()<cr>", desc = "Docker", nowait = true, remap = false },
		{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float", nowait = true, remap = false },
		{ "<leader>tg", "<cmd>lua _GDU_TOGGLE()<cr>", desc = "GDU", nowait = true, remap = false },
		{
			"<leader>th",
			"<cmd>ToggleTerm size=10 direction=horizontal<cr>",
			desc = "Horizontal",
			nowait = true,
			remap = false,
		},
		{ "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node", nowait = true, remap = false },
		{ "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python", nowait = true, remap = false },
		{
			"<leader>tv",
			"<cmd>ToggleTerm size=80 direction=vertical<cr>",
			desc = "Vertical",
			nowait = true,
			remap = false,
		},
	}
end

------------------------
--  GITSIGNS KEYMAPS  --
------------------------
function M.setup_gitsigns_keymaps()
	return {
		{
			"<leader>gR",
			"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
			desc = "Reset Buffer (Git)",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gb",
			"<cmd>FzfLua git_branches<cr>",
			desc = "Git Branches",
			nowait = true,
			remap = false,
		},
		{ "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits", nowait = true, remap = false },
		{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", nowait = true, remap = false },
		{ "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit", nowait = true, remap = false },
		{
			"<leader>gj",
			"<cmd>lua require 'gitsigns'.next_hunk()<cr>",
			desc = "Next Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gk",
			"<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
			desc = "Prev Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gl",
			"<cmd>lua require 'gitsigns'.blame_line()<cr>",
			desc = "Blame",
			nowait = true,
			remap = false,
		},
		{
			"<leader>go",
			"<cmd>FzfLua git_status<cr>",
			desc = "Git Status",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gp",
			"<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
			desc = "Preview Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gr",
			"<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
			desc = "Reset Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gs",
			"<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
			desc = "Stage Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gS",
			"<cmd>:lua require('plugins.fzflua.git_history_fzf').live_git_search()<cr>",
			desc = "Git History Search",
			nowait = true,
			remap = false,
		},

		{
			"<leader>gu",
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			desc = "Undo Stage Hunk",
			nowait = true,
			remap = false,
		},
	}
end

------------------------
-- FZF_LUA KEYMAPS  --
------------------------
function M.setup_fzf_lua_keymaps()
	return {
		{ "<leader>fC", "<cmd>FzfLua commands<cr>", desc = "Commands", nowait = true, remap = false },
		{ "<leader>fH", "<cmd>FzfLua highlights<cr>", desc = "Highlights", nowait = true, remap = false },
		{ "<leader>fM", "<cmd>FzfLua manpages<cr>", desc = "Man Pages", nowait = true, remap = false },
		{ "<leader>fr", "<cmd>FzfLua registers<cr>", desc = "Registers", nowait = true, remap = false },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers", nowait = true, remap = false },
		{ "<leader>fc", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme", nowait = true, remap = false },
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files", nowait = true, remap = false },
		{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help", nowait = true, remap = false },
		{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
		{ "<leader>fl", "<cmd>FzfLua resume<cr>", desc = "Last Search", nowait = true, remap = false },
		{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent File", nowait = true, remap = false },
		{ "<leader>fs", "<cmd>FzfLua grep<cr>", desc = "Find String", nowait = true, remap = false },
		{ "<leader>ft", "<cmd>FzfLua live_grep<cr>", desc = "Find Text", nowait = true, remap = false },
	}
end

------------------------
-- TELESCOPE KEYMAPS  --
------------------------
function M.setup_telescope_keymaps()
	return {}
	-- return {
	-- 	{ "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = true, remap = false },
	-- 	{ "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights", nowait = true, remap = false },
	-- 	{ "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", nowait = true, remap = false },
	-- 	{ "<leader>fr", "<cmd>Telescope registers<cr>", desc = "Registers", nowait = true, remap = false },
	-- 	{
	-- 		"<leader>fb",
	-- 		"<cmd>Telescope git_branches<cr>",
	-- 		desc = "Checkout branch",
	-- 		nowait = true,
	-- 		remap = false,
	-- 	},
	-- 	{ "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme", nowait = true, remap = false },
	-- 	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files", nowait = true, remap = false },
	-- 	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help", nowait = true, remap = false },
	-- 	{
	-- 		"<leader>fi",
	-- 		"<cmd>lua require('telescope').extensions.media_files.media_files()<cr>",
	-- 		desc = "Media",
	-- 		nowait = true,
	-- 		remap = false,
	-- 	},
	-- 	{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
	-- 	{ "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Last Search", nowait = true, remap = false },
	-- 	{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File", nowait = true, remap = false },
	-- 	{ "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Find String", nowait = true, remap = false },
	-- 	{ "<leader>ft", "<cmd>Telescope live_grep<cr>", desc = "Find Text", nowait = true, remap = false },
	-- }
end

------------------------
--  HARPOON KEYMAPS   --
------------------------
function M.setup_harpoon_keymaps()
	return {
		{
			"m,",
			'<cmd>lua require("harpoon"):list():prev()<cr>',
			desc = "Harpoon Prev",
			nowait = true,
			remap = false,
		},
		{
			"m.",
			'<cmd>lua require("harpoon"):list():next()<cr>',
			desc = "Harpoon Next",
			nowait = true,
			remap = false,
		},
		{ "m;", "<cmd>HarpoonUI<cr>", desc = "Harpoon UI", nowait = true, remap = false },
		{ "mm", '<cmd>lua require("harpoon"):list():add()<cr>', desc = "Harpoon", nowait = true, remap = false },
	}
end

return M
