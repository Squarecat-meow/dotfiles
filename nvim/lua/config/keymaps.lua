-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>cs", vim.cmd.LiveServerStart, { desc = "Start Live Server" })
vim.keymap.set("n", "<leader>cS", vim.cmd.LiveServerStop, { desc = "Stop Live Server" })

vim.keymap.set("n", "<leader>gm", vim.cmd.Gitmoji, { desc = "Gitmoji" })
vim.keymap.set("n", "<leader>po", vim.cmd.PeekOpen, { desc = "Markdown Preview open" })
vim.keymap.set("n", "<leader>pq", vim.cmd.PeekClose, { desc = "Markdown Preview close" })
