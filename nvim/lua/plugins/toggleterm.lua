return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  version = "*",
  cmd = { "Toggleterm" },
  keys = {
    {
      "<leader>tf",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 0, LazyVim.root.get(), "float")
      end,
      desc = "ToggleTerm (float root_dir)",
    },
  },
}
