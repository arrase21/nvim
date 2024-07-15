-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- press kj fast to enter
keymap("i", "kj", "<esc>", opts)
keymap("i", "kj", "<esc>", opts)

-- quit
keymap("n", "<leader>w", ":w<esc>", opts)
-- keymap("n", "<leader>q", ":quitall<esc>", opts)

-- init.lua
keymap("n", "<leader>zc", ":set foldlevel=0<cr>", { noremap = true, silent = true })
keymap("n", "<leader>zo", ":set foldlevel=99<cr>", { noremap = true, silent = true })

-- better window navigation
keymap("n", "<c-h>", "<c-w>h", opts)
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)
keymap("n", "<c-l>", "<c-w>l", opts)

-- resize with arrows
keymap("n", "<up>", ":resize -2<cr>", opts)
keymap("n", "<down>", ":resize +2<cr>", opts)
keymap("n", "<left>", ":vertical resize -2<cr>", opts)
keymap("n", "<right>", ":vertical resize +2<cr>", opts)

-- move text up and down
keymap("v", "<a-j>", ":m .+1<cr>==", opts)
keymap("v", "<a-k>", ":m .-2<cr>==", opts)

keymap("n", "<a-j>", ":m .+1<cr>==", opts)
keymap("n", "<a-k>", ":m .-2<cr>==", opts)

keymap("i", "<a-k> <esc>", ":m .+1<cr>==gi", opts)
keymap("i", "<a-k> <esc>", ":m .-2<cr>==gi", opts)

-- delete word
keymap("n", "<backspace>", "diw", opts)

-- keymap("n", "<leader>s", ":split<return>", opts)
keymap("n", "<leader>v", ":vsplit<return><c-w>w", opts)

-- copy paste
keymap("n", "<leader>y", "mzyyp`zj", opts)

-- do things without affecting the registers
keymap("n", "x", '"_x')
keymap("n", "<leader>p", '"0p')
keymap("n", "<leader>p", '"0p')
keymap("v", "<leader>p", '"0p')
keymap("n", "<leader>c", '"_c')
keymap("n", "<leader>c", '"_c')
keymap("v", "<leader>c", '"_c')
keymap("v", "<leader>c", '"_c')
keymap("n", "<leader>d", '"_d')
keymap("n", "<leader>d", '"_d')
keymap("v", "<leader>d", '"_d')
keymap("v", "<leader>d", '"_d')

-- increment/decrement
keymap("n", "+", "<c-a>")
keymap("n", "-", "<c-x>")

-- delete a word backwards
keymap("n", "dw", 'vb"_d')

-- select all
keymap("n", "<c-a>", "gg<s-v>g")

-- save with root permission (not working for now)
--vim.api.nvim_create_user_command('w', 'w !sudo tee > /dev/null %', {})

-- disable continuations
keymap("n", "<leader>o", "o<esc>^da", opts)
keymap("n", "<leader>o", "o<esc>^da", opts)

-- jumplist
keymap("n", "<c-m>", "<c-i>", opts)

-- new tab
keymap("n", "te", ":tabedit")
keymap("n", "<tab>", ":tabnext<return>", opts)
keymap("n", "<s-tab>", ":tabprev<return>", opts)
-- split window
keymap("n", "ss", ":split<return>", opts)
keymap("n", "sv", ":vsplit<return>", opts)
-- move window
keymap("n", "sh", "<c-w>h")
keymap("n", "sk", "<c-w>k")
keymap("n", "sj", "<c-w>j")
keymap("n", "sl", "<c-w>l")
