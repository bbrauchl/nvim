-- Based on Kickstart 80743df53d8f7058fc5b60e41f1081d11df9c880.
-- Keep the modular configuration and custom completion/keybindings.
if vim.fn.has 'nvim-0.12' == 0 then error 'This configuration requires Neovim 0.12 or newer' end

require('utils').vimrc.set_leader ' '
require('utils').vimrc.load_config()
require('utils').mappings.load_general_mappings()

if vim.g.vscode then return end

require('utils').bootstrap.lazy()
require('utils').vimrc.load_autocommands()
require('lazy').setup({ import = 'config.plugins' }, require 'config.lazy')
