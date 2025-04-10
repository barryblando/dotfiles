return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	init = function()
		vim.keymap.set("n", "<leader>R", "<cmd>GrugFar<cr>", { desc = "GrugFar | Find And Replace", silent = true })
	end,
	opts = {},
}
