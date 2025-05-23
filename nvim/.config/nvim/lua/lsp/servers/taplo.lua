local util = require("lspconfig.util")

return {
	filetypes = { "toml" },
	root_dir = util.root_pattern(".git"),
}
