-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>gm", vim.cmd.Gitmoji, { desc = "Gitmoji" })

vim.keymap.set("n", "<leader>tt", vim.cmd.TodoQuickFix, { desc = "List of Commented Todos" })
vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>AdvancedNewFile<CR>", { noremap = true })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("t", "<leader>me", vim.cmd.RenderMarkdown, { desc = "Toggle Render Markdown" })
