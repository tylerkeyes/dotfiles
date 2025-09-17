-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff_lsp"

-- Setup enhanced LSP error handling
require("config.lsp-handlers").setup()

-- Enable TypeScript LSP with hnvm compatibility fixes
vim.g.lazyvim_typescript_lsp = "vtsls"  -- Use vtsls with enhanced hnvm parsing
vim.g.lazyvim_eslint_lsp = false        -- Keep ESLint disabled for now

-- Ensure Node.js is available for LSP servers by setting PATH
vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH

-- Disable colored output for Node.js-based LSP servers and all tools
vim.env.NO_COLOR = "1"
vim.env.FORCE_COLOR = "0"
vim.env.NODE_NO_WARNINGS = "1"
vim.env.TERM = "dumb"  -- Force non-interactive terminal mode
vim.env.CI = "true"    -- Many tools disable colors in CI mode
vim.env.HNVM_QUIET = "true"  -- Suppress hnvm colored output

-- Configure Copilot to use explicit Node.js path to avoid version detection issues
vim.g.copilot_node_command = "/opt/homebrew/bin/node"

-- Additional environment variables to prevent colored output
vim.env.CLICOLOR = "0"
vim.env.CLICOLOR_FORCE = "0"
vim.env.COLORTERM = ""

-- Performance optimizations for large files and monorepos
vim.opt.updatetime = 1000 -- Increase from default 250ms to reduce file watching

-- Define large file threshold (1MB)
vim.g.large_file = 1024 * 1024

-- Disable features for large files to improve performance
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function()
    local size = vim.fn.getfsize(vim.fn.expand("<afile>"))
    if size > vim.g.large_file then
      vim.opt_local.syntax = "off"
      vim.opt_local.filetype = ""
      vim.opt_local.swapfile = false
      vim.opt_local.bufhidden = "unload"
      vim.opt_local.undolevels = -1
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.eventignore = "all"
      vim.notify(
        "Large file detected (" .. size .. " bytes), some features disabled for performance",
        vim.log.levels.WARN
      )
    end
  end,
})

-- Reduce memory usage for very large files
vim.opt.maxmempattern = 20000 -- Reduce from default 1000000

-- Augment code workspace context
vim.g.augment_workspace_folders = { "~/development/urbancompass" }
vim.g.augment_node_command = "/Users/tyler.keyes/.hnvm/node/22.0.0/bin/node"

vim.g.augment_log_file = vim.fn.stdpath("state") .. "/augment.log"
vim.g.augment_debug = false
