" Plug ---------------------- {{{
" Requires vim-plug:
" https://github.com/junegunn/vim-plug
if $VIM_PLUGINS != 'NO'
  if filereadable(expand('~/.vimbundle'))
    source ~/.vimbundle
  endif
endif
" }}}

" ALE ---------------------- {{{
let g:ale_sign_error = 'X'
let g:ale_sign_warning = '!'

highlight link ALEWarningSign ErrorMsg
highlight link ALEErrorSign WarningMsg

let g:ale_fixers = {
      \   'bash': ['shfmt'],
      \   'elixir': ['mix_format'],
      \   'javascript': ['prettier'],
      \   'typescript': ['prettier'],
      \   'javascript.jsx': ['prettier'],
      \   'typescriptreact': ['prettier'],
      \   'json': ['prettier'],
      \   'ruby': ['rubocop'],
      \   'scss': ['prettier'],
      \   'vue': ['prettier'],
      \   'zsh': ['shfmt'],
      \}

let g:ale_linters_ignore = {
      \   'vue': ['eslint'],
      \}

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

" Allow a separate .vimrc in any directory
set secure
set exrc

" Use a visual bell instead of beeping
set visualbell

" Show 7 lines below and above the cursor on vertial scrolling
set so=7

" Don't redraw while executing macros (perf)
set lazyredraw

" Command-line completion operates in an enhanced mode
set wildmenu
set wildmode=list:longest,full

" Vertical splits split right
set splitright

" Splits split below
set splitbelow

" Hides buffers instead of closing them
set hidden

" GUI settings
set guifont=Monaco:h16
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r

" Use Bash as my shell
set shell=bash

" Set default colors
colorscheme PaperColor

" Allow Vim-JSX to highlight *.js files
let g:jsx_ext_required = 0

" Turn on vim-closetag for JavaScript
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'

" Configure vim-mix-format
let g:mix_format_on_save = 1
let g:mix_format_options = '--check-equivalent'
let g:mix_format_silent_errors = 1

" Restore Netrw hidden file list that's expanded in vim-vinegar
" See: https://github.com/tpope/vim-vinegar/issues/18
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" }}}

" Mappings ---------------------- {{{
" Disable arrow keys (helped me learn Vim, and I do not use them)
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" Shows the output from Prettier
nnoremap <leader>pt :!prettier %<CR>

" Substitute the word under cursor (h/t Vidal Ekechukwu)
vnoremap <c-r> "hy:%s/<c-r>h//gc<left><left><left>

" Search for word under cursor
" Requires ripgrep:
" https://github.com/BurntSushi/ripgrep
nnoremap <leader>g :<C-U>execute "Rg ".expand('<cword>') \| cw<CR>

" Remove ^M linebreaks
nnoremap gsp :e ++ff=dos<cr>:w<cr>

" Vidal and Dorian Sort™. Sort the highlighted lines
vnoremap <silent> gs :sort<cr>

" Insert a UUID with Ruby
nnoremap ruid :read !ruby -e "require 'securerandom'; p SecureRandom.uuid"<cr>

" Insert a date
nnoremap date :put =strftime('%FT%T%z')<cr>

" Open a buffer for note-taking
nnoremap <leader>q :e .scratch<cr>i<cr>

" Map common FZF commmands
" Requires ripgrep:
" https://github.com/BurntSushi/ripgrep
nnoremap <silent> <c-b> :Buffers<cr>
nnoremap <silent> <c-g>g :Rg<cr>
nnoremap <silent> <c-p> :Files<cr>

" Yank the path of the current buffer into the paste buffer
nnoremap yf :let @+ = expand('%:p') <cr>

" Yank file and line number under cursor (great for code reviews)
nnoremap <silent> yfl :let @" = join([expand('%'), line(".")], ':')<cr>

" Show me the Vim highlight for word under a cursor (for writing Vim plugins)
" https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nnoremap <leader>sp :call <SID>SynStack()<CR>

function! <SID>SynStack() abort
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" }}}

" Filetype settings ---------------------- {{{
augroup filetype_crontab
  autocmd!
  " Allow Vim to overwrite the crontab
  autocmd FileType crontab setlocal backupcopy==yes
augroup END

augroup filetype_docs
  autocmd!
  " Turn off numbers
  autocmd FileType markdown setlocal nonumber

  " Turn on spelling
  autocmd FileType markdown setlocal spell
augroup END

augroup filetype_vim
  autocmd!
  " Fold this file on markers
  autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup filetype_haml
  autocmd!
  " Line up HAML linebreak pipes
  autocmd FileType haml vnoremap <silent> ta :Tabularize /\|<cr>

  " Fold on indents
  autocmd FileType haml setlocal foldmethod=indent
augroup END

augroup filetype_ruby
  " Run Rubocop
  nnoremap <leader>ru :! rubocop -a % <cr>
augroup END

augroup vimrc
  autocmd!
  autocmd GuiEnter * set columns=120 lines=70 number
augroup END

augroup filetype_all
  autocmd!
  " Print something when Vim opens
  autocmd VimEnter * :echo "Momentum > Urgency"
augroup END
" }}}

" Testing ---------------------- {{{
" }}}
