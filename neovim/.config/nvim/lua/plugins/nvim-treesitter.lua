local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

local parsers = require("nvim-treesitter.parsers")
local enabled_list = {
  "bash",
  "lua",
  "rust",
  "go",
  "javascript",
  "typescript",
  "tsx",
  "graphql",
  "prisma",
  "proto",
  "css",
  "scss"
}

configs.setup {
  -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {
    "bash",
    "dockerfile",
    "lua",
    "rust",
    "go",
    "javascript",
    "typescript",
    "tsx",
    "graphql",
    "prisma",
    "http",
    "json",
    "make",
    "proto",
    "markdown",
    "html",
    "css",
    "scss",
    "yaml",
    "toml"
  },
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  autotag = {
    enable = true,
    filetypes = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "tsx",
      "jsx",
      "markdown"
    },
    skip_tags = {
      'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'slot',
      'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr','menuitem'
    }
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
    disable = vim.tbl_filter(
      function(p)
        local disable = true
        for _, lang in pairs(enabled_list) do
          if p==lang then disable = false end
        end
        return disable
      end,
      parsers.available_parsers()
    )
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
