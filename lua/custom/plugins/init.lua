-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    -- Multiple cursors
    {
        "mg979/vim-visual-multi"
    },

    -- NERDTree, a file explorer
    {
        "preservim/nerdtree"
    },

    -- Minimap
    -- does not work because I can't install dependency on Windows (exe just does not run)
    --[[ {
    'wfxr/minimap.vim'
  }, ]]

    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        }
    },

    -- Pre-requisite for scrollbar
    -- Another module from kickstart is blocking this, since it works when by itself
    {
        'kevinhwang91/nvim-hlslens'
    },

    -- Scrollbar
    {
        'petertriho/nvim-scrollbar'
    },

    -- Icons for NERDTree, should be the last one to load
    {
        "ryanoasis/vim-devicons"
    },
}
