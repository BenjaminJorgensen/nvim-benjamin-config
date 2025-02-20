--==========================================
--TreeSitter
--==========================================
local tree = function()
    require'nvim-treesitter.configs'.setup {

    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {"css", "html", "javascript", "typescript", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "haskell"},

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    highlight = {
	enable = true,
	additional_vim_regex_highlighting = { "markdown" },
	disable = { "latex", "text", "cabal"},

	-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
	-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
	-- Using this option may slow down your editor, and you may see some duplicate highlights.
	-- Instead of true it can also be a list of languages
	--additional_vim_regex_highlighting = false,
    },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
	}
    }
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "VeryLazy",
        config = tree
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- event = "VeryLazy",
        dependencies = "nvim-treesitter/nvim-treesitter"
    }
}

