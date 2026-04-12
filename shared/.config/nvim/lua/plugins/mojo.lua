return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.filetype.add({
        extension = {
          mojo = "mojo",
          ["🔥"] = "mojo",
        },
      })

      -- No official Mojo treesitter parser exists yet.
      -- Use Python grammar as a highlight fallback (same approach as the official VS Code extension).
      vim.treesitter.language.register("python", "mojo")

      return opts
    end,
  },
  {
    -- Use a dummy plugin entry to register an autocmd after all plugins load.
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mojo",
        callback = function(args)
          -- Resolve project root preferring pixi.toml, falling back to .git
          local root = vim.fs.root(args.buf, { "pixi.toml", "mojoproject.toml", ".git" })

          -- Find mojo-lsp-server. Prefer `pixi run` so the server inherits the
          -- full pixi environment (stdlib paths, installed packages, etc.).
          local cmd
          if root and vim.fn.executable("pixi") == 1 then
            local pixi_bin = root .. "/.pixi/envs/default/bin/mojo-lsp-server"
            if vim.fn.executable(pixi_bin) == 1 then
              cmd = { "pixi", "run", "--manifest-path", root .. "/pixi.toml", "mojo-lsp-server" }
            end
          end
          if not cmd and vim.fn.executable("mojo-lsp-server") == 1 then
            cmd = { "mojo-lsp-server" }
          end

          if cmd then
            vim.lsp.start({
              name = "mojo",
              cmd = cmd,
              root_dir = root or vim.fn.getcwd(),
            })
          end
        end,
      })
      return opts
    end,
  },
}
