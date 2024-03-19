local highlight = {
  'RainbowDelimiterRed',
  'RainbowDelimiterYellow',
  'RainbowDelimiterBlue',
  'RainbowDelimiterOrange',
  'RainbowDelimiterGreen',
  'RainbowDelimiterViolet',
  'RainbowDelimiterCyan',
}
-- local highlight = {
--       "RainbowRed",
--       "RainbowYellow",
--       "RainbowBlue",
--       "RainbowOrange",
--       "RainbowGreen",
--       "RainbowViolet",
--       "RainbowCyan",
-- }

local indent_blankline_config = {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  enabled = true,
  event = 'BufReadPre',
  main = 'ibl',
  config = function()
    local status_ibl, ibl = pcall(require, 'ibl')
    if not status_ibl then
      return
    end
    local status_hooks, hooks = pcall(require, 'ibl.hooks')
    if not status_hooks then
      return
    end

    -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    --     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    --     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    --     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    --     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    --     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    --     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    --     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    -- end)
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes

    ibl.setup {
      exclude = {
        filetypes = {
          'help',
          'terminal',
          'lazy',
          'lspinfo',
          'TelescopePrompt',
          'TelescopeResults',
          'mason',
          'nvdash',
          'nvcheatsheet',
          '',
        },
        buftypes = {
          'terminal',
        },
      },
      whitespace = {
        remove_blankline_trail = true,
      },
      scope = {
        enabled = true,
        highlight = highlight,
        show_start = true,
        show_end = true,
      },
      -- indentLine_enabled = 1,
      -- show_trailing_blankline_indent = false,
      -- show_first_indent_level = false,
      -- show_current_context = true,
    }

    vim.g.rainbow_delimiters = { highlight = highlight }
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}

return indent_blankline_config
