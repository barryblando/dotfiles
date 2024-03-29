return {
  "filipdutescu/renamer.nvim",
  enabled = false,
  branch = "master",
  keys = {
    { "<F2>", '<cmd>lua require("renamer").rename()<cr>', mode = "i" },
    { "<F2>", '<cmd>lua require("renamer").rename()<cr>', mode = "n" },
    { "<F2>", '<cmd>lua require("renamer").rename()<cr>', mode = "v" },
  },
  config = function ()
    local status_ok, renamer = pcall(require, "renamer")

    if not status_ok then
      return
    end

    renamer.setup {
      -- The popup title, shown if `border` is true
      title = 'Rename',
      -- The padding around the popup content
      padding = {
        top = 0,
        left = 0,
        bottom = 0,
        right = 0,
      },
      -- The minimum width of the popup
      min_width = 15,
      -- The maximum width of the popup
      max_width = 45,
      -- Whether or not to shown a border around the popup
      border = true,
      -- The characters which make up the border
      border_chars = { "━", "┃", "━", "┃", "┏" , "┓", "┛", "┗"  },
      -- Whether or not to highlight the current word references through LSP
      show_refs = true,
      -- Whether or not to add resulting changes to the quickfix list
      with_qf_list = true,
      -- Whether or not to enter the new name through the UI or Neovim's `input`
      -- prompt
      with_popup = true,
      -- Custom handler to be run after successfully renaming the word. Receives
      -- the LSP 'textDocument/rename' raw response as its parameter.
      handler = nil,
    }

    -- vim.api.nvim_set_keymap('i', '<F2>', '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap('n', '<F2>', '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap('v', '<F2>', '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
  end
}
