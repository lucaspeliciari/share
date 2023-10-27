-- add my custom plugins to \nvim\lua\custom\plugins\init.lua ????
-- seems to prevent conflicts


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',  opts = {} },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = 'Preview git hunk' })

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({ 'n', 'v' }, ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
                vim.keymap.set({ 'n', 'v' }, '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
            end,
        },
    },

    {
        -- Theme inspired by Atom
        'navarasu/onedark.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme 'onedark'
        end,
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                theme = 'onedark',
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    -- ADDED THIS TO THE CUSTOM Folder
    -- SEE IF IT WORKS
    -- -- Multiple cursors
    -- {
    --   "mg979/vim-visual-multi"
    -- },
    --
    -- -- NERDTree, a file explorer
    -- {
    --   "preservim/nerdtree"
    -- },
    --
    -- -- Minimap
    -- -- does not work because I can't install dependency on Windows (exe just does not run)
    -- --[[ {
    --   'wfxr/minimap.vim'
    -- }, ]]
    --
    -- {
    --   'kevinhwang91/nvim-ufo',
    --   dependencies = {
    --     'kevinhwang91/promise-async'
    --   }
    -- },
    --
    -- -- Pre-requisite for scrollbar
    -- -- Another module from kickstart is blocking this, since it works when by itself
    -- {
    --   'kevinhwang91/nvim-hlslens'
    -- },
    --
    -- -- Scrollbar
    -- {
    --   'petertriho/nvim-scrollbar'
    -- },
    --
    -- -- Icons for NERDTree, should be the last one to load
    -- {
    --   "ryanoasis/vim-devicons"
    -- },

    -- these need the lua folder that comes with kickstart
    require 'kickstart.plugins.autoformat',
    require 'kickstart.plugins.debug',

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
    --    up-to-date with whatever is in the kickstart repo.
    --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        --['<C-d>'] = cmp.mapping.scroll_docs(-4),
        --['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et












----- MY CUSTOM CONFIG -----



-- use a specific python installation, often not necessary
vim.cmd([[ let g:python3_host_prog = 'C:\Users\Lucas\AppData\Local\Programs\Python\Python311\python.exe' ]])


-- autocomplete with ctrl+n or ctrl+p
-- probably not needed with other modules
vim.cmd([[
            " set up dictionary
            if has('unix')
                set dictionary+=/usr/share/dict/words
            else
                set dictionary+=~/AppData/Local/nvim/words  " must place "words" file here if Windows
            endif

            " ???
            filetype plugin on
            set omnifunc=syntaxcomplete#Complete

            set complete+=k  " consider dictionary words when pressing ctrl+n, might be too many words at once

            " another shortcut
            inoremap ,, <C-n>
            inoremap .. <C-p>

            " some shortcuts from stack overflow
            "inoremap ,, <C-x><C-o><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>" : ""<CR>
            "inoremap ,; <C-n><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>" : ""<CR>
            "inoremap ,: <C-x><C-f><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>" : ""<CR>
            "inoremap ,= <C-x><C-l><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>" : ""<CR>
        ]])

-- open autocomplete after typing
-- might be too slow
require('cmp').setup({
    completion = {
        keyword_length = 1,
    },
    sources = {
        { name = 'nvim_lsp', keyword_length = 1, },
    },
})

vim.cmd([[ set number relativenumber ]]) -- relative line numbers
vim.cmd([[ set nostartofline ]])         -- keep cursor in place when scrolling

-- indentation
vim.cmd([[
          set expandtab  " pressing tab will add spaces instead of \t
          set shiftwidth=4 smarttab  " indents will be 4 spaces
          set tabstop=8 softtabstop=0  " tab stops to be different from the indentation width, in order to reduce the chance of tab characters masquerading as proper indents
        ]])

vim.cmd([[
          set termguicolors " more colors!
          " colorscheme desert  " use this if not using a custom theme
        ]])

-- error bells
vim.opt.errorbells = false
vim.opt.visualbell = true

-- show invisible characters based on preset list below
vim.opt.list = true
vim.opt.listchars = {
    tab = "→ ", -- could also use ▶ or ▷, won't really show with the indentation changes above since \t will just be spaces
    --  eol = "↲",
    trail = "⋅",
    --  lead = "⋅",
    extends = "❯",
    precedes = "❮"
}

-- hide ~ in blank lines
vim.opt.fillchars:append("eob: ")

vim.opt.autoread = true -- automatically reload file when an external change to it is detected


vim.opt.backup = false     -- don't use backup files
vim.opt.writebackup = true -- backup the file while editing but delete it after saving to original
--vim.opt.swapfile = false -- don't create swap files for new buffers
vim.opt.updatecount = 200  -- don't write swap files after some number of updates (default is 200)



-- KEYMAPS
local function map(m, k, v)
    vim.keymap.set(m, k, v, { noremap = true, silent = true })
end



-- quickly close brackets
vim.cmd([[
          function! CreateBrackets(char)
              let next_char = getline(".")[col(".")-1]
              if next_char == "" || next_char == " " || next_char == ")" || next_char == "]" || next_char == "}" || next_char == "'" || next_char == '"'
                  return a:char."\<Left>"
              else
                  return a:char[0]
              endif
          endfunction

          inoremap <expr> ( CreateBrackets('()')
          inoremap <expr> [ CreateBrackets('[]')
          inoremap <expr> { CreateBrackets('{}')
          inoremap <expr> " CreateBrackets('""')
          inoremap <expr> ' CreateBrackets("''")
        ]])

-- just skip char instead of writing it again to avoid brackets like ())
vim.cmd([[
          function! JumpOver(char)
              let next_char = getline(".")[col(".")-1]
              if next_char == "" || next_char == " "
                  return a:char[1]
              elseif next_char == a:char[1]
                  return "\<Right>"
              else
                  return a:char[1]
              endif
          endfunction

          inoremap <expr> ) JumpOver('()')
          inoremap <expr> ] JumpOver('[]')
          inoremap <expr> } JumpOver('{}')
        ]])

-- Create bracket indentation, still not good enough
vim.cmd([[
          function! IndentBrackets(char)
              let next_char = getline(".")[col(".")-1]
              if next_char == "" || next_char == " "
                  return a:char[0] . "\<CR>\<Tab>\<C-o>$\<CR>" . a:char[1] . "\<C-o>^\<BS>\<Up>\<C-o>$"
              elseif next_char == ")" || next_char == "]" || next_char == "}"
                  return a:char[0] . "\<CR>\<Tab>\<CR>" . a:char[1] . "\<Left>\<BS>\<Up>\<C-o>$"
              else
                  return "\<CR>\<C-o>^\<C-o>d0" . a:char[0] . "\<CR>\<Tab>\<C-o>$\<CR>" . a:char[1] . "\<C-o>^\<BS>\<Up>\<C-o>$"
              endif
          endfunction

          inoremap <expr> (<CR> IndentBrackets("()")
          inoremap <expr> [<CR> IndentBrackets("[]")
          inoremap <expr> {<CR> IndentBrackets("{}")
        ]])

-- backspace to delete brackets or quotes
vim.cmd([[
            function! DeleteBrackets()
                let next_char = getline(".")[col(".")-1]
                let prev_char = getline(".")[col(".")-2]
                if (prev_char == "(" && next_char == ")") || (prev_char == "[" && next_char == "]") || (prev_char == "{" && next_char == "}") || (prev_char == '"' && next_char == '"') || (prev_char == "'" && next_char == "'")
                    return "\<Right>\<BS>\<BS>"
                else
                    return "\<BS>"
            endfunction

            inoremap <expr> <BS> DeleteBrackets()
        ]])

vim.cmd([[
            function RunCurrentScript()
                if &filetype == 'python'
                    silent !python %
                elseif &filetype == 'powershell'
                    silent !powershell -File %
                endif
            endfunction

            autocmd FileType python,powershell nnoremap <F5> :call RunCurrentScript()<CR>
        ]])


map('i', 'ddd', '<Esc>')

map('n', '<CR>', 'o<Esc>') -- add new line in normal mode

-- indentations
map('n', '<Tab>', '>>')
map('n', '<S-Tab>', '<<')
map('i', '<S-Tab>', '<C-o><<')
map("v", "<S-Tab>", "<gv")
map("v", "<Tab>", ">gv")

map('i', 'main<CR>', 'def main():<CR><Tab>')

map('n', '<C-t>', ':NERDTreeToggle<CR>')

map('n', '<C-p>', '<CMD>vsplit<CR>')

-- how can I set to all modes without repeating stuff like this?
local quit = '<CMD>q<CR>'
local quit_now = '<CMD>q!<CR>'
map({ 'n', 'v', 'i', 'o' }, '<C-q>', quit)
map({ 'n', 'v', 'i', 'o' }, '<C-S-q>', quit_now)

-- move lines up and down
local move_line_up = '<CMD>move .-2<CR>'
local move_line_down = '<CMD>move .+1<CR>'
map({ 'n', 'v', 'i', 'o' }, '<C-S-k>', move_line_up)
map({ 'n', 'v', 'i', 'o' }, '<C-S-j>', move_line_down)
map({ 'n', 'v', 'i', 'o' }, '<C-S-Up>', move_line_up)
map({ 'n', 'v', 'i', 'o' }, '<C-S-Down>', move_line_down)

local move_block_up = 'xkP`[V`]'  -- not working 100% right
local move_block_down = 'xp`[V`]' -- not working 100% right
map('v', '<S-M-k>', move_block_up)
map('v', '<S-M-j>', move_block_down)
map('v', '<S-M-Up>', move_block_up)
map('v', '<S-M-Down>', move_block_down)

-- delete lines with shift+del like other IDEs
map('n', '<S-Del>', 'dd')
map('i', '<S-Del>', '<C-O>dd')

--map('v', '(', '<C-O>i(<C-O>$)')  -- does not work, delete...?

-- backspace in normal mode
map('n', '<BS>', '<Left><Del>')

-- add current datetime, not working
map({ 'n', 'v', 'i', 'o' }, '<S-M-f>', '<C-r>=strftime("%d/%m/%y %R")<CR>')

-- substitute currently selected text in entire file
map('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>')
map('v', '<C-h>', '"hy:%s/<C-r>h//gc<left><left><left>')

-- search selected text, use n to find next
-- can also use this to replace, since leaving searched text empty in the substitute string will consider last selection
-- so ctrl+f to select then :%s//replaced_text
map('v', '<C-f>', 'y<ESC>/<c-r>"<CR>')

-- map undo to CTRL+Z as well
map({ 'i', 'n', 'v' }, '<C-z>', '<C-O>u<CR>')

-- select all with CTRL+a
map('n', '<C-a>', '<C-O>ggVG')

-- scroll with a sensible shortcut
map({ 'i', 'n', 'v' }, '<C-j>', '<C-d>')
map({ 'i', 'n', 'v' }, '<C-k>', '<C-u>')

-- tabs
map('n', '<C-n>', '<CMD>tabe<CR>')
map('n', '<C-Tab>', '<CMD>tabn<CR>')

-- split windows
map('n', '<C-p>', '<CMD>vsplit<CR>')
map('n', '<C-m>', '<CMD>split<CR>')
local left_window = ':wincmd h<CR>'
local right_window = ':wincmd l<CR>'
local up_window = ':wincmd k<CR>'
local down_window = ':wincmd j<CR>'
map('n', '<M-l>', right_window)
map('n', '<M-h>', left_window)
map('n', '<M-k>', up_window)
map('n', '<M-j>', down_window)
map('n', '<M-Right>', right_window)
map('n', '<M-Left>', left_window)
map('n', '<M-Up>', up_window)
map('n', '<M-Down>', down_window)


-- Restore cursor position when opening file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})



-- NERDTREE
-- Start NERDTree when Vim is started without file arguments
-- vim.cmd([[
--           autocmd StdinReadPre * let s:std_in=1
--           autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
--         ]])
-- Exit Vim if NERDTree is the only window remaining in the only tab.
vim.cmd(
    [[ autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif ]])
-- Close the tab if NERDTree is the only window remaining in it.
vim.cmd([[ autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif ]])



-- config for hlslens (scrollbar prerequisite)
require('hlslens').setup()
local kopts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

-- start scrollbar with specified parameters --
require("scrollbar").setup()
--E.g. the following marks the first three lines in every buffer.
require("scrollbar.handlers").register("my_marks", function(bufnr)
    return {
        { line = 0 },
        { line = 1, text = "x",    type = "Warn" },
        { line = 2, type = "Error" }
    }
end)



-- UFO config
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
-- Option 3: treesitter as a main provider instead
require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
    end
})



-- Minimap setup
--require("minimap").setup()



-- set nerd font
--vim.opt.guifont="Hack Nerd Font Mono:h12"

-- does not work
--vim.cmd([[
--function! SubstituteOnSave()
--    let replaceString = "REPLACED"
--    if search(replaceString, 'nw') > 0  " return line number
--        echo "AQUI: ".search(replaceString, 'nw')
--        %s/\s$/REPLACED/g
--    endif
--endfunction
--
--autocmd BufWritePost * call SubstituteOnSave()
--]])
