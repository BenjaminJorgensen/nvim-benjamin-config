-- General Vim settings - (No plugins or key binds)

--==================================================
-- Window Options
--==================================================
vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.opt.splitright = true
vim.opt.mouse = ''
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.ruler = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'


--==================================================
-- Syntax and Highlighting - Themes
--==================================================
vim.cmd([[syntax enable]])
vim.opt.background = 'dark'
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.cmd([[filetype plugin indent on]])

if vim.fn.has("termguicolors") then
    vim.o.termguicolors = true
end

-- Colour Column for style programming
-- vim.opt.colorcolumn = '80'
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Make sure that terminals never use spelling
vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'Will turn off spelling for terminal windows',
    callback = function()
        vim.opt_local.spell = false
    end
})

--==================================================
-- Indentation
--==================================================
vim.opt.tabstop = 4             --Sets the number of visual spaces per tab
vim.opt.softtabstop = 4			--Sets the number of spaces a tab counts as
vim.opt.autoindent = true			--Auto indentation
vim.opt.shiftwidth = 4			--Set the number of columns to indent with operations
vim.opt.filetype.indent = true	--Let python to decide indentation
vim.opt.wrap = false
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.expandtab = true
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', lead = '·'}

--==================================================
-- Clipboard
--==================================================
-- vim.o.clipboard = "unnamedplus"

--==================================================
-- Spelling
--==================================================
vim.o.spell = false

--==================================================
-- Undoing
--==================================================
vim.opt.undofile = true

