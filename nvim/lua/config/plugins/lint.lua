-- _     _       _
-- | |   (_)_ __ | |_ ___ _ __ ___
-- | |   | | '_ \| __/ _ \ '__/ __|
-- | |___| | | | | ||  __/ |  \__ \
-- |_____|_|_| |_|\__\___|_|  |___/

local config = function()
    local nvimlint = require('lint');

    nvimlint.linters_by_ft = {
        -- typescript = {'eslint_d'}
    }

    vim.env.ESLINT_D_PPID = vim.fn.getpid()
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
            nvimlint.try_lint()
        end,
    })
end

local conformfig = function()
    local conform = require("conform")
    conform.setup({
        formatters_by_ft = {
            javascript = { "prettierd" },
        },
    })
    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
end

return {
    {
        'mfussenegger/nvim-lint',
        event = "VeryLazy",
        config = config
    },

    {
        'stevearc/conform.nvim',
        opts = {},
        event = "VeryLazy",
        config = conformfig
    }
}
