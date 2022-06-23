local util = require("lspconfig").util

return {
	-- denols will only resolve projects with the ff patterns
	root_dir = util.root_pattern("deno.json", "deno.jsonc"),
}
