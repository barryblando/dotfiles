-- local mlsp_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
-- if not mlsp_status_ok then
-- 	return
-- end

-- local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
-- if not lspconfig_status_ok then
-- 	return
-- end

-- local mdap_status_ok, mason_dap = pcall(require, "mason-nvim-dap")
-- if not mdap_status_ok then
-- 	return
-- end

-- Ensure packages are installed and up to date
-- registry.refresh(function()
-- 	for _, name in pairs(ensure_installed) do
-- 		local package = registry.get_package(name)
-- 		if not registry.is_installed(name) then
-- 			package:install()
-- 		else
-- 			package:check_new_version(function(success, result_or_err)
-- 				if success then
-- 					package:install({ version = result_or_err.latest_version })
-- 				end
-- 			end)
-- 		end
-- 	end
-- end)

-- mason_lspconfig.setup({
-- 	ensure_installed = lsp_servers,
-- 	automatic_installation = true,
-- })

-- mason_dap.setup({
-- 	ensure_installed = dap_extensions,
-- 	automatic_installation = true,
-- })

-- server = vim.split(server, "@")[1]

-- lspconfig[server].setup(opts)

-- require("lspconfig.ui.windows").default_options.border = icons.ui.Border_Single_Line
