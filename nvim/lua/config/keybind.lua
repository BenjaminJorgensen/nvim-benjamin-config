-- General Keybinds
vim.g.mapleader = " "

-- Navigation
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('i', 'jl', '<Esc>')
vim.api.nvim_set_keymap('v', 'J', ":m '>+1<CR>gv=gv", { noremap=true })
vim.api.nvim_set_keymap('v', 'K', ":m '<-2<CR>gv=gv", { noremap=true })
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-e>', '10j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-y>', '10k', { noremap = true })

vim.keymap.set('n', '<C-.>', function()
    require('config.terminal').toggle()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>.', function()
    require('config.terminal').open()
end, { noremap = true, silent = true })

vim.keymap.set('t', '<C-.>', function()
    require('config.terminal').toggle()
    -- Switch from terminal mode to normal mode after toggling
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', false)
end, { silent = true })

vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', {noremap = true})

-- Quick-fix
vim.api.nvim_set_keymap('n', '<C-S-j>', ':silent! cnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S-k>', ':silent! cprev<CR>', { noremap = true })

-- Formatting
vim.keymap.set("n", "<M-z>", function () vim.cmd([[set wrap! linebreak]]) end)

--Pasting
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', {noremap = true})

-- Execution
vim.keymap.set("n", "<leader><leader>x", function() vim.cmd([[source %]]) end)

-- Spelling 
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u")
vim.keymap.set("n", "<leader>n", function()
	vim.opt.spell = not(vim.opt.spell:get())
end)
