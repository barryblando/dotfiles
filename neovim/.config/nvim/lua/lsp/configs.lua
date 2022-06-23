local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local lspconfig = require("lspconfig")

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
}

lsp_installer.setup({
	ensure_installed = servers,
})

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("lsp.handlers").on_attach,
		capabilities = require("lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end
	lspconfig[server].setup(opts)
end
