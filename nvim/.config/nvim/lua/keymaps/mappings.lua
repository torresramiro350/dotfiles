---@module Mappings for neovim
---@author R. Torres-Escobedo
---@date Feb 23, 2024
---@version

require("groups.utility_funcs")
-- navigating buffers
nmap("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
nmap("n", "]b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
nmap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- some mappings for making life easier
nmap("n", "<leader>q", "<cmd>qa<cr>", { desc = "Close all buffers" })
-- for much easier access to escape
nmap("i", "jj", "<Esc>", { desc = "Escape insert mode" })

-- split buffers
nmap("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
nmap("n", "\\", "<cmd>split<cr>", { desc = "Horizontal split" })

-- close split buffer
nmap("n", "<C-q>", "<C-w>q", { desc = "Close split buffer" })

-- save changes
nmap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save changes" })

-- moving between buffers

-- Remap for dealing with word wrap
nmap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
nmap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- NOTE: these keybindings are for usage without smart-splits
nmap("n", "<C-j>", "<c-w>j", { desc = "Move to lower split" })
nmap("n", "<C-k>", "<c-w>k", { desc = "Move to upper split" })
nmap("n", "<C-h>", "<c-w>h", { desc = "Move to left split" })
nmap("n", "<C-h>", "<c-w>l", { desc = "Move to right split" })
-- resize split lines
nmap("n", "<C-up>", "<cmd>resize -2<cr>", { desc = "Increase buffer size" })
nmap("n", "<C-down>", "<cmd>resize +2<cr>", { desc = "Increase buffer size down" })
nmap("n", "<C-left>", "<cmd>vertical resize -2<cr>", { desc = "Resize split left" })
nmap("n", "<C-right>", "<cmd>vertical resize +2<cr>", { desc = "Resize split right" })

-- commenting
nmap("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
nmap("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- new file
nmap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
nmap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
nmap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
nmap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
nmap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
nmap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
nmap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
