local autocmd = vim.api.nvim_create_autocmd

-- #########################
--    AUTOCOMMANDS START
-- #########################

local function augroup(name)
	return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- Remove statusline and tabline when in Alpha
autocmd({ "User" }, {
	pattern = { "AlphaReady" },
	callback = function()
		vim.cmd([[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]])
	end,
})

-- close some filetypes with <q>
autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"Jaq",
		"PlenaryTestPopup",
		"help",
		"Markdown",
		"DressingSelect",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

autocmd({ "FileType" }, {
	pattern = { "Jaq" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> <m-r> :close<CR>
      " nnoremap <silent> <buffer> <m-r> <NOP> 
      set nobuflisted 
    ]])
	end,
})

-- NOTE: workaround for the meantime, gitsigns and statuscol not syncing together
autocmd({ "BufReadPost", "BufRead" }, {
	group = augroup("gitsigns_refresh"),
	callback = function()
		require("gitsigns").refresh()
	end,
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight on yank
autocmd({ "TextYankPost" }, {
	group = augroup("yank"),
	callback = function()
		if vim.fn.has("wsl") == 1 then
			vim.fn.system("clip.exe", vim.fn.getreg('"'))
		else
			vim.highlight.on_yank()
		end
	end,
})

autocmd({ "BufWinEnter" }, {
	callback = function()
		vim.cmd("set formatoptions-=cro")
	end,
})

-- Set wrap and spell in markdown and gitcommit
autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

autocmd({ "VimEnter" }, {
	callback = function()
		vim.cmd("hi link illuminatedWord LspReferenceText")
	end,
})

autocmd({ "CursorHold" }, {
	callback = function()
		local status_ok, luasnip = pcall(require, "luasnip")
		if not status_ok then
			return
		end
		if luasnip.expand_or_jumpable() then
			-- ask maintainer for option to make this silent
			-- luasnip.unlink_current()
			vim.cmd([[silent! lua require("luasnip").unlink_current()]])
		end
	end,
})

-- Disable diagnostic in env file
autocmd("BufEnter", {
	pattern = "*.env*",
	group = augroup("_env"),
	callback = function(args)
		vim.diagnostic.enable(false, { bufnr = args.buf })
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Resize splits if window got resized
autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Go to last loc when opening a buffer
autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Conceal html class attribute values using treesitter
-- For those who don't have a conceal level set, make sure vim.opt.conceallevel = 2.
-- https://gist.github.com/mactep/430449fd4f6365474bfa15df5c02d27b

local namespace = vim.api.nvim_create_namespace("class_conceal")
local hgroup = vim.api.nvim_create_augroup("class_conceal", { clear = true })

local conceal_html_class = function(bufnr)
	local language_tree = vim.treesitter.get_parser(bufnr, "html")
	local syntax_tree = language_tree:parse()
	local root = syntax_tree[1]:root()

	local query = vim.treesitter.parse_query(
		"html",
		[[
    ((attribute
        (attribute_name) @att_name (#eq? @att_name "class")
        (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
    ]]
	) -- using single character for conceal thanks to u/Rafat913

	for _, captures, metadata in query:iter_matches(root, bufnr, root:start(), root:end_()) do
		local start_row, start_col, end_row, end_col = captures[2]:range()
		vim.api.nvim_buf_set_extmark(bufnr, namespace, start_row, start_col, {
			end_line = end_row,
			end_col = end_col,
			conceal = metadata[2].conceal,
		})
	end
end

autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
	group = hgroup,
	pattern = "*.html",
	callback = function()
		conceal_html_class(vim.api.nvim_get_current_buf())
	end,
})

-- NOICE UI - Temporary Transparency Trick
local search = vim.api.nvim_get_hl_by_name("Search", true)
vim.api.nvim_set_hl(0, "TransparentSearch", { fg = search.foreground })

local help = vim.api.nvim_get_hl_by_name("IncSearch", true)
vim.api.nvim_set_hl(0, "TransparentHelp", { fg = help.foreground })

-- show cursor line only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
		if ok and cl then
			vim.wo.cursorline = true
			vim.api.nvim_win_del_var(0, "auto-cursorline")
		end
	end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		local cl = vim.wo.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
			vim.wo.cursorline = false
		end
	end,
})
