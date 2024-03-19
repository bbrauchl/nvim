-- Highlight todo, notes, etc in comments
local todo_comments_config = {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    signs = false,
  },
}

return todo_comments_config
