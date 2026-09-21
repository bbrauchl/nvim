local M = {}

--[[
Bootstrap the lazy plugin
--]]
M.lazy = function()
  -- [[ Install `lazy.nvim` plugin manager ]]
  --    https://github.com/folke/lazy.nvim
  --    `:help lazy.nvim.txt` for more info
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.uv.fs_stat(lazypath) then
    local output = vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    }
    if vim.v.shell_error ~= 0 then error('Could not install lazy.nvim: ' .. output) end
  end
  vim.opt.rtp:prepend(lazypath)
end

return M
