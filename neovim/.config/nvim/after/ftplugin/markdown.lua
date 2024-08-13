local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = 0 }

-- search markdown links
map("n", "<Tab>", "<Cmd>call search('\\[[^]]*\\]([^)]\\+)')<CR>", opts)
map("n", "<S-Tab>", "<Cmd>call search('\\[[^]]*\\]([^)]\\+)', 'b')<CR>", opts)
