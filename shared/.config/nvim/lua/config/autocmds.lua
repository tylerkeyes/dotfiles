-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.cmd("colorscheme tokyonight-storm")

-- Disable inlay hints globally to prevent 'col out of range' errors
vim.lsp.inlay_hint.enable(false)

-- Simple Bazel integration for Go files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local function find_bazel_workspace()
      local current_dir = vim.fn.expand('%:p:h')
      while current_dir ~= "/" do
        local workspace_files = {
          current_dir .. "/WORKSPACE",
          current_dir .. "/WORKSPACE.bazel", 
          current_dir .. "/MODULE.bazel"
        }
        for _, file in ipairs(workspace_files) do
          if vim.fn.filereadable(file) == 1 then
            return current_dir
          end
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
      end
      return nil
    end
    
    local function bazel_find_package(import_path)
      local workspace_root = find_bazel_workspace()
      if not workspace_root then
        vim.notify("Not in a Bazel workspace", vim.log.levels.WARN)
        return
      end
      

      
      -- Try telescope first, fallback to quickfix
      local ok, telescope = pcall(require, 'telescope.builtin')
      if ok then
        telescope.live_grep({
          prompt_title = "Search for package: " .. import_path,
          search = "package " .. import_path,
          search_dirs = { workspace_root .. "/src/go" },
          additional_args = function() return {"--type", "go"} end,
        })
      else
        -- Fallback: use ripgrep with quickfix
        local cmd = string.format("rg --type go 'package %s' %s/src/go", 
          vim.fn.shellescape(import_path), 
          vim.fn.shellescape(workspace_root))
        
        local results = vim.fn.systemlist(cmd)
        if #results > 0 then
          local qf_list = {}
          for _, line in ipairs(results) do
            local file, lnum, text = line:match("([^:]+):(%d+):(.*)")
            if file then
              table.insert(qf_list, {
                filename = file,
                lnum = tonumber(lnum) or 1,
                text = text or line,
              })
            end
          end
          vim.fn.setqflist(qf_list)
          vim.cmd("copen")

        else
          vim.notify("No matches found for: " .. import_path, vim.log.levels.WARN)
        end
      end
    end
    
    local function bazel_build_current()
      local workspace_root = find_bazel_workspace()
      if not workspace_root then
        vim.notify("Not in a Bazel workspace", vim.log.levels.WARN)
        return
      end
      
      local current_file = vim.fn.expand('%:p')
      local relative_path = current_file:gsub("^" .. vim.pesc(workspace_root .. "/"), "")
      local package_path = vim.fn.fnamemodify(relative_path, ":h")
      
      if package_path:match("^src/go/") then
        local bazel_package = "//" .. package_path
        local cmd = string.format("cd %s && bazel build %s:all", 
          vim.fn.shellescape(workspace_root), 
          vim.fn.shellescape(bazel_package))
        

        vim.fn.system(cmd)
        
        if vim.v.shell_error == 0 then

        else
          vim.notify("Build failed", vim.log.levels.ERROR)
        end
      else
        vim.notify("Not in a Go source directory", vim.log.levels.WARN)
      end
    end
    
    local function get_word_under_cursor()
      return vim.fn.expand('<cword>')
    end
    
    -- Set up keymaps for Go files
    local opts = { noremap = true, silent = true, buffer = true }
    
    -- Enhanced go-to-definition that falls back to telescope search
    vim.keymap.set('n', 'gd', function()
      -- First try LSP go-to-definition
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients > 0 then
        vim.lsp.buf.definition()
      else
        -- Fallback to searching for the word under cursor
        local word = get_word_under_cursor()
        if word and word ~= "" then
          bazel_find_package(word)
        else
          vim.notify("No word under cursor", vim.log.levels.WARN)
        end
      end
    end, vim.tbl_extend('force', opts, { desc = 'Go to definition (LSP + Bazel fallback)' }))
    
    -- Build current package
    vim.keymap.set('n', '<leader>gb', bazel_build_current, 
      vim.tbl_extend('force', opts, { desc = 'Bazel build current package' }))
    
    -- Find packages using telescope
    vim.keymap.set('n', '<leader>gf', function()
      local word = get_word_under_cursor()
      if word and word ~= "" then
        bazel_find_package(word)
      else
        local input_word = vim.fn.input("Search for package: ")
        if input_word ~= "" then
          bazel_find_package(input_word)
        end
      end
    end, vim.tbl_extend('force', opts, { desc = 'Find Go package' }))
    
    -- Show workspace status
    vim.keymap.set('n', '<leader>gs', function()
      local workspace_root = find_bazel_workspace()
      if workspace_root then

      else
        vim.notify("Not in a Bazel workspace", vim.log.levels.WARN)
      end
    end, vim.tbl_extend('force', opts, { desc = 'Show Bazel workspace status' }))
    

   end,
   desc = "Setup simple Bazel integration for Go files"
})
