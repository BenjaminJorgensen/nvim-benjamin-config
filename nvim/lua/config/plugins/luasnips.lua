local luasnip_config = function()
    local luasnip = require("luasnip")
    local jumpers = function()
        -- If there are no jumpables, attempt to jump to bracket
        if not luasnip.jumpable(1) then
            local search_result = vim.fn.searchpos('[\"\\]\'\')}]', 'Wc')
            local lnum = search_result[1]
            local col = search_result[2]
            if lnum ~= 0 and col ~= 0 then -- Ensure a match was found
                vim.api.nvim_win_set_cursor(0, {lnum, col})
            end
            return
        end

        local jumpdest = luasnip.jump_destination(1)
        if jumpdest and jumpdest.get_buf_position then
            local posjump = jumpdest:get_buf_position()
            local posthing = vim.fn.searchpos('[\"\\]\'\')}]', 'Wnc')
            if posthing and ((posjump[1] + 1) < posthing[1] or ((posjump[1] + 1) == posthing[1] and posjump[2] < posthing[2])) then
                print('seraching jumpx' .. posthing[1] .. 'jumpy' .. posthing[2])
                print('jumping jumpx' .. posjump[1] .. 'jumpy' .. posjump[2])
                luasnip.jump(1)
            else
                local lnum = posthing[1]
                local col = posthing[2]
                if lnum ~= 0 and col ~= 0 then -- Ensure a match was found
                    vim.api.nvim_win_set_cursor(0, {lnum, col})
                end
                return
            end
        else
            local search_result = vim.fn.searchpos('[\"\\]\'\')}]', 'Wc')
            local lnum = search_result[1]
            local col = search_result[2]
            if lnum ~= 0 and col ~= 0 then -- Ensure a match was found
                vim.api.nvim_win_set_cursor(0, {lnum, col})
            end
            return
        end
    end
    vim.keymap.set("i", "jk", function() jumpers() end)
    vim.keymap.set("s", "jk", function() jumpers() end)

    -- require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/luasnip/"})
    -- require("luasnip.loaders.from_vscode").lazy_load()

    luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged, TextChangedI",
        enable_autosnippets = true,
    })

end

return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = luasnip_config
    }
}

