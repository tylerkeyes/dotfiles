return {
  {
    "telescope.nvim",
    optional = true,
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>sp",
        function()
          local files = {} ---@type table<string, string>
          for _, plugin in pairs(require("lazy.core.config").plugins) do
            repeat
              if plugin._.module then
                local info = vim.loader.find(plugin._.module)[1]
                if info then
                  files[info.modpath] = info.modpath
                end
              end
              plugin = plugin._.super
            until not plugin
          end
          require("telescope.builtin").live_grep({
            default_text = "/",
            search_dirs = vim.tbl_values(files),
          })
        end,
        desc = "Search Plugin Spec",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.5,
          },
          width = 0.8,
          height = 0.8,
          preview_cutoff = 120,
        },
        sorting_strategy = "ascending",
        winblend = 0,
        file_ignore_patterns = {
          "node_modules/.*",
          "%.git/.*",
          "dist/.*",
          "build/.*",
          "target/.*",
          "vendor/.*",
          "packages/.*/node_modules/.*",
          "apps/.*/node_modules/.*",
          "libs/.*/node_modules/.*",
          "services/.*/node_modules/.*",
          "%.lock",
          "%.min%.js",
          "%.min%.css",
          "__pycache__/.*",
          "%.pyc",
          "%.pyo",
          "%.class",
          "%.jar",
          "%.war",
          "%.ear",
          "%.zip",
          "%.tar",
          "%.gz",
          "%.rar",
          "%.7z",
          "%.bak",
          "%.swp",
          "%.tmp",
          "%.log",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--max-filesize=1M", -- Skip files over 1MB
          "--follow", -- Follow symlinks
          "--glob=!node_modules/**",
          "--glob=!.git/**",
          "--glob=!dist/**",
          "--glob=!build/**",
          "--glob=!target/**",
          "--glob=!vendor/**",
          "--glob=!packages/*/node_modules/**",
          "--glob=!apps/*/node_modules/**",
          "--glob=!libs/*/node_modules/**",
          "--glob=!services/*/node_modules/**",
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--max-depth", "6", "--exclude", "node_modules", "--exclude", ".git" },
          hidden = false,
        },
        live_grep = {
          additional_args = function()
            return { "--max-depth", "6" }
          end,
        },
      },
    },
  },
  {
    "tokyonight.nvim",
    opts = {
      on_highlights = function(hl, c)
        local prompt = "#2d3149"
        hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg }
        hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopePromptNormal = { bg = prompt }
        hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
        hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
        hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
      end,
    },
  },
}
