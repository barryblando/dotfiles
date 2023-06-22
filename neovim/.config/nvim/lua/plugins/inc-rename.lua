return {
	"smjonas/inc-rename.nvim",
	config = function()
		require("inc_rename").setup()
    
		vim.keymap.set("n", "<F2>", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { expr = true })
	end,
}
