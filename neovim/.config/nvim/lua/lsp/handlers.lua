local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

------------------------
--    SETUP START     --
------------------------

M.setup = function()
	local icons = require("utils.icons")

	local signs = {
		{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
		{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
		{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
		{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			show_header = true,
			source = "always",
			focusable = false,
		},
	}

	vim.diagnostic.config(config)

	-- Hover rounded border with transparency effect from cmp
	local function custom_handler(handler)
		local overrides = { border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" } }
		-- border = { "┏", "━", "┓", "┃", "┛","━", "┗", "┃" },
		return vim.lsp.with(function(...)
			local buf, winnr = handler(...)
			if buf then
				-- use the same transparency effect from cmp
				vim.api.nvim_win_set_option(winnr, "winhighlight", "Normal:NormalFloat")
			end
		end, overrides)
	end

	-- Go-to definition in a split window
	local function goto_definition(split_cmd)
		local util = vim.lsp.util
		local log = require("vim.lsp.log")
		local api = vim.api

		-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
		local handler = function(_, result, ctx)
			if result == nil or vim.tbl_isempty(result) then
				local _ = log.info() and log.info(ctx.method, "No location found")
				return nil
			end

			if split_cmd then
				vim.cmd(split_cmd)
			end

			if vim.tbl_islist(result) then
				util.jump_to_location(result[1])

				if #result > 1 then
					util.setqflist(util.locations_to_items(result))
					api.nvim_command("copen")
					api.nvim_command("wincmd p")
				end
			else
				util.jump_to_location(result)
			end
		end
		return handler
	end

	-- https://neovim.io/doc/user/lsp.html
	vim.lsp.handlers["textDocument/hover"] = custom_handler(vim.lsp.handlers.hover)
	vim.lsp.handlers["textDocument/signatureHelp"] = custom_handler(vim.lsp.handlers.signature_help)
	vim.lsp.handlers["textDocument/definition"] = goto_definition("split")

	-- wrapped open_float to inspect diagnostics and use the severity color for border
	-- https://neovim.discourse.group/t/lsp-diagnostics-how-and-where-to-retrieve-severity-level-to-customise-border-color/1679
	vim.diagnostic.open_float = (function(orig)
		return function(bufnr, opts)
			local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
			local opts = opts or {}
			-- A more robust solution would check the "scope" value in `opts` to
			-- determine where to get diagnostics from, but if you're only using
			-- this for your own purposes you can make it as simple as you like
			local diagnostics = vim.diagnostic.get(opts.bufnr or 0, { lnum = lnum })
			local max_severity = vim.diagnostic.severity.HINT

			for _, d in ipairs(diagnostics) do
				-- Equality is "less than" based on how the severities are encoded
				if d.severity < max_severity then
					max_severity = d.severity
				end
			end

			local border_color = ({
				[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			})[max_severity]

			opts.border = {
				{ "╔", border_color },
				{ "═", border_color },
				{ "╗", border_color },
				{ "║", border_color },
				{ "╝", border_color },
				{ "═", border_color },
				{ "╚", border_color },
				{ "║", border_color },
			}

			orig(bufnr, opts)
		end
	end)(vim.diagnostic.open_float)

	-- Show line diagnostics in floating popup on hover, except insert mode (CursorHoldI)
	vim.o.updatetime = 250
	vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float()]])
end

------------------------
--   DOC HIGHLIGHT    --
------------------------

local function lsp_highlight_document(client)
	-- INFO: If you are on Neovim v0.8, use client.server_capabilities.documentHighlightProvider
	-- if client.resolved_capabilities.document_highlight then
	if client.server_capabilities.documentHighlightProvider then
		local status_ok, illuminate = pcall(require, "illuminate")
		if not status_ok then
			return
		end
		vim.api.nvim_exec(
			[[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]],
			false
		)
		illuminate.on_attach(client)
	end
end

------------------------
--    LSP KEYMAPS     --
------------------------

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
end

------------------------
--     FORMATTING     --
------------------------

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

------------------------
--  ASYNC FORMATTING  --
------------------------

-- WARN: Enable async_formatting if you prefer it but does not guarantee reliability, use with caution.
local async_formatting = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- Async formatting works by sending a formatting request, then applying and writing results once they're received.
	-- The async formatting implementation here comes with the following caveats:
	--    If you edit the buffer in between sending a request and receiving results, those results won't be applied.
	--    Each save will result in writing the file to the disk twice.
	--    :wq will not format the file before quitting.

	vim.lsp.buf_request(
		bufnr,
		"textDocument/formatting",
		{ textDocument = { uri = vim.uri_from_bufnr(bufnr) } },
		function(err, res, ctx)
			if err then
				local err_msg = type(err) == "string" and err or err.message
				-- you can modify the log message / level (or ignore it completely)
				vim.notify("Formatting: " .. err_msg, vim.log.levels.WARN)
				return
			end

			-- don't apply results if buffer is unloaded or has been modified
			if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
				return
			end

			if res then
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent noautocmd update")
				end)
			end
		end
	)
end

-- INFO: if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
M.on_attach = function(client, bufnr)
	-- INFO: Enable this code to auto format after opening a file
	-- lsp_formatting(bufnr)

	-- INFO: Enable this code if you want auto formatting on save
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				-- NOTE: This is the most reliable way to format files on save
				lsp_formatting(bufnr)
				-- async_formatting(bufnr)
			end,
		})
	end

  local client_to_skip = "dockerls cssls" -- clients that navic doesn't support
  if client_to_skip:find(client.name) then
			goto continue
	end

  if client.supports_method("textDocument/documentSymbol") then
		require("nvim-navic").attach(client, bufnr) -- in order for nvim-navic to work
	end

  ::continue::
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
