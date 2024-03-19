local M = {}

M.load = function(leader)
  M.set_leader(leader)
  M.load_options()
end

M.load_config = function()
  require 'config.vimrc'
end

M.load_autocommands = function()
  require 'config.autocommands'
end

M.set_leader = function(leader)
  vim.g.mapleader = leader
  vim.g.maplocalleader = leader
end

return M
