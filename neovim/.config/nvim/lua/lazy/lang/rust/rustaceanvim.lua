return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	ft = { "rust" },
	config = function()
		local icons = require("utils.icons")
		vim.g.rustaceanvim = {
			tools = {
				float_win_config = {
					border = icons.ui.Border_Single_Line,
				},
				autoSetHints = true,
				hover_actions = {
					auto_focus = true,
				},
			},
			server = {
				on_attach = function(_, bufnr)
					require("core.keymaps").setup_lsp_keymaps(bufnr)
					-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							runBuildScripts = true,
						},
						-- Add clippy lints for Rust.
						checkOnSave = true,
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
						diagnostics = {
							enable = true,
							experimental = {
								enable = true,
							},
						},
						inlayHints = {
							lifetimeElisionHints = {
								enable = true,
								useParameterNames = true,
							},
							bindingModeHints = {
								enable = true,
							},
							parameterHints = {
								enable = true,
							},
							typeHints = {
								enable = true,
							},
							chainingHints = {
								enable = true,
							},
							closingBraceHints = {
								enable = true,
							},
						},
					},
				},
			},
			dap = {
				-- Enable dap integration
				adapter = require("rustaceanvim.config").get_codelldb_adapter(
					vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
					vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
				),
			},
		}
	end,
}
