
"[======= VUNDLE PLUGINS ========]"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'itchyny/lightline.vim'
Plugin 'vim-scripts/pdftotext'

call vundle#end()           
filetype plugin indent on 

"[======== VIMRC STUFF  =========]"

syntax on 
colorscheme northpole 
"colorscheme perun 
colorscheme turtles

"[======== TAB SETTINGS =========]"

set tabstop=3
set shiftwidth=3
set expandtab
set number 

"[======== SPLIT SETTINGS =======]"

set splitbelow 
set splitright

"[======== FOLD SETTINGS ========]"

set foldcolumn=1
set foldlevel=1
set foldlevelstart=99
set foldmethod=indent

"[=========== KEY MAP ===========]"

nnoremap <C-down> <C-W><C-J>
nnoremap <C-up> <C-W><C-K>
nnoremap <C-right> <C-W><C-L>
nnoremap <C-left> <C-W><C-H>

map <C-a> <esc>ggVG<CR>
set mouse=a

"[====== STATUS BAR CONFIG ======]"

set laststatus=2 " always show the statusbar line
set noshowmode   " don't show mode as it's handled by lightline

let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste'  ],
  \             [ 'readonly', 'filename', 'modified'  ] ],
  \   'right': [ [ 'percent'  ],
  \              [ 'lineinfo'  ],
  \              [ 'filetype', 'fileencoding', 'fileformat'  ] ],
  \ },
  \ 'inactive': {
  \   'left': [ [  ], [ 'readonly', 'filename', 'modified'  ]  ],
  \   'right': [ [  ], [  ], [  ], [ 'filetype'  ]  ],
  \ },
  \ 'component_function': {
  \   'filename': 'LightLineFilename',
  \ },
\}

function! LightLineFilename()
  return expand('%')
endfunction


