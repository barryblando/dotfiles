local ok_status, lightbulb = pcall(require, "nvim-lightbulb")

if not ok_status then
	return
end

require("nvim-lightbulb").setup({
	ignore = { "null-ls" },
	sign = {
		enabled = false,
	},
	virtual_text = {
		enabled = true,
		text = "💡",
		hl_mode = "combine",
	},
	status_text = {
		enabled = true,
		text = " Code Action Available",
		-- text = " Code Action Available",
		text_unavailable = "",
	},
})

local function update()
	-- update status
	lightbulb.update_lightbulb()

	-- display status
	local status = lightbulb.get_status_text()
	vim.api.nvim_echo({ { status, "WarningMsg" } }, false, {})
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	desc = "Check for available code actions",
	callback = update,
})
