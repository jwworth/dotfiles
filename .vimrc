" ____ ____ ____ ____ ____ 
" ||v |||i |||m |||r |||c ||
" ||__|||__|||__|||__|||__||
" |/__\|/__\|/__\|/__\|/__\|
"
" Jake Worth's Vim Configuration

" Plug ---------------------- {{{
" Requires vim-plug:
" junegunn/vim-plug
if $VIM_PLUGINS != 'NO'
  if filereadable(expand('~/.vimbundle'))
    source ~/.vimbundle
  endif
endif
" }}}

" ALE ---------------------- {{{
let g:ale_fixers = {
\   'css': ['prettier'],
\   'markdown': ['prettier'],
\   'scss': ['prettier'],
\   'html': ['prettier'],
\   'javascript': ['prettier'],
\   'javascript.jsx': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'json': ['prettier'],
\   'python': ['black'],
\   'ruby': ['rubocop'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
\   'yaml': ['prettier']
\}

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'markdown': ['vale']
\}

" Tell ALE to run only linters I've explicitly configured
let g:ale_linters_explicit = 1

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
" }}}

" Settings ---------------------- {{{
" Turn on syntax highlighting
syntax on

" Allow customization of indentation by file type
filetype plugin indent on

" Ignore casing of normal letters
set ignorecase

" Ignore casing when using lowercase letters only
set smartcase

" Show line numbers
set number

" Use a visual bell instead of beeping
set visualbell

" Show 7 lines below and above the cursor on vertical scrolling
set scrolloff=7

" Don't redraw while executing macros (perf)
set lazyredraw

" Command-line completion operates in an enhanced mode
set wildmenu
set wildmode=list:longest,full

" Vertical splits split right
set splitright

" Horizontal splits split below
set splitbelow

" Hides buffers instead of closing them
set hidden

" GUI settings
if has('gui_running')
  set guifont=Monaco:h16
  set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
endif

" Set colors
" Requires vim-colorschemes:
" flazz/vim-colorschemes
set background=dark
colorscheme PaperColor
" }}}

" Mappings ---------------------- {{{
" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Copy to system clipboard
" Borrowed from Vim Hashrocket:
" https://github.com/hashrocket/vim-hashrocket
vnoremap gy "+y

" Substitute the word under cursor (h/t Vidal Ekechukwu)
vnoremap <c-r> "hy:%s/<c-r>h//gc<left><left><left>

" Vidal and Dorian Sort™. Sort the highlighted lines
vnoremap <silent> gs :sort<cr>

" Map common FZF & Ripgrep commmands
" Requires ripgrep:
" BurntSushi/ripgrep
nnoremap <silent> <c-b> :Buffers<cr>
nnoremap <silent> <c-g>g :Rg<cr>
nnoremap <silent> <c-p> :Files<cr>
nnoremap <leader>g :<C-U>execute "Rg ".expand('<cword>') \| cw<CR>

" Open a per-directory markdown scratchpad
nnoremap <leader>q :execute 'tabedit ' . fnameescape(expand('~/buffer-' . fnamemodify(getcwd(), ':t') . '.md'))<CR>
" }}}

" Filetype settings ---------------------- {{{
augroup filetype_gitcommit
  autocmd!
  " Turn on spelling
  autocmd FileType gitcommit setlocal spell
augroup END

augroup filetype_prose
  autocmd!
  " Turn off numbers
  autocmd FileType markdown setlocal nonumber

  " Fix spelling
  autocmd FileType markdown nnoremap <buffer> gsp 1z=

  " Turn on spelling
  autocmd FileType markdown setlocal spell

  " Disable COC
  autocmd FileType markdown,text,gitcommit,asciidoc,rst,org,tex,plaintex let b:coc_enabled = 0
augroup END

augroup filetype_dotfiles
  autocmd!
  " Fold this file on markers
  autocmd FileType vim,zsh setlocal foldmethod=marker
augroup END

augroup vimrc
  autocmd!
  autocmd GuiEnter * set columns=120 lines=70 number
augroup END

augroup filetype_all
  autocmd!
  " Print something when Vim opens
  autocmd VimEnter * ++once echo "Momentum > Urgency"
augroup END
" }}}

command! TILURL let @+ = 'https://www.jakeworth.com/tils/' . expand('%:t:r') . '/'
command! TILOpen execute '!open https://www.jakeworth.com/tils/' . expand('%:t:r') . '/'
