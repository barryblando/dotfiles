return{
  "nvim-treesitter/nvim-treesitter",
  build = function ()
    pcall(require('nvim-treesitter.install').update { with_sync = true })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function ()

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
        "toml",
        "query"
      },
      sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
      ignore_install = { "" }, -- List of parsers to ignore installing
      autopairs = {
        enable = true,
      },
      autotag = {
        enable = true,
        filetypes = {
          'css',
          'html',
          'jsx',
          'javascript',
          'javascriptreact',
          'markdown',
          'svelte',
          'typescript',
          'typescriptreact',
          'vue',
          'xhtml',
          'xml',
        },
        skip_tags = {
          'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'slot',
          'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr','menuitem'
        }
      },
      highlight = {
        enable = true, -- false will disable the whole extension
        -- disable for big files
        disable = {
          function(_, bufnr)
            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            local file_size = vim.api.nvim_call_function('getfsize', { buf_name })
            return file_size > 256 * 1024
          end,
          'latex',
        },
        additional_vim_regex_highlighting = true,
      },
      rainbow = {
        enable = true,
        extended_mode = false,
        additional_vim_regex_highlighting = false,
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
      -- playground = {
      --   enable = true,
      -- },
      indent = { enable = true, disable = { "yaml" } },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["at"] = "@class.outer",
            ["it"] = "@class.inner",
            ["ac"] = "@call.outer",
            ["ic"] = "@call.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["a/"] = "@comment.outer",
            ["i/"] = "@comment.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["as"] = "@statement.outer",
            ["is"] = "@scopename.inner",
            ["aA"] = "@attribute.outer",
            ["iA"] = "@attribute.inner",
            ["aF"] = "@frame.outer",
            ["iF"] = "@frame.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>."] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>,"] = "@parameter.inner",
          },
        },
      },
    }
  end,
}
