return {
	"karb94/neoscroll.nvim",
	config = function()
		local ok_satus, neoscroll = pcall(require, "neoscroll")

		if not ok_satus then
			return
		end

		neoscroll.setup({
			hide_cursor = true, -- Hide cursor while scrolling
			stop_eof = true, -- Stop at <EOF> when scrolling downwards
			respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
			cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
			easing_function = nil, -- Default easing function
			-- pre_hook = nil, -- Function to run before the scrolling animation starts
			-- post_hook = nil, -- Function to run after the scrolling animation ends
			pre_hook = function(info)
				if info == "cursorline" then
					vim.wo.cursorline = false
				end
			end,
			post_hook = function(info)
				if info == "cursorline" then
					vim.wo.cursorline = true
				end
			end,
			performance_mode = true, -- Disable "Performance Mode" on all buffers.
		})

		local t = {}

		-- Syntax: t[keys] = {function, {function arguments}}
		-- Use the "sine" easing function
		-- hide the cursorline only for <C-d>/<C-u>
		t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "350", "sine", [['cursorline']] } }
		t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "350", "sine", [['cursorline']] } }
		-- Use the "circular" easing function
		t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }
		t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }

		require("neoscroll.config").set_mappings(t)
	end,
}
