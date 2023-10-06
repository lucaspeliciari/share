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


vim.cmd([[ set number relativenumber ]])  -- relative line numbers
vim.cmd([[ set nostartofline ]])  -- keep cursor in place when scrolling


-- KEYMAPS
local function map(m, k, v)
    vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

-- quickly close quotes, this function might be redundant
vim.cmd([[
          function! CreateQuotes(char)
              let next_char = getline(".")[col(".")-1]
              if next_char != a:char[0]
                  return a:char."\<Left>"
              else
                  return a:char[0]
              endif
          endfunction

        inoremap <expr> ' CreateQuotes("''")
          inoremap <expr> " CreateQuotes('""')
        ]])

-- quickly close brackets
vim.cmd([[
          function! CreateBrackets(char)
              let next_char = getline(".")[col(".")-1]
              if next_char == "" || next_char == " " || next_char == a:char[1]
                  return a:char."\<Left>"
              else
                  return a:char[0]
              endif
          endfunction

          inoremap <expr> ( CreateBrackets('()')
          inoremap <expr> [ CreateBrackets('[]')
          inoremap <expr> { CreateBrackets('{}') 
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

-- Create bracket indentation
vim.cmd([[
          function! IndentBrackets(char)
              let next_char = getline(".")[col(".")-1] 
              if next_char == "" && next_char == " "
                  return "\<C-o>^\<C-o>d0" . a:char[0] . "\<CR>\<Tab>\<C-o>$\<CR>" . a:char[1] . "\<C-o>^\<BS>\<Up>\<C-o>$"
              else
                  return "\<CR>\<C-o>^\<C-o>d0" . a:char[0] . "\<CR>\<Tab>\<C-o>$\<CR>" . a:char[1] . "\<C-o>^\<BS>\<Up>\<C-o>$"
              endif
          endfunction

          inoremap <expr> (<CR> IndentBrackets("()")
          inoremap <expr> [<CR> IndentBrackets("[]")
          inoremap <expr> {<CR> IndentBrackets("{}")
        ]])
 
-- Backspace in normal mode that also deletes newline when it is empty
-- does not work at all
vim.cmd([[
          function! HandleBackspace()
              let previous_char = getline(".")[col(".")]  " is this how this works?
              return '\<BS>'
          endfunction

          "nnoremap <expr> <BS> HandleBackspace()
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
map('n', '<C-q>', quit)
map('n', '<C-S-q>', quit_now)
map('i', '<C-q>', quit)
map('i', '<C-S-q>', quit_now)
map('v', '<C-q>', quit)
map('v', '<C-S-q>', quit_now)
map('o', '<C-q>', quit)
map('o', '<C-S-q>', quit_now)

-- move lines up and down
local move_line_up = '<CMD>move .-2<CR>'
local move_line_down = '<CMD>move .+1<CR>'
map('n', '<S-M-k>', move_line_up)
map('n', '<S-M-j>', move_line_down)
map('n', '<S-M-Up>', move_line_up)
map('n', '<S-M-Down>', move_line_down)

local move_block_up = 'xkP`[V`]'  -- not working 100% right
local move_block_down = 'xp`[V`]'  -- not working 100% right
map('v', '<S-M-k>', move_block_up)
map('v', '<S-M-j>', move_block_down)
map('v', '<S-M-Up>', move_block_up)
map('v', '<S-M-Down>', move_block_down)

-- delete lines with shift+del like other IDEs
map('n', '<S-Del>', 'dd')
map('i', '<S-Del>', '<C-O>dd')

map('v', '(', '<C-O>i(<C-O>$)')  -- does not work

-- backspace in normal mode
map('n', '<BS>', '<Left><Del>')

-- add current datetime
map('n', '<S-M-f>', 'Teste')

-- substitute currently selected text in entire file
map('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>')
map('v', '<C-h>', '"hy:%s/<C-r>h//gc<left><left><left>')

-- search selected text, use n to find next
-- can also use this to replace, since leaving searched text empty in the substitute string will consider last selection
-- so ctrl+f to select then :%s//replaced_text 
map('v', '<C-f>', 'y<ESC>/<c-r>"<CR>')



-- Restore cursor position when opening file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})
