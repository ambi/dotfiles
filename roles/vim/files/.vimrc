" Character encoding (UTF-8)
set ambiwidth=double
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix
scriptencoding utf-8

" filetype
filetype indent plugin on

" Display
set display=lastline
set scrolloff=5
set ttyfast
syntax enable

" Backspace
set backspace=indent,eol,start

" Visual bell
set novisualbell
set visualbell t_vb=

" Position
set ruler

" Match parentheses
set matchpairs& matchpairs+=<:>
set matchtime=1
set showmatch

" Completion
set infercase

" Search
set gdefault
set hlsearch
set ignorecase
set incsearch
set smartcase
set wrapscan

" Tab, space, and indent
set autoindent
set cindent
set expandtab
set shiftwidth=2    
set smarttab
set smartindent
set softtabstop=2
set tabstop=2

" Command
set history=10000
set showcmd
set wildmenu
set wildmode=list:longest

" File
set autoread
set hidden
set nobackup
set noswapfile

" Status line
set laststatus=2
set statusline=%F%m%r%h%w\ [%{&fenc!=''?&fenc:&enc}/%{&ff}]\ %Y%=(%l,%v)\ %p%%

" OS
set mouse=a
set shellslash

