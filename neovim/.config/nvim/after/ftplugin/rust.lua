local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

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
