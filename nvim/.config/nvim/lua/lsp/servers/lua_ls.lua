local library = {}

local path = vim.split(package.path, ";")

-- this is the ONLY correct way to setup your path
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

local function add(lib)
	for _, p in pairs(vim.fn.expand(lib, false, true)) do
		p = vim.loop.fs_realpath(p)
		library[p] = true
	end
end

-- add runtime
add("$VIMRUNTIME")
add(vim.fn.expand("$VIMRUNTIME/lua"))
add(vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"))

-- add your config
add("~/.config/nvim")

-- add plugins
-- if you're not using packer, then you might need to change the paths below
-- add("~/.local/share/nvim/lazy/*")
add(vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy")

return {
	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/lua-language-server" },
	-- delete root from workspace to make sure we don't trigger duplicate warnings
	on_new_config = function(config, root)
		local libs = vim.tbl_deep_extend("force", {}, library)
		libs[root] = nil
		config.settings.Lua.workspace.library = libs
		return config
	end,
	settings = {
		Lua = {
			hint = { enable = true },
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = path,
			},
			completion = { callSnippet = "Both" },
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = library,
				maxPreload = 100000,
				preloadFileSize = 10000,
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = { enable = false },
		},
	},
}
