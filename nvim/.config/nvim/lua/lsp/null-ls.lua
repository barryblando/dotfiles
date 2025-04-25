local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
-- local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
	debug = false,
	sources = {
		-- Basic Formatting needs
		formatting.prettierd.with({
			filetypes = {
				"css",
				"scss",
				"less",
				"html",
				"json",
				"jsonc",
				"yaml",
				"markdown",
				"graphql",
				"handlebars",
			},
			condition = function(utils)
				return utils.root_has_file({
					".prettierrc.json",
					".prettierignore",
					".prettierrc.yml",
					".prettierrc.yaml",
					".prettierrc.json5",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.config.js",
					".prettierrc.config.cjs",
				})
			end,
			prefer_local = "node_modules/.bin", -- find local prettier, fall back to global prettier if it can't find one locally
		}),

		-- Lua
		formatting.stylua,

		-- Protocol Buffers
		formatting.buf,

		-- Go
		-- formatting.goimports,
		-- formatting.goimports_reviser,
		-- formatting.golines,
		-- formatting.gofumpt,

		-- null_ls.builtins.code_actions.refactoring,

		-- shell scripts
		-- diagnostics.shellcheck,

		-- gitsigns integration
		code_actions.gitsigns,
	},

	-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/879#issuecomment-1345440978
	on_attach = function(client, bufnr)
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function()
				vim.lsp.buf.format({
					bufnr = bufnr,
					async = false,
					filter = function(clientLS)
						return clientLS.name == "null-ls"
					end,
				})
			end, {})

			-- you can leave this out if your on_attach is unique to null-ls,
			-- but if you share it with multiple servers, you'll want to keep it
			vim.api.nvim_clear_autocmds({
				group = augroup,
				buffer = bufnr,
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				-- command = "undojoin | LspFormatting",
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})

local unwrap = {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "rust" },
	generator = {
		fn = function(params)
			local diagnosticsU = {}
			-- sources have access to a params object
			-- containing info about the current file and editor state
			for i, line in ipairs(params.content) do
				local col, end_col = line:find("unwrap()")
				if col and end_col then
					-- null-ls fills in undefined positions
					-- and converts source diagnostics into the required format
					table.insert(diagnosticsU, {
						row = i,
						col = col,
						end_col = end_col,
						source = "unwrap",
						message = "hey " .. os.getenv("USER") .. ", don't forget to handle this",
						severity = 2,
					})
				end
			end
			return diagnosticsU
		end,
	},
}

null_ls.register(unwrap)
