
local my_on_attach = function(bufnr)
  local api = require('nvim-tree.api')

  local opts = {
    buffer = bufnr,
    noremap = true,
    silent = true,
    nowait = true,
  }

  api.config.mappings.default_on_attach(bufnr)

  -- require('utils').mappings.load_local_mappings(nvim_tree_mappings.on_attach, opts)
  require('utils').mappings.load_plugin_event_mappings('nvim-tree', 'on_attach', opts)
end

vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    local api = require('nvim-tree.api')

    -- Only 1 window with nvim-tree left: we probably closed a file buffer
    if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
      -- Required to let the close event complete. An error is thrown without this.
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last hidden buffer used before closing
        api.tree.toggle({find_file = true, focus = true})
        -- re-open nivm-tree
        api.tree.toggle({find_file = true, focus = true})
        -- nvim-tree is still the active window. Go to the previous window.
        vim.cmd("wincmd p")
      end, 0)
    end
  end
})

local nvim_tree_config = {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  opts = {
    sort_by = "case_sensitive",
    on_attach = my_on_attach,
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
  },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.opt.termguicolors = true

    local opts = {
      silent = true,
      nowait = true,
    }
    require('utils').mappings.load_plugin_general_mappings('nvim-tree', opts)
  end,
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}

return nvim_tree_config
