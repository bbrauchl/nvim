
local M = {}

local function load_mappings(mappings, mapping_opts, desc_prefix)
  vim.schedule(function()

    for mode, mode_values in pairs(mappings) do
      local default_opts = vim.tbl_deep_extend("force", {mode = mode}, mapping_opts or {})
      for keybind, mapping_info in pairs(mode_values) do
        local opts = vim.tbl_deep_extend("force", default_opts, mapping_info.opts or {})

        mapping_info.opts, opts.mode = nil, nil

        desc_prefix = desc_prefix or ""
        mapping_info[2] = mapping_info[2] or ""
        opts.desc = desc_prefix .. mapping_info[2]
        vim.keymap.set(mode, keybind, mapping_info[1], opts)
      end
    end

  end)
end

M.load_general_mappings = function(mapping_opts)
  local general_mappings = require('config.mappings').general_mappings

  load_mappings(general_mappings, mapping_opts)
end

M.load_plugin_general_mappings = function(plugin, mapping_opts)
  -- load the main plugin mappings table
  local plugin_mappings_all = require('config.mappings').plugin_mappings
  -- If we want to load a specific plugin's keymapping. If the provided
  -- plugin does not exist, use an empty table (to prevent error)
  local plugin_mappings = plugin_mappings_all[plugin] or {}
  local general_mappings = plugin_mappings.general  or {}

  -- Add a prefix to the descirption to make it more obvious where keybinds
  -- come from. Override the provided.
  local prefix = '[' .. plugin .. ']'
  load_mappings(general_mappings, mapping_opts, prefix)
end

M.load_all_plugin_general_mappings = function(mapping_opts)
  -- itterate through the plugins and assing mappings
  local plugin_mappings_all = require('config.mappings').plugin_mappings
  for plugin, plugin_mappings in pairs(plugin_mappings_all) do
    -- allow for the case that there is no mapping table
    local general_mappings = plugin_mappings.general or {}
    -- Add a prefix based upon the plugin name. Force to overwrite
    -- anything that was provided in mapping_optss
    local prefix = '[' .. plugin .. ']'
    load_mappings(general_mappings, mapping_opts, prefix)
  end
end

M.load_plugin_event_mappings = function(plugin, plugin_event, mapping_opts)
  -- Make sure that mapping_opts exists
  mapping_opts = mapping_opts or {}
  -- Load the event mappings from the mappings table
  local plugin_mappings_all = require('config.mappings').plugin_mappings
  local plugin_mappings = plugin_mappings_all[plugin] or {}
  local event_mappings = plugin_mappings.events or {}
  local mappings = event_mappings[plugin_event] or {}

  -- Create the prefix based upon the plugin name for description
  local prefix = '[' .. plugin .. ']'
  -- Plugin mappings that should only be loaded on some event, such as focusing
  -- a plugin window (like nvim_tree). These should never be run all at once.
  load_mappings(mappings, mapping_opts, prefix)
end

M.load_local_mappings = function(mappings, mapping_opts)
  load_mappings(mappings, mapping_opts)
end

return M
