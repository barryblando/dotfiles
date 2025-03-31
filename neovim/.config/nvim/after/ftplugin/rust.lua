local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			local keymap = vim.api.nvim_buf_set_keymap
			local keymaps = {
				{ "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Buf Definition" },
				{ "gD", "<cmd>Telescope lsp_definitions<CR>", "LSP Definition" },
				-- { "K", "<cmd>lua vim.lsp.buf.hover()<CR>" }, -- I put the config in nvim-ufo to include code folding preview
				{ "gI", "<cmd>Telescope lsp_implementations<CR>", "LSP Implementations" },
				{ "gr", "<cmd>Telescope lsp_references<CR>", "LSP References" },
				{
					"gl",
					"<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>",
					"Open Diagnostic (Float)",
				},
				{ "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
				{ "<leader>la", "<cmd>lua require('actions-preview').code_actions()<cr>", "Code Action" },
				{ "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = false }<cr>", "Format" },
				{ "<leader>lF", "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
				{ "<leader>lh", "<cmd>IlluminateToggle<cr>", "Toggle Doc HL" },
				{ "<leader>li", "<cmd>LspInfo<cr>", "Info" },
				{
					"<leader>ld",
					"<cmd>Telescope diagnostics bufnr=0<cr>",
					"Document Diagnostics",
				},
				{
					"<leader>lw",
					"<cmd>Telescope diagnostics<cr>",
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
				{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
				{
					"<leader>lS",
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					"Workspace Symbols",
				},
			}

			for _, v in ipairs(keymaps) do
				keymap(bufnr, "n", v[1], v[2], { desc = v[3], nowait = true, noremap = true, silent = true })
			end

			vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = false })' ]])
		end,
	},
}

wk.add({
	{ "<leader>L", group = "Rust", nowait = true, remap = false },
	{ "<leader>LH", "<cmd>RustDisableInlayHints<Cr>", desc = "Disable Hints", nowait = true, remap = false },
	{
		"<leader>LR",
		"<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
		desc = "Reload Workspace",
		nowait = true,
		remap = false,
	},
	{ "<leader>Lc", "<cmd>RustOpenCargo<Cr>", desc = "Open Cargo", nowait = true, remap = false },
	{ "<leader>Ld", "<cmd>RustDebuggables<Cr>", desc = "Debuggables", nowait = true, remap = false },
	{ "<leader>Lm", "<cmd>RustExpandMacro<Cr>", desc = "Expand Macro", nowait = true, remap = false },
	{ "<leader>Lo", "<cmd>RustOpenExternalDocs<Cr>", desc = "Open External Docs", nowait = true, remap = false },
	{ "<leader>Lp", "<cmd>RustParentModule<Cr>", desc = "Parent Module", nowait = true, remap = false },
	{ "<leader>Lr", "<cmd>RustRunnables<Cr>", desc = "Runnables", nowait = true, remap = false },
	{ "<leader>Lt", "<cmd>lua _CARGO_TEST()<cr>", desc = "Cargo Test", nowait = true, remap = false },
	{ "<leader>Lv", "<cmd>RustViewCrateGraph<Cr>", desc = "View Crate Graph", nowait = true, remap = false },
})

vim.api.nvim_set_keymap("n", "<m-d>", "<cmd>RustOpenExternalDocs<Cr>", { noremap = true, silent = true })
