local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local mason_installer_ok, mason_installer = pcall(require, "mason-tool-installer")
if not mason_installer_ok then
	return
end

local icons = require("core.icons")
local utils = require("core.utils")

mason.setup({
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

-- https://mason-registry.dev/registry/list
local linters_formatters_registry = {
	{ "stylua", "stylua" },
	{ "black", "black" },
	{ "isort", "isort" },
	{ "prettier", "prettier" },
	{ "prettierd", "prettierd" },
	{ "shfmt", "shfmt" },
	{ "shellcheck", "shellcheck" },
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local servers_registry = {
  -- stylua: ignore start
  -- turn off/on auto_update per tool, conditional installing, and version
	-- { "bashls", { "bash-language-server", auto_update = true, version = 'v1.(what version)' } },
	-- { "gopls", { "gopls", condition = function() return not os.execute("go version") end },},
	{ "bashls", "bash-language-server" },
	{ "denols", "deno" },
	{ "dockerls", "dockerfile-language-server" },
	{ "html", "html-lsp" },
	{ "gopls", "gopls" },
	{ "graphql", "graphql-language-service-cli" },
	{ "prismals", "prisma-language-server" },
	{ "rust_analyzer", "rust-analyzer" },
	{ "tailwindcss", "tailwindcss-language-server" },
	{ "yamlls", "yaml-language-server" },
	{ "cssls", "css-lsp" },
	{ "ts_ls", "typescript-language-server" },
	{ "templ", "templ" },
	{ "terraformls", "terraform-ls" },
	{ "taplo", "taplo" },
	{ "jsonls", "json-lsp" },
	{ "lua_ls", "lua-language-server" },
	{ "marksman", "marksman" },
	{ "emmet_ls", "emmet-ls" },
	{ "ansiblels", "ansible-language-server" },
	{ "eslint", "eslint-lsp" },
	-- stylua: ignore end
}

-- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
local dap_registry = {
	{ "codelldb", "codelldb" },
	{ "delve", "delve" },
	{ "js", "js-debug-adapter" },
}

local linters_formatters = utils.extract_mason_packages(linters_formatters_registry)
local servers = utils.extract_mason_packages(servers_registry)
local dap_extensions = utils.extract_mason_packages(dap_registry)

local ensure_installed = utils.merge_lists(linters_formatters, servers, dap_extensions)

-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
mason_installer.setup({
	ensure_installed = ensure_installed,
	auto_update = true,
	run_on_start = true,
})

local lsp_servers = utils.extract_lsp_packages(servers_registry)

local opts = {}

for _, server in pairs(lsp_servers) do
	opts = {
		on_attach = require("lsp.handlers").on_attach,
		capabilities = require("lsp.handlers").capabilities,
	}

	if server == "rust_analyzer" then
		-- install rust_analyzer but we have to skip and let rustaceanvim configure rust lsp
		goto continue
	end

	local has_custom_opts, server_custom_opts = pcall(require, "lsp.servers." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end

	vim.lsp.config(server, opts)
	vim.lsp.enable(server)
	::continue::
end
