-- Safe LSP configuration with better error handling and server management
return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = {
      -- Global LSP settings
      inlay_hints = { enabled = false },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },

      -- Enhanced server setup with safety checks
      setup = {
        ["*"] = function(server, opts)
          -- Add safety wrapper for all LSP servers
          local original_on_attach = opts.on_attach
          opts.on_attach = function(client, bufnr)
            -- Wrap in pcall to prevent crashes
            local ok, err = pcall(function()
              if original_on_attach then
                original_on_attach(client, bufnr)
              end
            end)
            if not ok then
              vim.notify("LSP on_attach error for " .. server .. ": " .. tostring(err), vim.log.levels.WARN)
            end
          end

          -- Add error handler for server crashes
          local original_on_error = opts.on_error
          opts.on_error = function(err, result, ctx, config)
            -- Filter out known protocol issues
            if err and err.message then
              local msg = err.message
              if
                msg:match("Content%-Length not found")
                or msg:match("cannot resume dead coroutine")
                or msg:match("Resolved node")
                or msg:match("Using Hermetic NodeJS")
              then
                return -- Ignore these errors
              end
            end

            if original_on_error then
              original_on_error(err, result, ctx, config)
            else
              vim.notify("LSP error for " .. server .. ": " .. tostring(err), vim.log.levels.ERROR)
            end
          end

          return opts
        end,
      },

      servers = {
        -- Enhanced vtsls configuration with hnvm compatibility
        vtsls = {
          enabled = true,
          cmd_env = {
            NO_COLOR = "1",
            FORCE_COLOR = "0",
            NODE_NO_WARNINGS = "1",
            TERM = "dumb",
            CI = "true",
            CLICOLOR = "0",
            CLICOLOR_FORCE = "0",
            COLORTERM = "",
            HNVM_QUIET = "true", -- Suppress hnvm colored output
          },
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = false },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
              },
            },
            javascript = {
              inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = false },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
              },
            },
          },
          on_attach = function(client, bufnr)
            -- Disable formatting to avoid conflicts
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },

        -- Keep other TypeScript servers disabled to avoid conflicts
        tsserver = { enabled = false },
        ts_ls = { enabled = false },
        denols = { enabled = false },
        eslint = { enabled = false },
        tsserver = { enabled = false },
        denols = { enabled = false },
        eslint = { enabled = false },

        -- Only enable stable, essential LSP servers
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },

        -- Safe JSON LSP configuration
        jsonls = {
          cmd_env = {
            NO_COLOR = "1",
            FORCE_COLOR = "0",
            NODE_NO_WARNINGS = "1",
            HNVM_QUIET = "true", -- Suppress hnvm colored output
          },
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
          -- Only start for actual JSON files
          filetypes = { "json", "jsonc" },
          root_dir = function(fname)
            return require("lspconfig.util").find_package_json_ancestor(fname) or vim.fn.getcwd()
          end,
        },

        -- Safe Go LSP configuration
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = false,
                shadow = false,
              },
              staticcheck = false,
              gofumpt = false,
              -- Disabled: semantic token requests fire immediately at attach,
              -- before gopls finishes creating workspace views, causing "no views".
              semanticTokens = false,
              usePlaceholders = true,
              completeUnimported = false,
              deepCompletion = false,
            },
          },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
        },

      },
    },
  },
}
