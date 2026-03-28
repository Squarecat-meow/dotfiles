return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  version = "*",
  cmd = { "ToggleTerm" },
  opts = {
    direction = "horizontal",
  },
  keys = {
    {
      "<C-/>",
      function()
        require("toggleterm").toggle(1, 0, LazyVim.root.get(), "horizontal")
      end,
      mode = { "n", "t" },
      desc = "ToggleTerm (horizontal)",
    },
    {
      "<leader>tf",
      function()
        -- 사용 중인 터미널 ID 중 가장 큰 번호 + 1로 새 인스턴스 생성
        local terms = require("toggleterm.terminal").get_all()
        local max_id = 1
        for _, t in ipairs(terms) do
          if t.id > max_id then
            max_id = t.id
          end
        end
        require("toggleterm").toggle(max_id + 1, 0, LazyVim.root.get(), "float")
      end,
      desc = "ToggleTerm (new float)",
    },
  },
}
