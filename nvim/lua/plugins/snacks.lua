return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = false,
    },
    picker = {
      hidden = true,
      ignored = true,
      exclude = {
        "node_modules",
        ".git",
        "package-lock.json",
        ".next",
      },
    },
  },
}
