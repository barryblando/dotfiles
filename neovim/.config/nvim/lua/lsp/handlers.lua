local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if not status_cmp_ok then
	return
end

M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

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
	-- vim.cmd([[ autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false }) ]])
end

------------------------
--   DOC HIGHLIGHT    --
------------------------

local function lsp_highlight_document(client)
	-- INFO: If you are on Neovim v0.8, use client.server_capabilities.documentHighlightProvider
	-- if client.resolved_capabilities.document_highlight then
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_exec(
			[[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end
end

------------------------
--    LSP KEYMAPS     --
------------------------

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>Telescope lsp_declarations<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]])
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-f>", "<cmd>Format<cr>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-a>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

------------------------
--     ON ATTACH      --
------------------------

M.on_attach = function(client, bufnr)
	local client_to_skip = "dockerls cssls bashls" -- clients that navic doesn't support
	if client_to_skip:find(client.name) then
		goto continue
	end

	if client.supports_method("textDocument/documentSymbol") then
		require("nvim-navic").attach(client, bufnr) -- in order for nvim-navic to work
	end

	::continue::
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
	-- if client.name == "tsserver" then
	--   require("lsp-inlayhints").on_attach(bufnr, client)
	-- end
end

function M.enable_format_on_save()
	vim.cmd([[
    augroup format_on_save
      autocmd! 
      autocmd BufWritePre * lua vim.lsp.buf.format({ async = false }) 
    augroup end
  ]])
	vim.notify("Enabled format on save")
end

function M.disable_format_on_save()
	M.remove_augroup("format_on_save")
	vim.notify("Disabled format on save")
end

function M.toggle_format_on_save()
	if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
		M.enable_format_on_save()
	else
		M.disable_format_on_save()
	end
end

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.cmd("au! " .. name)
	end
end

vim.cmd([[ command! LspToggleAutoFormat execute 'lua require("lsp.handlers").toggle_format_on_save()' ]])

return M
