--[[

Create a unified way to set keymaps in a more general way.

--]]
local M = {}

M.general_mappings = {
  i = {
    ["<A-h>"] = { "<Left>", "Move left" },
    ["<A-l>"] = {
      "<Right>",
      ":set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<Move right"
    },
    ["<A-j>"] = { "<Down>", "Move down" },
    ["<A-k>"] = { "<Up>", "Move up" },
  },


  n = {
    -- [[ Misc/ease-of-use keymaps ]]
    [';'] = { ':', 'enter command mode', opts = { nowait = true }},
    ["<Esc>"] = { "<cmd> noh <CR>", "Clear highlights" },
    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },


    -- [[ Diagnostic keymaps ]]
    ['[d'] = {
      vim.diagnostic.goto_prev,
      opts = { desc = 'Go to previous diagnostic message' }
    },
    [']d'] = {
      vim.diagnostic.goto_next,
      opts = { desc = 'Go to next diagnostic message' }
    },
    ['<leader>e'] = {
      vim.diagnostic.open_float,
      opts = { desc = 'Open floating diagnostic message' }
    },
    ['<leader>q'] = {
      vim.diagnostic.setloclist,
      opts = { desc = 'Open diagnostics list' }
    },


    -- [[ File Operation Keybinds ]]
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },
    ["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },


    -- [[ Navigation Keymaps ]]
    -- switch between windows
    ["<A-h>"] = { "<C-w>h", "Window left" },
    ["<A-l>"] = { "<C-w>l", "Window right" },
    ["<A-j>"] = { "<C-w>j", "Window down" },
    ["<A-k>"] = { "<C-w>k", "Window up" },

    ["<A-o>"] = { "<C-o>", "Go Back" },
    ["<A-i>"] = { "<C-i>", "Go Back" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter
    -- d, y or c behaviour
    ["j"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      "Move down",
      opts = { expr = true }
    },
    ["k"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      "Move up",
      opts = { expr = true }
    },
    ["<Up>"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      "Move up",
      opts = { expr = true }
    },
    ["<Down>"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      "Move down",
      opts = { expr = true }
    },

    -- new buffer
    ["<leader>bn"] = { "<cmd> enew <CR>", "New buffer" },
    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },
  },


  t = {
    ["<A-x>"] = {
      vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
      "Escape terminal mode"
    },
  },
  v = {
    ["<Space>"] = { "<Nop>", opts = { silent = true }},
    ["<Up>"]    = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up",
      opts = { expr = true }
    },
    ["<Down>"]  = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      "Move down",
      opts = { expr = true }
    },
    ['>'] = { '>gv', 'Increase Block Indent'},
    ['<'] = { '<gv', 'Decrease Block Indent'},
  },
  x = {
    ["j"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      "Move down",
      opts = { expr = true }
    },
    ["k"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      "Move up",
      opts = { expr = true }
    },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = {
      'p:let @+=@0<CR>:let @"=@0<CR>',
      "Dont copy replaced text",
      opts = { silent = true }
    },
  },
}

