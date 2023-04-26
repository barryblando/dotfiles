return {
  "karb94/neoscroll.nvim",
  enabled = false,
  config = function ()
    local ok_satus, neoscroll = pcall(require, "neoscroll")

    if not ok_satus then
      return
    end
    
    neoscroll.setup({
      easing_function = nil,
    })

    local t = {}

    -- Syntax: t[keys] = {function, {function arguments}}
    -- Use the "sine" easing function
    t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "350", [['sine']] } }
    t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "350", [['sine']] } }
    -- Use the "circular" easing function
    t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }
    t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }

    require("neoscroll.config").set_mappings(t)
  end
}
