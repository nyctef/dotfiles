filetype off                  " required

""""""""""" VUNDLE BEGIN
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
let path='~/.vim/bundle'
call vundle#begin(path)

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

""""""""""" VUNDLE PLUGIN LIST

Plugin 'jelera/vim-javascript-syntax'

Plugin 'pangloss/vim-javascript'

Plugin 'nathanaelkane/vim-indent-guides'

Plugin 'scrooloose/syntastic'
let g:syntastic_check_on_open=1

Plugin 'tpope/vim-dispatch'

Plugin 'kien/ctrlp.vim'

Plugin 'quanganhdo/grb256'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"""""""""""" VUNDLE END


" general vim settings
set t_Co=256
colorscheme grb256
syntax on
set number                    " Display line numbers
set numberwidth=3
set title                     " show title in console title bar

"set cursorline              " have a line indicate the cursor location
set ruler                   " show the cursor position all the time
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=indent,eol,start " Allow backspacing over insert boundaries
set showmatch               " Briefly jump to a paren once it's balanced
set nowrap                  " don't wrap text
set linebreak               " don't wrap textin the middle of a word
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well
set foldmethod=indent       " allow us to fold on indents
set foldlevel=99            " don't fold by default

""" indentation
set tabstop=4               " <tab> inserts 4 spaces 
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set smarttab                " Handle tabs more intelligently 
set autoindent              " always set autoindenting on
set smartindent             " use smart indent if there is no indent file

set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.
set autoread                " automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches ..
set smartcase               " .. unless uppercase letters are used in the regex.
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

""" dump .swp and other backup files in .vim
set backupdir=~/.vim//
set directory=~/.vim//
set undodir=~/.vim//

au FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent
au FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 smartindent

" edit vimrc
nnoremap <leader>ev :vsp $MYVIMRC<cr>
" source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" go to start of line
nnoremap H ^
" go to end of line
nnoremap L $

" another way to exit insert mode
inoremap jk <esc>
inoremap <esc> <nop>
inoremap <c-c> <nop>

" clear search hilight
nnoremap <leader>h :noh<cr>

" some git aliases
nnoremap <leader>st :!git status --untracked-files=all<cr>
nnoremap <leader>cia :silent !git cia<cr>

" http://vim.wikia.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
set cmdheight=3

augroup csharp
    autocmd!
    " for cs files, write when leaving insert mode or pausing in normal mode
    " for <updatetime> ms
    autocmd FileType cs :autocmd csharp CursorHold,InsertLeave <buffer> silent write
augroup END

" trigger CursorHold and .swp file writes after 500ms
set updatetime=500

" set default window size for gvim
if has("gui_running")
    set lines=50 columns=200
endif

" search for TODO and FIXME in pwd and list in quickfix window
nnoremap <leader>d :vimgrep /TODO\\|FIXME/j **/*.cs \| :cw<cr>

" ignore spurious ^M characters in COMMIT_EDITMSG files
augroup gitcommit
    autocmd!
    autocmd FileType gitcommit match Ignore /\r$/
augroup END
