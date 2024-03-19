local vscode_config = {
  'Mofiqul/vscode.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  opts = {
    -- Alternatively set style in setup
    style = 'dark',

    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
      -- vscLineNumber = '#FFFFFF',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    --group_overrides = {
    --  this supports the same val table as vim.api.nvim_set_hl
    --  use colors from this colorscheme by requiring vscode.colors!
    --  Cursor = {
    --    fg = require('vscode.colors').get_colors().vscDarkBlue,
    --    bg = require('vscode.colors').get_colors().vscLightGreen,
    --    bold = true,
    --  },
    --},
  },
  config = function(_, opts)
    require('vscode').setup(opts)
    require('vscode').load('dark')
  end,
}

return vscode_config
