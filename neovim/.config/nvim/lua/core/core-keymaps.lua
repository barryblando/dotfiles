local opts = { noremap = true, silent = true }

-- local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Escape and save changes.
vim.keymap.set({ "s", "i", "n", "v" }, "<C-s>", "<esc>:w<cr>", { desc = "Exit insert mode and save changes." })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
keymap(
	"n",
	"<C-c>",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- Open the package manager.
keymap("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Normal --

-- Switch between windows.
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to the left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to the bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to the top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to the right window" })

-- jump
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers (commented for cybu)
--[[ keymap("n", "<S-l>", ":bnext<CR>", opts) ]]
--[[ keymap("n", "<S-h>", ":bprevious<CR>", opts) ]]

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "jk", "<ESC>", opts)
keymap("i", "<C-c>", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
-- Paste
keymap("x", "<leader>p", '"_dP', opts)

-- Yank with clipboard --
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank Text with Clipboard" })
-- vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank Line with Clipboard" })

-- replace
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace" })
