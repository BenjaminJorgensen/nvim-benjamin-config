--==========================================
--Vimtex + Markdown
--==========================================

local markdown_options = function ()
    local markview = require("markview");
    -- local presets = require("markview.presets");

    markview.setup({
        preview = {
            modes = { "n", "no", "c" },
            -- hybrid_modes = {"n"},

            -- This is nice to have
            callbacks = {
                on_enable = function (_, win)
                    vim.wo[win].conceallevel = 2;
                    -- vim.wo[win].conecalcursor = "c";
                end
            },
        },
        enable = true,
        shift_width = 1,

        heading_1 = {
            style = "simple",

            shift_char = " ",
            hl = "DiagnosticOk"
        },
    });

    vim.cmd("Markview enable");
    vim.cmd("set concealcursor-=n")
end

return {
 'godlygeek/tabular',
 {
    "OXY2DEV/markview.nvim",
    enabled = true,
    event = "VeryLazy",
    config = markdown_options,
    ft = "markdown", -- If you decide to lazy-load anyway

    dependencies = {
        -- You will not need this if you installed the
        -- parsers manually
        -- Or if the parsers are in your $RUNTIMEPATH
        "nvim-treesitter/nvim-treesitter",

        "nvim-tree/nvim-web-devicons"
    }
},

-- Images: REMOVE LATER
{
    '3rd/image.nvim',
    enabled = false,
    build = false,
    opts = {},
    config = function ()
        local image = require('image')
        image.setup({
            backend = "kitty",
            processor = "magick_cli", -- or "magick_cli"
            integrations = {
                markdown = {
                    only_render_image_at_cursor = true,
                    floating_windows = true, -- if true, images will be rendered in floating markdown windows
                },
            }
        })
    end
}

}

