-- Fix for mason-lspconfig mappings API compatibility issue
-- This creates a compatibility layer that works with both old and new APIs

-- Create the compatibility layer before LazyVim loads
local function create_mason_compatibility()
  local ok, mappings = pcall(require, "mason-lspconfig.mappings")
  if ok and not mappings.get_mason_map then
    -- Add the missing get_mason_map function for backward compatibility
    mappings.get_mason_map = function()
      local server_mappings = require("mason-lspconfig.mappings.server")
      return {
        lspconfig_to_package = server_mappings.lspconfig_to_package,
        package_to_lspconfig = server_mappings.package_to_lspconfig,
      }
    end
  end
end

-- Create LSP compatibility layer for missing functions
local function create_lsp_compatibility()
  -- Add missing vim.lsp.is_enabled function for backward compatibility
  if not vim.lsp.is_enabled then
    vim.lsp.is_enabled = function(server_name)
      -- Check if the server is configured
      return vim.lsp.config[server_name] ~= nil
    end
  end
end

-- Create treesitter compatibility layer for missing modules
local function create_treesitter_compatibility()
  -- Add missing nvim-treesitter.configs module for backward compatibility
  local ok, ts = pcall(require, "nvim-treesitter")
  if ok and not pcall(require, "nvim-treesitter.configs") then
    -- Create a compatibility layer for the configs module
    package.loaded["nvim-treesitter.configs"] = {
      setup = function(opts)
        -- Forward to the new API
        if ts.setup then
          ts.setup(opts)
        end
      end,
      get_module = function(name)
        -- Return a basic module structure for compatibility
        return {}
      end,
    }
  end
end

-- Apply compatibility layers immediately when this file is loaded
create_lsp_compatibility()
create_treesitter_compatibility()

return {
  {
    "mason-org/mason-lspconfig.nvim",
    priority = 1000, -- Load early to ensure compatibility layer is in place
    config = function(_, opts)
      -- Create compatibility layers first
      create_mason_compatibility()
      create_lsp_compatibility()
      create_treesitter_compatibility()

      -- Then proceed with normal setup
      require("mason-lspconfig").setup(opts)
    end,
  },
}
