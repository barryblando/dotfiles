return {}
-- Easy motion. Crazy fast jumping cursor
-- ALT - https://github.com/ggandor/leap.nvim
-- return {
-- 	"smoka7/hop.nvim",
-- 	tag = "*", -- optional but strongly recommended
-- 	config = function()
-- 		local status_ok, hop = pcall(require, "hop")

-- 		if not status_ok then
-- 			return
-- 		end

-- 		hop.setup()

-- 		local opts = { noremap = true, silent = true }
-- 		local keymap = vim.api.nvim_set_keymap
-- 		-- nvim_set_keymap api doesn't allow function as argument, so back using vim keymap for vim schedule
-- 		local vKeymap = vim.keymap.set

-- 		keymap("", "S", ":HopWord<cr>", { silent = true })

-- 		-- NOTE: Hop to create blank lines with vim schedule
-- 		vKeymap("n", "vo", function()
-- 			vim.cmd([[:HopLineStart]])
-- 			vim.schedule(function()
-- 				vim.cmd([[normal! o]])
-- 				vim.cmd([[normal! o]])
-- 				vim.cmd([[startinsert]])
-- 			end)
-- 		end, opts)

-- 		vKeymap("n", "vO", function()
-- 			vim.cmd([[:HopLineStart]])
-- 			vim.schedule(function()
-- 				vim.cmd([[normal! O]])
-- 				vim.cmd([[normal! O]])
-- 				vim.cmd([[startinsert]])
-- 			end)
-- 		end, opts)
-- 	end,
-- }
