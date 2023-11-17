
local M = {}

M.load_mappings = function(section, mapping_opt)
  vim.schedule(function()
    local function set_section_map(section_values)
      if section_values.plugin then
        return
      end

      section_values.plugin = nil

      for mode, mode_values in pairs(section_values) do
        local default_opts = vim.tbl_deep_extend("force", {mode = mode}, mapping_opt or {})
        for keybind, mapping_info in pairs(mode_values) do
          local opts = vim.tbl_deep_extend("force", default_opts, mapping_info.opts or {})

          mapping_info.opts, opts.mode = nil, nil

          opts.desc = mapping_info[2]
          vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
      end
    end
    
    local mappings = require('config.mappings')

    if type(section) == 'string' then
      mappings[section]["plugin"] = nil
      mappings = {mappings[section]}
    end

    for _, section in pairs(mappings) do
      set_section_map(section)
    end
  end)
end

return M
