return {
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  dependencies = {
    "luckasRanarison/tailwind-tools.nvim",
    "onsails/lspkind.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = function()
    return {
      formatting = {
        format = require("lspkind").cmp_format({
          before = require("tailwind-tools.cmp").lspkind_format,
        }),
      },
      sources = {
        { name = "gitmoji" },
      },
    }
  end,
}
