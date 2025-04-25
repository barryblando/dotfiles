local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

wk.add({
	{
		"<leader>x",
		"<cmd>!chmod +x %<cr>",
		desc = "Make Script Executable",
		nowait = true,
		remap = false,
		buffer = true,
	},
})
