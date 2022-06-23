local ok_status, luadev = pcall(require, "lua-dev")

if not ok_status then
	return
end

return luadev.setup({})
