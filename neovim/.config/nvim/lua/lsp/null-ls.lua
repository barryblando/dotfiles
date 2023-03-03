local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
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

		-- Typescript, Javascript, React, Vue
		formatting.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file({
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					".eslintrc.json",
				})
			end,
		}),

		-- Lua
		formatting.stylua,

		-- Protocol Buffers
		formatting.buf,
    
    -- Go
    -- formatting.goimports,
    -- formatting.goimports_reviser,
    -- formatting.golines,

		-- null_ls.builtins.code_actions.refactoring,

		-- shell scripts
		-- diagnostics.shellcheck,
    
	},
  
  -- gitsigns integration
  code_actions.gitsigns,
})

local unwrap = {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "rust" },
	generator = {
		fn = function(params)
			local diagnostics = {}
			-- sources have access to a params object
			-- containing info about the current file and editor state
			for i, line in ipairs(params.content) do
				local col, end_col = line:find("unwrap()")
				if col and end_col then
					-- null-ls fills in undefined positions
					-- and converts source diagnostics into the required format
					table.insert(diagnostics, {
						row = i,
						col = col,
						end_col = end_col,
						source = "unwrap",
						message = "hey " .. os.getenv("USER") .. ", don't forget to handle this",
						severity = 2,
					})
				end
			end
			return diagnostics
		end,
	},
}

null_ls.register(unwrap)
