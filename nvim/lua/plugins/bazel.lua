-- Set up Bazel file type detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "BUILD", "BUILD.bazel", "WORKSPACE", "WORKSPACE.bazel", "*.bzl" },
  callback = function()
    vim.bo.filetype = "bzl"
  end,
})

-- Simple Bazel support for BUILD files
return {
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    config = function()
      require("go").setup({
        -- Disable treesitter textobjects to avoid compatibility issues
        textobjects = false,
        -- Disable other treesitter-dependent features
        lsp_cfg = false, -- Use LazyVim's LSP configuration instead
        lsp_gofumpt = false,
        lsp_on_attach = false,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

  -- Simple Bazel file syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "starlark" })
      end
    end,
  },
}

