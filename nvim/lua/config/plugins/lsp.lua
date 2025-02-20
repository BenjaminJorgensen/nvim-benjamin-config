--[[
 _     ____  ____  
| |   / ___||  _ \ 
| |   \___ \| |_) |
| |___ ___) |  __/ 
|_____|____/|_|    
--]]

local blink_opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
        preset = 'default',
        ['<C-k>'] = { 'select_prev', 'fallback'},
        ['<Up>'] = { 'select_prev', 'fallback'},
        ['<C-j>'] = { 'select_next', 'fallback'},
        ['<Down>'] = { 'select_next', 'fallback'},
        ['<Tab>'] = { 'select_and_accept', 'fallback' },

        cmdline = {
            preset = 'default',
            ['<C-k>'] = { 'select_prev', 'fallback'},
            ['<C-j>'] = { 'select_next', 'fallback'},
            ['<Tab>'] = { 'show', 'select_next', 'fallback'},
        }
    },

    -- Don't show map when in cmd
    completion = {
        menu = {
            auto_show = function(ctx) return ctx.mode ~= 'cmdline' end,
        },
        list = {
            selection = { auto_insert = function (ctx)
                return ctx.mode == 'cmdline'
            end, preselect = false }
        },
        documentation = { auto_show = true, auto_show_delay_ms = 1000 },
        ghost_text = { enabled = false },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
    },
    snippets = { preset = 'luasnip' },

    sources = {
        default = function(ctx)
            local success, node = pcall(vim.treesitter.get_node)
            if vim.bo.filetype == 'lua' then
                return { 'lsp', 'path' }
            elseif success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                return { 'buffer' }
            else
                return { 'lsp', 'path', 'snippets', 'buffer' }
            end
        end,
        providers = {
            lsp = {
                name = 'LSP',
                module = 'blink.cmp.sources.lsp',
                score_offset = 1000, -- Boost/penalize the score of the items
            },
            snippets = {
                name = 'snippets',
                module = 'blink.cmp.sources.snippets',
                score_offset = 950, -- Boost/penalize the score of the items
            },
            path = {
                name = 'path',
                module = 'blink.cmp.sources.path',
                score_offset = 900, -- Boost/penalize the score of the items
            },
            buffer = {
                name = 'buffer',
                module = 'blink.cmp.sources.buffer',
                score_offset = 850, -- Boost/penalize the score of the items
            },
        }
    },
}

local nvim_config = function (_, opts)
    local lspconfig = require('lspconfig')
    for server, config in pairs(opts.servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
    end

    require'lspconfig'.lua_ls.setup {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                }
            })
        end,
        settings = {
            Lua = {}
        }
    }

    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local t_opts = {buffer = event.buf}
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, t_opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, t_opts)
            vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, t_opts)
            vim.keymap.set("n", "<leader>k", function() vim.diagnostic.open_float() end, t_opts)
            vim.keymap.set("n", "[d", function() vim.lsp.diagnostic.goto_next() end, t_opts)
            vim.keymap.set("n", "]d", function() vim.lsp.diagnostic.goto_prev() end, t_opts)
            vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, t_opts)
            vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, t_opts)
            vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, t_opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, t_opts)

        end,
    })
end

-- Blink.CMP
return  {
    { 'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets', 'L3MON4D3/LuaSnip', version = 'v2.*' },
        version = '*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = blink_opts,
        opts_extend = { "sources.default" },
    },

    -- LSP Config
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp' },

        -- example using `opts` for defining servers
        opts = {
            servers = {
                lua_ls = {},
                pyright = {},
                clangd = {},
                ts_ls = {},
            }
        },
        config = nvim_config
    }
}