M.plugin_mappings = {
  -- [[ Configuration for nvim-tree ]]
  ['nvim-tree'] = {
    general = {
      n = {
        -- toggle
        ["<A-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

        -- focus
        ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
      },
    },
    events = {
      on_attach = {
        n = {
          ['<A-u>'] = {
            function()
              require('nvim-tree.api').tree.change_root_to_parent()
            end,
            "nvim-tree: Parent Directory"
          },
          ['<A-o>'] = {
            function()
              require('nvim-tree.api').tree.change_root_to_node()
            end,
            "nvim-tree: Change Directory"
          },
          ['<A-[>'] = {
            function()
              require('nvim-tree.api').tree.change_root_to_node()
            end,
            "nvim-tree: Change Directory"
          },
        },
      },
    },
  },

  -- [[ Configuration for the nvim-lspconfig Plugin ]]
  nvim_lspconfig = {
    general = {
      n = {
        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        ['gd'] = {
          function() require('telescope.builtin').lsp_definitions() end,
          'LSP: [G]oto [D]efinition',
        },
        -- Find references for the word under your cursor.
        ['gr'] = {
          function() require('telescope.builtin').lsp_references() end,
          '[LSP: G]oto [R]eferences',
        },
        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        ['gI'] = {
          function() require('telescope.builtin').lsp_implementations() end,
          'LSP: [G]oto [I]mplementation',
        },
        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        ['<leader>D'] = {
          function() require('telescope.builtin').lsp_type_definitions() end,
          'LSP: Type [D]efinition',
        },
        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        ['<leader>ds'] = {
          function() require('telescope.builtin').lsp_document_symbols() end,
          'LSP: [D]ocument [S]ymbols',
        },
        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        ['<leader>ws'] = {
          function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
          'LSP: [W]orkspace [S]ymbols',
        },
        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        ['<leader>rn'] = {
          function() vim.lsp.buf.rename() end,
          'LSP: [R]e[n]ame',
        },
        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        ['<leader>ca'] = {
          function() vim.lsp.buf.code_action() end,
          'LSP: [C]ode [A]ction',
        },
        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        ['K'] = {
          function() vim.lsp.buf.hover() end,
          'LSP: Hover Documentation',
        },
        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        ['gD'] = {
          function() vim.lsp.buf.declaration() end,
          'LSP: [G]oto [D]eclaration',
        },
      },
    },
  },


  -- [[ Configuration for Telescope Plugin ]]
  telescope = {
    general = {
      n = {
        ['<A-n>'] = {
          function()
            require('telescope').extensions.file_browser.file_browser({
              initial_mode = 'normal',
            })
          end,
          'Open File Browser'
        },

        -- See `:help telescope.builtin`
        ['<leader>/'] = {
          function() require('telescope.builtin').current_buffer_fuzzy_find() end,
          'Fuzzy Find'
        },
        ['<C-f>'] = {
          function() require('telescope.builtin').current_buffer_fuzzy_find() end,
          'Fuzzy Find'
        },
        ['<leader>fr'] = {
          function() require('telescope.builtin').oldfiles() end,
          '[F]ind [R]ecent Files'
        },
        ['<leader>fb'] = {
          function() require('telescope.builtin').buffers() end,
          '[F]ind Existing [B]uffers'
        },
        ['<leader>ff'] = {
          function() require('telescope.builtin').find_files() end,
          '[F]ind [F]iles'
        },
        ['<leader>fh'] = {
          function() require('telescope.builtin').help_tags() end,
          '[F]ind [H]elp'
        },
        ['<leader>fw'] = {
          function() require('telescope.builtin').grep_string() end,
          '[F]ind current [W]ord'
        },
        ['<leader>fG'] = {
          function() require('telescope.builtin').git_files() end,
          '[F]ind [G]it files'
        },
        ['<leader>fg'] = {
          function() require('telescope.builtin').live_grep() end,
          '[F]ind by [G]rep'
        },
        ['<leader>fR'] = {
          function() end, -- todo implement this
          '[F]ind by grep on Git [R]oot'
        },
        ['<leader>fd'] = {
          function() require('telescope.builtin').diagnostics() end,
          '[F]ind [D]iagnostics'
        },
        ['<leader>f<space>'] = {
          function() require('telescope.builtin').resume() end,
          '[F]ind Resume'
        },
        ['<leader>fc'] = {
          function() require('telescope.builtin').colorscheme() end,
          '[F]ind [C]olorscheme'
        },
        ['<leader>fp'] = {
          function() require('telescope.builtin').builtin() end,
          '[F]ind [P]icker'
        },
        ['<leader>ft'] = {
          function() require('telescope.builtin').treesitter() end,
          '[F]ind in [T]reesitter'
        },

        -- [[ LSP related search ]]
        ['<leader>flr'] = {
          function() require('telescope.builtin').lsp_references() end,
          '[F]ind [L]sp [R]eferences'
        },
        ['<leader>fld'] = {
          function() require('telescope.builtin').lsp_definitions() end,
          '[F]ind [L]sp [D]efinitions'
        },
        ['<leader>fli'] = {
          function() require('telescope.builtin').lsp_incoming_calls() end,
          '[F]ind [L]sp [I]ncoming Calls'
        },
        ['<leader>flo'] = {
          function() require('telescope.builtin').lsp_definitions() end,
          '[F]ind [L]sp [O]utgoing Calls'
        },
        ['<leader>flm'] = {
          function() require('telescope.builtin').lsp_implementations() end,
          '[F]ind [L]sp I[M]plementations'
        },
        ['<leader>fls'] = {
          function() require('telescope.builtin').lsp_document_symbols() end,
          '[F]ind [L]sp [S]ymbols ([D]ocuent)'
        },
        ['<leader>flw'] = {
          function() require('telescope.builtin').lsp_workspace_symbols() end,
          '[F]ind [L]sp Symbols ([W]orksapce)'
        },
        ['<leader>fla'] = {
          function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
          '[F]ind [L]sp Symbols ([A]ll)'
        },
        ['<leader>flt'] = {
          function() require('telescope.builtin').lsp_type_definitions() end,
          '[F]ind [L]sp [T]ype Definitions'
        },
      },
    },
    events = {
      file_browser_attach = {
        n = {
          o = {
            function() require('telescope').extensions.file_browser.actions.change_cwd() end,
            'open folder'
          },
        },
      },
    },
  },

  -- [[ barbar plugin keybinds ]]
  barbar = {
    general = {
      n = {
        ['<A-,>'] = {
          '<cmd>BufferPrevious<cr>',
          'Previous Buffer',
          opts = { noremap = true, silent = true }
        },
        ['<A-.>'] = {
          '<cmd>BufferNext<cr>',
          'Next Buffer',
          opts = { noremap = true, silent = true }
        },
        ['<A-1>'] = {
          '<cmd>BufferGoTo 1<cr>',
          'Buffer 1',
          opts = { noremap = true, silent = true }
        },
        ['<A-2>'] = {
          '<cmd>BufferGoTo 2<cr>',
          'Buffer 2',
          opts = { noremap = true, silent = true }
        },
        ['<A-3>'] = {
          '<cmd>BufferGoTo 3<cr>',
          'Buffer 3',
          opts = { noremap = true, silent = true }
        },
        ['<A-4>'] = {
          '<cmd>BufferGoTo 4<cr>',
          'Buffer 4',
          opts = { noremap = true, silent = true }
        },
        ['<A-5>'] = {
          '<cmd>BufferGoTo 5<cr>',
          'Buffer 5',
          opts = { noremap = true, silent = true }
        },
        ['<A-6>'] = {
          '<cmd>BufferGoTo 6<cr>',
          'Buffer 6',
          opts = { noremap = true, silent = true }
        },
        ['<A-7>'] = {
          '<cmd>BufferGoTo 7<cr>',
          'Buffer 7',
          opts = { noremap = true, silent = true }
        },
        ['<A-8>'] = {
          '<cmd>BufferGoTo 8<cr>',
          'Buffer 8',
          opts = { noremap = true, silent = true }
        },
        ['<A-9>'] = {
          '<cmd>BufferGoTo 9<cr>',
          'Buffer 9',
          opts = { noremap = true, silent = true }
        },
        ['<A-0>'] = {
          '<cmd>BufferLast<cr>',
          'Last Buffer',
          opts = { noremap = true, silent = true }
        },
        ['<A-p>'] = {
          '<cmd>BufferPin<cr>',
          'Toggle Pin Buffer',
          opts = { noremap = true, silent = true }
        },
        ['<A-x>'] = {
          '<cmd>BufferClose<cr>',
          'Close Buffer',
          opts = { noremap = true, silent = true }
        },
        ['<C-p>'] = {
          '<cmd>BufferPick<cr>',
          'Pick Buffer',
          opts = { noremap = true, silent = true }
        },
        ['<leader>bb'] = {
          '<cmd>BufferOrderByBufferNumber<cr>',
          'Sort Buffers By Number',
          opts = { noremap = true, silent = true }
        },
        ['<leader>bd'] = {
          '<cmd>BufferOrderByDirectory<cr>',
          'Sort Buffers By Directory',
          opts = { noremap = true, silent = true }
        },
        ['<leader>bl'] = {
          '<cmd>BufferOrderByLanguage<cr>',
          'Sort Buffers By Language',
          opts = { noremap = true, silent = true }
        },
        ['<leader>bw'] = {
          '<cmd>BufferOrderByWindowNumber<cr>',
          'Sort Buffers By Window Number',
          opts = { noremap = true, silent = true }
        },
      },
    },
  },

  gitsigns = {
    general = {

    },
    events = {
      on_attach = {
        n = {
          ['<leader>gs'] = {
            function() require('gitsigns').stage_hunk() end,
            "[G]it [S]tage Hunk",
          },
          ['<leader>gr'] = {
            function() require('gitsigns').reset_hunk() end,
            "[G]it [R]eset Hunk",
          },
          ['<leader>gS'] = {
            function() require('gitsigns').stage_buffer() end,
            "[G]it [S]tage Buffer",
          },
          ['<leader>gu'] = {
            function() require('gitsigns').undo_stage_hunk() end,
            "[G]it [U]ndo Stage Hunk",
          },
          ['<leader>gR'] = {
            function() require('gitsigns').reset_buffer() end,
            "[G]it [R]eset Buffer",
            },
          ['<leader>gp'] = {
            function() require('gitsigns').preview_hunk() end,
            "[G]it [P]review Hunk",
          },
          ['<leader>gb'] = {
            function() require('gitsigns').blame_line({full=true}) end,
            "[G]it [B]lame Line",
          },
          ['<leader>gB'] = {
            function() require('gitsigns').toggle_current_line_blame() end,
            "Toggle [G]it Current Line [B]lame",
          },
          ['<leader>gdi'] = {
            function() require('gitsigns').diffthis() end,
            "Diff File Against Index",
          },
          ['<leader>gdc'] = {
            function() require('gitsigns').diffthis('~') end,
            "Diff File Against Previous Commit",
          },
          ['<leader>gD'] = {
            function() require('gitsigns').toggle_deleted() end,
            "Toggle [G]it [D]eleted",
          },
        },
        v = {
          ['<leader>gs'] = {
            function() require('gitsigns').stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
            '[G]it [S]tage Hunk',
          },
          ['<leader>gr'] = {
            function() require('gitsigns').stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,
            '[G]it [R]eset Hunk',
          },
        },
      },
    },
  },

}

return M
