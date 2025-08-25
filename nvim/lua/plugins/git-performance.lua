return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- Reduce git operations for better performance in monorepos
      max_file_length = 40000, -- Disable for files longer than 40k lines
      current_line_blame = false, -- Disable blame by default for performance
      current_line_blame_opts = {
        delay = 1000, -- Increase delay to reduce frequent updates
      },
      update_debounce = 500, -- Increase debounce time
      preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      -- Reduce real-time updates
      watch_gitdir = {
        interval = 2000, -- Check every 2 seconds instead of default 1 second
        follow_files = false, -- Don't follow file moves for performance
      },
      -- Limit signs for performance
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      -- Disable some features for large repositories
      attach_to_untracked = false, -- Don't attach to untracked files
      sign_priority = 5, -- Lower priority to avoid conflicts
    },
  },
}