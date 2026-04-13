return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts_extend = {
      "sources.default",
      "sources.providers",
      "sources.per_filetype",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "saghen/blink.compat",
        optional = true,
        version = "*",
        opts = {},
      },
    },
    opts = function(_, opts)
      local widths = {
        abbr = (vim.g.cmp_widths and vim.g.cmp_widths.abbr) or 40,
        menu = (vim.g.cmp_widths and vim.g.cmp_widths.menu) or 30,
      }

      opts.snippets = vim.tbl_deep_extend("force", opts.snippets or {}, {
        preset = "luasnip",
      })

      opts.appearance = vim.tbl_deep_extend("force", opts.appearance or {}, {
        nerd_font_variant = "mono",
        kind_icons = vim.tbl_extend("force", {}, LazyVim.config.icons.kinds),
      })

      opts.fuzzy = vim.tbl_deep_extend("force", opts.fuzzy or {}, {
        frecency = {
          -- Use cache directory instead of state for frecency database
          -- to work around permission issues with protected directories
          path = vim.fn.stdpath("cache") .. "/blink/frecency.dat",
        },
      })

      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          cmdline = {
            -- Avoid cmdline provider for shell/filter commands like :! and :%!.
            enabled = function()
              if vim.fn.getcmdtype() ~= ":" then
                return true
              end
              local cmdline = vim.fn.getcmdline()
              return not (cmdline:match("^%s*!") or cmdline:match("^%s*%%!"))
            end,
          },
        },
      })

      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
        preset = "enter",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
        ["<S-CR>"] = { "select_and_accept", "fallback" },
        ["<C-CR>"] = { "cancel", "fallback" },
      })

      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          border = {
            { "󱐋", "WarningMsg" },
            { "─", "Comment" },
            { "╮", "Comment" },
            { "│", "Comment" },
            { "╯", "Comment" },
            { "─", "Comment" },
            { "╰", "Comment" },
            { "│", "Comment" },
          },
          scrollbar = false,
          winblend = 0,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              label = {
                width = { fill = true, max = widths.abbr },
              },
              source_name = {
                width = { max = widths.menu },
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = {
              { "󰙎", "DiagnosticHint" },
              { "─", "Comment" },
              { "╮", "Comment" },
              { "│", "Comment" },
              { "╯", "Comment" },
              { "─", "Comment" },
              { "╰", "Comment" },
              { "│", "Comment" },
            },
            scrollbar = false,
            winblend = 0,
          },
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      })

      opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      })
    end,
  },
}
