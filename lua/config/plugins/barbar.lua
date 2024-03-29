
-- Automatically close buffer to make it dissapear from bar when :q is ran
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function(tbl)

    require('barbar.bbye').bdelete(tbl.bang, tbl.args, tbl.smods or tbl.mods)
    -- require('barbar.bbye').delete('bdelete', false, tbl.buf)
  end,
  group = vim.api.nvim_create_augroup('barbar_close_buf', {})
})

local barbar_config = {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    -- animation = true,
    -- insert_at_start = true,
    -- …etc.
  },
  config = function(_, opts)
    require('barbar').setup(opts)
    require('utils').mappings.load_plugin_general_mappings('barbar')
  end,
}

return barbar_config
