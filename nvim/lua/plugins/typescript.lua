-- Enhanced TypeScript/JavaScript support with hnvm-compatible LSP
return {
  -- Ensure TypeScript treesitter parsers are installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "javascript",
        "tsx",
        "jsx",
        "json",
        "jsonc",
      })
    end,
  },

  -- Enhanced LSP integration with hnvm support
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure vtsls works with hnvm by adding error recovery
      opts.servers = opts.servers or {}
      if opts.servers.vtsls then
        local original_on_attach = opts.servers.vtsls.on_attach
        opts.servers.vtsls.on_attach = function(client, bufnr)
          -- Enhanced error handling for hnvm compatibility
          if original_on_attach then
            local ok, err = pcall(original_on_attach, client, bufnr)
            if not ok then
              vim.notify("vtsls on_attach recovered from error: " .. tostring(err), vim.log.levels.DEBUG)
            end
          end
        end
      end
      return opts
    end,
  },

  -- Auto-tag support for JSX/TSX
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
      per_filetype = {
        ["html"] = { enable_close = false },
        ["javascript"] = { enable_close = false },
        ["typescript"] = { enable_close = false },
        ["javascriptreact"] = { enable_close = true },
        ["typescriptreact"] = { enable_close = true },
      },
    },
  },

  -- Add basic TypeScript file type support
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      -- Ensure proper file type detection
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.ts", "*.tsx" },
        callback = function()
          vim.bo.filetype = vim.fn.expand("%:e") == "tsx" and "typescriptreact" or "typescript"
        end,
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.js", "*.jsx" },
        callback = function()
          vim.bo.filetype = vim.fn.expand("%:e") == "jsx" and "javascriptreact" or "javascript"
        end,
      })
    end,
  },
}
