source $VIMRUNTIME/defaults.vim

set number
set list
set listchars=tab:-->,space:･,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set hlsearch
set incsearch
set smartindent

hi NonText      ctermbg=None ctermfg=59 guibg=NONE guifg=NONE
hi SpecialKey   ctermbg=None ctermfg=59 guibg=NONE guifg=NONE

"ファイルタイプの設定"
filetype on
filetype plugin indent on

autocmd BufNewFile,BufRead */.ssh/config.d/* setfiletype sshconfig

"vim-plug"
call plug#begin()
Plug 'editorconfig/editorconfig-vim'
call plug#end()
