
local M = {}

--[[
Function to assemble the configuration of the lazy plugin manager itself. This can just be
loaded from a file but done as a function to keep consistant with below.
]]-- 
M.assemble_lazy_config = function(config)
  local config = config or {}
  table.insert(config, require('config.lazy'))
  return config
end

--[[
Function to assemble the configuration to be passed to lazy, sourcing all files in in the 
lua/config/plugins directory. This allows drop-in configuration of plugins.
You can optionally pass in a config to append these to some existing conifg. This is useful for
merging with some other configuration
]]--
M.assemble_plugin_config = function(config)
  local config_files = {}
  local config = config or {}
  for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config')..'/lua/config/plugins', [[v:val =~ '\.lua$']])) do
    table.insert(config_files, 'config.plugins.'..file:gsub('%.lua$', ''))
  end
  
  for i, config_file in ipairs(config_files) do
    table.insert(config, require(config_file))
    -- print(config_file)
  end
  -- return {}
  return config
end

M.lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
    callback = function()
      local file = vim.fn.expand "%"
      local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

      if condition then
        vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()
            require("lazy").load { plugins = plugin }

            if plugin == "nvim-lspconfig" then
              vim.cmd "silent! do FileType"
            end
          end, 0)
        else
          require("lazy").load { plugins = plugin }
        end
      end
    end,
  })
end

return M