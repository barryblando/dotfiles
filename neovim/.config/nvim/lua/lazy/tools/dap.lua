local icons = require("utils.icons")

for name, sign in pairs(icons.dap) do
	sign = type(sign) == "table" and sign or { sign }
	vim.fn.sign_define("Dap" .. name, {
    -- stylua: ignore
    text = sign[1] --[[@as string]] .. ' ',
		texthl = sign[2] or "DiagnosticInfo",
		linehl = sign[3],
		numhl = sign[3],
	})
end

-- Debugging.
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- Fancy UI for the debugger
			"nvim-neotest/nvim-nio",
			{
				"rcarriga/nvim-dap-ui",
				keys = {
					{
						"<leader>de",
						function()
							-- Calling this twice to open and jump into the window.
							require("dapui").eval()
							require("dapui").eval()
						end,
						desc = "[d]ebug [e]valuate expression",
						silent = true,
					},
				},
				opts = {
					icons = {
						collapsed = icons.arrows.right,
						current_frame = icons.arrows.right,
						expanded = icons.arrows.down,
					},
					floating = { border = icons.ui.Border_Single_Line },
					layouts = {
						{
							elements = {
								{ id = "stacks", size = 0.30 },
								{ id = "breakpoints", size = 0.20 },
								{ id = "scopes", size = 0.50 },
							},
							position = "left",
							size = 40,
						},
					},
				},
			},
			-- Virtual text.
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = { virt_text_pos = "eol" },
			},
			-- JS/TS DAP
			{
				"mxsdev/nvim-dap-vscode-js",
				enabled = false,
				opts = {
					debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
					adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
				},
			},
			{
				"microsoft/vscode-js-debug",
				enabled = false,
				build = "npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out",
			},
			-- Lua DAP
			{
				"jbyuki/one-small-step-for-vimkind",
				init = function()
					vim.api.nvim_create_autocmd({ "FileType" }, {
						pattern = { "lua" },
						callback = function()
							vim.schedule(function()
								vim.keymap.set("n", "<leader>da", function()
									vim.cmd('lua require("osv").launch({ port = 8086 })')
								end, { desc = "[d]ebug lua [a]dapter", silent = true })
							end)
						end,
					})
				end,
			},
		},
		keys = require("core.keymaps").setup_dap_keymaps(),
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Automatically open the UI when a new debug session is created.
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.attach["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.launch["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			-- Use overseer for running preLaunchTask and postDebugTask.
			require("overseer").patch_dap(true)
			require("dap.ext.vscode").json_decode = require("overseer.json").decode

			-- Lua configurations.
			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end
			dap.configurations["lua"] = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					-- Adjust this path!
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			-- RUST config
			dap.configurations.rust = {
				{
					name = "Debug",
					type = "codelldb",
					request = "launch",
					program = function()
						-- auto-detect binary, will debug crate’s binary without prompting you every time.
						return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
					runInTerminal = false,
				},
			}

			-- Add configurations from launch.json
			require("dap.ext.vscode").load_launchjs(nil, {
				["codelldb"] = { "rust" },
				["pwa-node"] = { "typescript", "javascript" },
			})
		end,
	},
}
