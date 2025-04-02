M = {}

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

-- Yanky keymaps

function M.setup_yanky_keymaps()
	return {
		{ "<leader>p", "<cmd>YankyRingHistory<cr>", mode = { "n", "x" }, desc = "Open Yank History" },
		{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
		{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
		{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
		{ "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
		{ "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
		{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
		{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
		{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
		{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
		{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
		{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
		{ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
		{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
		{ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
		{ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
	}
end

-- DAP Keymaps
function M.setup_dap_keymaps()
	return {
		{
			-- "<leader>db",
			".",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "[d]ebug toggle [b]reakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "[d]ebug [B]reakpoint",
		},
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug | Continue (start here)",
		},
		{
			"<F6>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug | Step Into",
		},
		{
			"<F7>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug | Step Over",
		},
		{
			"<F8>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug | Step Out",
		},
		{
			"<F9>",
			function()
				require("dap").step_back()
			end,
			desc = "Debug | Step Back",
		},
		{
			"<F10>",
			function()
				require("dap").restart()
			end,
			desc = "Debug | Restart",
		},
		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "[d]ebug [C]ursor",
		},
		{
			"<leader>dg",
			function()
				require("dap").goto_()
			end,
			desc = "[d]ebug [g]o to line",
		},
		{
			"<leader>dj",
			function()
				require("dap").down()
			end,
			desc = "[d]ebug [j]ump down",
		},
		{
			"<leader>dk",
			function()
				require("dap").up()
			end,
			desc = "[d]ebug [k]ump up",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "[d]ebug [l]ast",
		},
		{
			"<leader>dp",
			function()
				require("dap").pause()
			end,
			desc = "[d]ebug [p]ause",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "[d]ebug [r]epl",
		},
		{
			"<leader>dc",
			function()
				require("dap").clear_breakpoints()
			end,
			desc = "[d]ebug [c]lear breakpoints",
		},
		{
			"<leader>ds",
			function()
				require("dap").session()
			end,
			desc = "[d]ebug [s]ession",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "[d]ebug [t]erminate",
		},
		{
			"<leader>du",
			"<cmd>lua require'dapui'.toggle()<cr>",
			desc = "[d]ebug [u]i",
			silent = true,
		},
		{
			"<leader>dw",
			function()
				-- require("dap.ui.widgets").hover()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end,
			desc = "[d]ebug [w]idgets",
		},
	}
end

function M.setup_toggleterm_keymaps()
	return {
		{ "<leader>t1", ":1ToggleTerm<cr>", desc = "1", nowait = true, remap = false },
		{ "<leader>t2", ":2ToggleTerm<cr>", desc = "2", nowait = true, remap = false },
		{ "<leader>t3", ":3ToggleTerm<cr>", desc = "3", nowait = true, remap = false },
		{ "<leader>t4", ":4ToggleTerm<cr>", desc = "4", nowait = true, remap = false },
		{ "<leader>tb", "<cmd>lua _BTOP_TOGGLE()<cr>", desc = "Btop", nowait = true, remap = false },
		{ "<leader>td", "<cmd>lua _LAZYDOCKER_TOGGLE()<cr>", desc = "Docker", nowait = true, remap = false },
		{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float", nowait = true, remap = false },
		{ "<leader>tg", "<cmd>lua _GDU_TOGGLE()<cr>", desc = "GDU", nowait = true, remap = false },
		{
			"<leader>th",
			"<cmd>ToggleTerm size=10 direction=horizontal<cr>",
			desc = "Horizontal",
			nowait = true,
			remap = false,
		},
		{ "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node", nowait = true, remap = false },
		{ "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python", nowait = true, remap = false },
		{
			"<leader>tv",
			"<cmd>ToggleTerm size=80 direction=vertical<cr>",
			desc = "Vertical",
			nowait = true,
			remap = false,
		},
	}
end

function M.setup_gitsigns_keymaps()
	return {
		{
			"<leader>gR",
			"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
			desc = "Reset Buffer",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gb",
			"<cmd>Telescope git_branches<cr>",
			desc = "Checkout branch",
			nowait = true,
			remap = false,
		},
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit", nowait = true, remap = false },
		{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", nowait = true, remap = false },
		{ "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit", nowait = true, remap = false },
		{
			"<leader>gj",
			"<cmd>lua require 'gitsigns'.next_hunk()<cr>",
			desc = "Next Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gk",
			"<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
			desc = "Prev Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gl",
			"<cmd>lua require 'gitsigns'.blame_line()<cr>",
			desc = "Blame",
			nowait = true,
			remap = false,
		},
		{
			"<leader>go",
			"<cmd>Telescope git_status<cr>",
			desc = "Open changed file",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gp",
			"<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
			desc = "Preview Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gr",
			"<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
			desc = "Reset Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gs",
			"<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
			desc = "Stage Hunk",
			nowait = true,
			remap = false,
		},
		{
			"<leader>gu",
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			desc = "Undo Stage Hunk",
			nowait = true,
			remap = false,
		},
	}
end

function M.setup_telescope_keymaps()
	return {
		{ "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = true, remap = false },
		{ "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights", nowait = true, remap = false },
		{ "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", nowait = true, remap = false },
		{ "<leader>fr", "<cmd>Telescope registers<cr>", desc = "Registers", nowait = true, remap = false },
		{
			"<leader>fb",
			"<cmd>Telescope git_branches<cr>",
			desc = "Checkout branch",
			nowait = true,
			remap = false,
		},
		{ "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme", nowait = true, remap = false },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files", nowait = true, remap = false },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help", nowait = true, remap = false },
		{
			"<leader>fi",
			"<cmd>lua require('telescope').extensions.media_files.media_files()<cr>",
			desc = "Media",
			nowait = true,
			remap = false,
		},
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
		{ "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Last Search", nowait = true, remap = false },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File", nowait = true, remap = false },
		{ "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Find String", nowait = true, remap = false },
		{ "<leader>ft", "<cmd>Telescope live_grep<cr>", desc = "Find Text", nowait = true, remap = false },
	}
end

function M.setup_harpoon_keymaps()
	return {
		{
			"m,",
			'<cmd>lua require("harpoon"):list():prev()<cr>',
			desc = "Harpoon Prev",
			nowait = true,
			remap = false,
		},
		{
			"m.",
			'<cmd>lua require("harpoon"):list():next()<cr>',
			desc = "Harpoon Next",
			nowait = true,
			remap = false,
		},
		{ "m;", "<cmd>HarpoonUI<cr>", desc = "Harpoon UI", nowait = true, remap = false },
		{ "mm", '<cmd>lua require("harpoon"):list():add()<cr>', desc = "Harpoon", nowait = true, remap = false },
	}
end

return M
