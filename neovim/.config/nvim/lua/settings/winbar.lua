local M = {}

M.winbar_filetype_exclude = {
	"help",
	"startify",
	"dashboard",
	"packer",
	"neogitstatus",
	"neo-tree",
	"alpha",
	"Outline",
	"spectre_panel",
	"toggleterm",
}

local get_filename = function()
	local cwd = vim.fn.getcwd():match("([^/]+)$")
	local filename = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local f = require("utils.functions")

	if not f.isempty(filename) then
		local file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(
			filename,
			extension,
			{ default = true }
		)

		local hl_group = "FileIconColor" .. extension

		vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
		if f.isempty(file_icon) then
			file_icon = ""
			file_icon_color = ""
		end

		-- return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#LineNr#" .. filename .. "%*"
		return " " .. "%#LineNr#" .. filename .. "%*"
	end
end

local get_navic = function()
	local status_navic_ok, navic = pcall(require, "nvim-navic")
	if not status_navic_ok then
		return ""
	end

	local status_ok, navic_location = pcall(navic.get_location, {})
	if not status_ok then
		return ""
	end

	if not navic.is_available() or navic_location == "error" then
		return ""
	end

	if not require("utils.functions").isempty(navic_location) then
		return require("utils.icons").ui.ChevronRight .. " " .. navic_location
	else
		return ""
	end
end

local excludes = function()
	if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
		vim.opt_local.winbar = nil
		return true
	end
	return false
end

M.get_winbar = function()
	if excludes() then
		return
	end
	local f = require("utils.functions")
	local value = get_filename()

	local navic_added = false
	if not f.isempty(value) then
		local navic_value = get_navic()
		value = value .. " " .. navic_value
		if not f.isempty(navic_value) then
			navic_added = true
		end
	end

	if not f.isempty(value) and f.get_buf_option("mod") then
		local mod = "%#LineNr#" .. require("utils.icons").ui.Circle .. "%*"
		if navic_added then
			value = value .. " " .. mod
		else
			value = value .. mod
		end
	end

	local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
	if not status_ok then
		return
	end
end

return M
