-- Tarion Neovim configuration
-- Minimal but developer-focused

-- Set leader key
vim.g.mapleader = ' '

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- Key mappings
local keymap = vim.keymap.set

-- Better navigation
keymap('n', 'j', 'gj', { noremap = true })
keymap('n', 'k', 'gk', { noremap = true })

-- Save and quit shortcuts
keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
keymap('n', '<leader>x', ':x<CR>', { noremap = true, silent = true })

-- Better split navigation
keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Toggle line numbers
keymap('n', '<leader>n', ':set number!<CR>', { noremap = true, silent = true })

-- Clear search highlight
keymap('n', '<leader>/', ':nohlsearch<CR>', { noremap = true, silent = true })

vim.cmd('colorscheme default')
