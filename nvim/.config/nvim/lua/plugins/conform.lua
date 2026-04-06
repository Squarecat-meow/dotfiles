return {
  "stevearc/conform.nvim",
  opts = function()
    require("conform").setup({
      formatters_by_ft = {
        json = { "prettier" },
        yaml = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
      },
      formatters = {
        prettier = {
          prepend_args = { "--single-quote", "--config-precedence", "prefer-file" },
        },
      },
    })
  end,
}
