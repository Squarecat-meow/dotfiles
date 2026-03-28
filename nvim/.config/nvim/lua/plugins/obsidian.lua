return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  opts = {
    legacy_commands = false,
    ui = { enable = false },
    workspaces = {
      {
        name = "vault",
        path = "~/Documents/Obsidian/",
      },
    },
  },
}
