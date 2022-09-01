local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local mlsp_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mlsp_status_ok then
	return
end

local servers = {
	"bashls",
	"denols",
	"dockerls",
	"html",
	"gopls",
	"graphql",
	"prismals",
	"rust_analyzer",
	"tailwindcss",
	"yamlls",
	"cssls",
	"tsserver",
	"terraformls",
	"taplo",
	"jsonls",
	"sumneko_lua",
	"marksman",
	"emmet_ls",
	"ansiblels",
	"eslint",
	"rust_analyzer",
}

local settings = {
	ui = {
		border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("lsp.handlers").on_attach,
		capabilities = require("lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	if server == "sumneko_lua" then
		local l_status_ok, lua_dev = pcall(require, "lua-dev")
		if not l_status_ok then
			return
		end
		-- local sumneko_opts = require "lsp.settings.sumneko_lua"
		-- opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
		-- opts = vim.tbl_deep_extend("force", require("lua-dev").setup(), opts)
		local luadev = lua_dev.setup({
			--   -- add any options here, or leave empty to use the default settings
			-- lspconfig = opts,
			lspconfig = {
				on_attach = opts.on_attach,
				capabilities = opts.capabilities,
				-- settings = opts.settings,
			},
		})
		lspconfig.sumneko_lua.setup(luadev)
		goto continue
	end

	if server == "rust_analyzer" then
		local rust_opts = require("lsp.settings.rust_analyzer")
		-- opts = vim.tbl_deep_extend("force", rust_opts, opts)
		local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
		if not rust_tools_status_ok then
			return
		end

		rust_tools.setup(rust_opts)
		goto continue
	end

	local has_custom_opts, server_custom_opts = pcall(require, "lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end

	lspconfig[server].setup(opts)
	::continue::
end

require("lspconfig.ui.windows").default_options.border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" }
