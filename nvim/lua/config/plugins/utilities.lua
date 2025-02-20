--==========================================
--Utilities
--==========================================
local harpoon_config = function()
	local harpoon = require("harpoon")

	-- REQUIRED
	harpoon:setup()
	-- REQUIRED

	vim.keymap.set("n", "<leader>h", function() harpoon:list():add() end)

	vim.keymap.set("n", "<leader>a", function() harpoon:list():select(1) end)
	vim.keymap.set("n", "<leader>s", function() harpoon:list():select(2) end)
	vim.keymap.set("n", "<leader>d", function() harpoon:list():select(3) end)
	vim.keymap.set("n", "<leader>f", function() harpoon:list():select(4) end)

	-- Toggle previous & next buffers stored within Harpoon list
	vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
	vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

	vim.keymap.set("n", "<C-S-H>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
end

local git_signs_config = function()
	require('gitsigns').setup{
		on_attach = function(bufnr)
			local gitsigns = require('gitsigns')

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map('n', ']c', function()
				if vim.wo.diff then
					vim.cmd.normal({']c', bang = true})
				else
					gitsigns.nav_hunk('next')
				end
			end)

			map('n', '[c', function()
				if vim.wo.diff then
					vim.cmd.normal({'[c', bang = true})
				else
					gitsigns.nav_hunk('prev')
				end
			end)

			-- Actions
			map('n', '<leader>hs', gitsigns.stage_hunk)
			map('n', '<leader>hr', gitsigns.reset_hunk)
			map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
			map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
			map('n', '<leader>hS', gitsigns.stage_buffer)
			map('n', '<leader>hu', gitsigns.undo_stage_hunk)
			map('n', '<leader>hR', gitsigns.reset_buffer)
			map('n', '<leader>hp', gitsigns.preview_hunk)
			map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
			map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
			map('n', '<leader>hd', gitsigns.diffthis)
			map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
			map('n', '<leader>hN', gitsigns.toggle_signs)

			-- Text object
			map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
		end
	}
end

local autopair_opt = {
    enable_check_bracket_line = false
}

return {
    -- Autopairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
        opts = autopair_opt
    },

    -- Tpope commands
    { "tpope/vim-surround", event = "VeryLazy" },
    { "tpope/vim-fugitive",
    config = function()
        -- Remaps for Fugitive
        vim.keymap.set("n", "<leader>g", ":vert Git<CR>")
        vim.keymap.set("n", "<leader>G", ":Git push<CR>")
    end,
    event = "VeryLazy"
    },
    "tpope/vim-commentary",
    {
        "lewis6991/gitsigns.nvim",
        config = git_signs_config,
        event = "VeryLazy"
    },


    -- Harpoon | Markers
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = harpoon_config,
        event = "VeryLazy"
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeShow"
    },
}

