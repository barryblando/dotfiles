local ok_status, colorizer = pcall(require, "colorizer")

if not ok_status then
	return
end

colorizer.setup({
	-- Highlight all files
	"*",
})
