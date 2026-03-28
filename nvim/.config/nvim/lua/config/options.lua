-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.spelllang = { "en", "cjk" }

-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false

-- LazyGit Configs
vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize lazygit popup window border characters
vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
vim.g.lazygit_config_file_path = "" -- custom config file path
vim.g.lazygit_on_exit_callback = nil -- optional function callback when exiting lazygit (useful for example to refresh some UI elements after lazy git has made some changes)

local term = nil

local function lg_toggle()
  local Terminal = require("toggleterm").Terminal

  local size = 90
  local direction = "float"

  if not term then
    term = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      on_exit = function()
        term = nil
      end,
    })
    if term then
      term:toggle(size, direction)

      vim.cmd("set ft=lazygit")
      vim.keymap.set("t", "<a-q>", function()
        term:toggle(size, direction)
      end, { buffer = true })
    end
  else
    term:toggle(size, direction)
  end
end

vim.api.nvim_create_user_command("LazyGitToggle", lg_toggle, {})
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGitToggle<cr>", {})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})
