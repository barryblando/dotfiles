return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	enabled = false,
	event = "InsertEnter",
	opts = {
		suggestion = { enabled = false },
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	},
}
