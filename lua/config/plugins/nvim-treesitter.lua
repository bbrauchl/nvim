return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'
    ts.setup {}
    ts.install { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
    local function attach(buf, language)
      if not vim.api.nvim_buf_is_valid(buf) then return end
      if vim.treesitter.language.get_lang(vim.bo[buf].filetype) ~= language then return end
      local ok, loaded = pcall(vim.treesitter.language.add, language)
      if not ok or not loaded then return end
      vim.treesitter.start(buf, language)
      if language ~= 'ruby' and vim.treesitter.query.get(language, 'indents') then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
    end
    local available = ts.get_available()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
      callback = function(event)
        local language = vim.treesitter.language.get_lang(event.match)
        if not language then return end
        if vim.tbl_contains(ts.get_installed 'parsers', language) then
          attach(event.buf, language)
        elseif vim.tbl_contains(available, language) then
          ts.install(language):await(function() attach(event.buf, language) end)
        else
          attach(event.buf, language)
        end
      end,
    })
  end,
}
