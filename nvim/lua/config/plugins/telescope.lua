--==========================================
--TELESCOPE
--==========================================
local config = function()
    local builtin = require('telescope.builtin')
    local actions = require('telescope.actions')

	-- Keymaps for Telescope
	vim.keymap.set('n', '<leader>pF', builtin.git_files, {})
	vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
	vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
	-- vim.keymap.set('n', '<leader>ph', hoogle.help_tags, {})
	vim.keymap.set('n', '<leader>po', builtin.oldfiles, {})
	vim.keymap.set('n', '<leader>pj', builtin.jumplist, {})
	vim.keymap.set('n', '<leader>pw', builtin.grep_string, {})
	vim.keymap.set('v', '<leader>pw', builtin.grep_string, {})
	vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
	vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {})
	vim.keymap.set('n', '<leader>pm', builtin.man_pages, {})
	vim.keymap.set('n', '<leader>pk', builtin.keymaps, {})

	require("telescope").setup({
        pickers = {
            help_tags = {
                mappings = {
                    i = {
                        ["<CR>"] = actions.select_vertical
                    },
                }
            },
            man_pages = {
                mappings = {
                    i = {
                        ["<CR>"] = actions.select_vertical
                    },
                }
            }
        },
		defaults = {
            -- color_devicons = false,
			mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous
				}
			},

            preview = {
                treesitter = false;
            },

			-- For latex stuff
			file_ignore_patterns = {
				"%.aux", "%.fdb_latexmk", "%.fls", "%.log", "%.pdf", "%.synctex.gz"
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,                    -- false will only do exact matching
				override_generic_sorter = true,  -- override the generic sorter
				override_file_sorter = true,     -- override the file sorter
				case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			}
		},
	})

-- Telescope UI for code actions
require("telescope").load_extension("ui-select")
require('telescope').load_extension('fzf')
require("telescope").load_extension('hoogle')
end

return {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = {'nvim-lua/plenary.nvim'},
		config = config
	},
	{'nvim-telescope/telescope-ui-select.nvim' },

    {'luc-tielen/telescope_hoogle',
        ft='haskell',
    },


	{ 'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
	}
}
