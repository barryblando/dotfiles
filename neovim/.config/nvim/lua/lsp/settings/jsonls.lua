local status_ok, schemastore = pcall(require, "schemastore")

if not status_ok then
	return
end

return {
	init_options = {
		provideformatter = false,
	},
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
		},
	},
	setup = {
		commands = {
			-- format = {
			--   function()
			--     vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
			--   end,
			-- },
		},
	},
}
