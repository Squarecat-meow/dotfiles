return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    priority = 1000,
    config = function()
      require("render-markdown").setup({
        enabled = true,
      })
    end,
  },
}
