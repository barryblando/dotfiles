local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local mlsp_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mlsp_status_ok then
	return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local mdap_status_ok, mason_dap = pcall(require, "mason-nvim-dap")
if not mdap_status_ok then
	return
end

local icons = require("core.icons")

-- https://mason-registry.dev/registry/list
local mason_packages = {
	"stylua",
	"black",
	"isort",
	"prettier",
	"prettierd",
}

mason.setup({
	ensure_installed = mason_packages,
	ui = {
		border = icons.ui.Border_Single_Line,
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lsp_servers = {
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
	-- "ts_ls", -- will use typescript tools
	"templ",
	"terraformls",
	"taplo",
	"jsonls",
	"lua_ls",
	"marksman",
	"emmet_ls",
	"ansiblels",
	"eslint",
}

mason_lspconfig.setup({
	ensure_installed = lsp_servers,
	automatic_installation = true,
})

-- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
local dap_packages = {
	"codelldb",
	"node2",
	"delve",
}

mason_dap.setup({
	ensure_installed = dap_packages,
	automatic_installation = true,
})

local opts = {}

for _, server in pairs(lsp_servers) do
	opts = {
		on_attach = require("lsp.handlers").on_attach,
		capabilities = require("lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	if server == "rust_analyzer" then
		-- install rust_analyzer but we have to skip and let rustaceanvim configure rust lsp
		goto continue
	end

	local has_custom_opts, server_custom_opts = pcall(require, "lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end

	lspconfig[server].setup(opts)
	::continue::
end

require("lspconfig.ui.windows").default_options.border = icons.ui.Border_Single_Line
