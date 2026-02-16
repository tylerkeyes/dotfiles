return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      fuzzy = {
        frecency = {
          -- Use cache directory instead of state for frecency database
          -- to work around permission issues with protected directories
          path = vim.fn.stdpath("cache") .. "/blink/frecency.dat",
        },
      },
    },
  },
}
