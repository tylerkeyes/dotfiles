return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  build = (not LazyVim.is_win())
      and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
    or nil,
  dependencies = {
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "saghen/blink.cmp",
      optional = true,
      opts = {
        snippets = {
          preset = "luasnip",
        },
      },
    },
  },
  opts = {
    history = true,
    region_check_events = "InsertEnter",
    delete_check_events = "TextChanged,InsertLeave",
  },
  keys = {
    { "<Tab>", function() require("luasnip").jump(1) end, mode = "s" },
    { "<S-Tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  },
}
