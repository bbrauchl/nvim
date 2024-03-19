local rainbow_delimiters_config = {
  'hiphish/rainbow-delimiters.nvim',
  enabled = true,
  event = 'BufReadPre',
  config = function()
    local rainbow_delimiters = require 'rainbow-delimiters'
    require('rainbow-delimiters.setup').setup {
      strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }
  end,
}

return rainbow_delimiters_config
