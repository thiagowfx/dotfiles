" no vi
set nocompatible
 
" plug-ins (should come first)
execute pathogen#infect()

" plug-in settings
let g:airline_theme='luna'
"let g:airline_powerline_fonts=1

let g:syntastic_cpp_compiler_options='-std=c++11'

" colorscheme
colorscheme molokai

" syntax highlighting
filetype plugin indent on
syntax on

" set the leader key
let mapleader=","

" user mappings with the leader key
map <Leader>a ggVG
map <Leader>m :make<CR>
map <Leader>s :sort<CR>

" user mappings
inoremap jj <ESC>
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
nmap <C-x><C-p> :bprev<CR>
nmap <C-x><C-n> :bnext<CR>
nnoremap / /\v
nnoremap ? ?\v
vnoremap / /\v
vnoremap ? ?\v

" user settings
set backspace=indent,eol,start
execute "set colorcolumn=" . join(range(81,335), ',')
set encoding=utf-8 fileencodings=utf-8 termencoding=utf-8
set nofoldenable foldmethod=indent
set history=10000 laststatus=2 modelines=0
set ignorecase infercase smartcase
set incsearch hlsearch showmatch wrapscan
set mouse=a ttymouse=xterm2
set cursorline number ruler showcmd showmode scrolloff=5
"
" Indentation/tabs/etc
"
" Normal
set shiftwidth=2 shiftround tabstop=2 softtabstop=2 expandtab smarttab smartindent
"
" Linux Kernel development style
"
" set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
"
set t_Co=256
set ttimeout ttimeoutlen=100 visualbell
set ttyfast lazyredraw
set wildmenu wildmode=longest,list:longest
set nobackup 
" set undofile

" user functions
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
