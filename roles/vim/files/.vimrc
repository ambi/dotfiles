" vi互換モードを無効化する
set nocompatible

" 全角文字の幅設定
set ambiwidth=double

" 長い最終行も表示させる
set display=lastline

" シンタックスハイライト
syntax enable

" ファイルタイプによるプラグイン有効化
filetype indent plugin on

" 文字コードの設定
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8

" ５行の余裕を持ってスクロールする
set scrolloff=5

" バックアップファイルなし
set noswapfile
set nowritebackup
set nobackup

" バックスペースによる削除を有効化
set backspace=indent,eol,start

" ビープ音なし
set novisualbell
set visualbell t_vb=

" カーソルの位置表示を行う
set ruler

" カッコを閉じたときに対応するカッコを強調
set nostartofline

" カッコのマッチ
set matchpairs& matchpairs+=<:>
set showmatch
set matchtime=1

" 折り返し
set wrap

" 自動改行しない
set textwidth=0

" 挿入モードの単語補完で、小文字でも大文字で補完
set infercase

" 検索
set ignorecase
set smartcase
set incsearch
set wrapscan

" タブをスペースに展開する
set expandtab
set smarttab
set smartindent
set shiftwidth=2    
set tabstop=2
set softtabstop=2

" 常にステータスラインを表示する
set laststatus=2

" 置換のときgオプションをデフォルトで有効
set gdefault

" 入力中のコマンドを表示する
set showcmd
set history=10000

" コマンドモードでTABキーによるファイル名補完をする
set wildmenu
set wildmode=list:longest

" バッファを保存していなくても別のバッファを開けるようにする
set hidden

" ステータスライン
set statusline=%F%m%r%h%w\ [%{&fenc!=''?&fenc:&enc}/%{&ff}]\ %Y%=(%l,%v)\ %p%%
