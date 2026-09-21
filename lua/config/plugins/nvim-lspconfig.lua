return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'hrsh7th/cmp-nvim-lsp',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
  },
  config = function()
    local highlight_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = true })
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        require('utils').mappings.load_plugin_general_mappings('nvim_lspconfig', { buffer = event.buf })
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = highlight_group,
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = highlight_group,
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })
    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
      callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }
      end,
    })
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local servers = {
      arduino_language_server = {},
      asm_lsp = {},
      clangd = {},
      cmake = {},
      -- gopls = {},
      pyright = {},
      rust_analyzer = {},
      jsonls = {},
      bashls = {},
      dockerls = {},
      docker_compose_language_service = {},
      hdl_checker = {},
      yamlls = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      -- tsserver = {},
      --

      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    require('mason-lspconfig').setup { automatic_enable = false }
    for name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { 'clang-format', 'asmfmt', 'stylua' })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
  end,
}
