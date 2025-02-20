local haskellconfig = function ()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "haskell",
        callback = function()
            -- Your Haskell-specific configuration here
            vim.api.nvim_create_user_command("Lint", "!hlint % --refactor --refactor-options -i", {})
            vim.api.nvim_create_user_command("Form", "%!hindent", {})
            local ht = require('haskell-tools')
            local bufnr = vim.api.nvim_get_current_buf()
            local opts = { noremap = true, silent = true, buffer = bufnr }

            vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)
            vim.keymap.set('n', '<space>pH', ht.hoogle.hoogle_signature, opts)
            vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
            vim.keymap.set('n', '<leader>rp', ht.repl.toggle, opts)
            vim.keymap.set('n', '<leader>rf', function()
                vim.cmd('vsplit')
                ht.repl.toggle(vim.api.nvim_buf_get_name(0))
                vim.cmd(':q')
                vim.cmd(':set nospell')
            end, opts)
            vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
        end,
    })
end

return {
  'mrcjkb/haskell-tools.nvim',
  version = '^4', -- Recommended
  lazy = false, -- This plugin is already lazy
  init = haskellconfig
}
