return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
      ensure_installed = {
        "astro",
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "http",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "prisma",
        "python",
        "query",
        "regex",
        "sql",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 50 * 1024 -- 50 KB for indent
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)

        -- MDX
        vim.filetype.add({
          extension = {
            mdx = "mdx",
          },
        })
        vim.treesitter.language.register("markdown", "mdx")

        -- Ensure Treesitter highlighting for files opened from file tree
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
          callback = function()
            if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
              local bufnr = vim.api.nvim_get_current_buf()
              pcall(function()
                require("nvim-treesitter.configs").attach_module("highlight", bufnr)
              end)
            end
          end,
          desc = "Enable Treesitter highlighting for opened files"
        })
      end,
    },
  },
  {
    "nvim-treesitter/playground",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
  },
}
