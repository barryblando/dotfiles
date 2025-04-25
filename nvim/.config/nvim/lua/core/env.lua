local M = {}

M.load_env = function(path)
	path = path or (vim.fn.stdpath("config") .. "/.env")
	local file = io.open(path, "r")
	if not file then
		return
	end

	for line in file:lines() do
		for key, value in string.gmatch(line, "([%w_]+)%s*=%s*(.+)") do
			vim.env[key] = value
		end
	end

	file:close()
end

return M
