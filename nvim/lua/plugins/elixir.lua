return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        elixirls = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "elixir", "heex", "eex" } },
  },
  {
    "jfpedroza/neotest-elixir",
  },
}
