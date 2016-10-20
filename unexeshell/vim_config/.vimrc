" below add by haolng test 20140819
"===================misc for vim================
set nu
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
syntax on
set nocp
set completeopt=preview,menu
set completeopt=longest,menu
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set hlsearch incsearch ignorecase
"==================end for vim misc==============

"==========for TlistToggle and Nerdtree===================
nnoremap <silent> <F4> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1
"let Tlist_Auto_Open = 1
map <F9> :NERDTreeMirror<CR>
map <F9> :NERDTreeToggle<CR>
nn <silent><F3> :exec("NERDTree ".expand('%:h'))<CR>
let NERDTreeWinPos='right'
set nocompatible              " be iMproved, required
filetype off                  " required
let NERDChristmasTree=1
let NERDTreeAutoCenter=1
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
let NERDTreeHightCursorline=1
let NERDTreeShowLineNumbers=1
nnoremap <C-a> :let Tlist_WinWidth=43
"==========end for TlistToggle and Nerdtree=============

""==========for bundle====================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'wincent/command-t'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'Valloric/ListToggle'
Bundle 'scrooloose/syntastic'
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}
"YouCompleteMe"
Bundle 'Valloric/YouCompleteMe'
"nerdtree"
Bundle 'scrooloose/nerdtree'
"cctree"
Bundle 'hari-rangarajan/CCTree'
"ctrip"
Bundle 'kien/ctrlp.vim'
"vim-powerline""same no use for me"
"Bundle 'Lokaltog/vim-powerline'
"install plugn : PluginInstall"
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"=======================end bundle=================

"===================for YouCompleteMe==============
""""""""""syntastic""""""""""""
"F2 use to cs find f, caused by F8 to youdao
"nmap <F2> :YcmDiags<CR>
"below for YouCompleteMe config
let g:ycm_global_ycm_extra_conf = '~/shell_my/unexeshell/vim_config/YouCompleteMe_config/.default_ycm_extra_conf.py'
autocmd BufNewFile,BufRead *.c let g:ycm_global_ycm_extra_conf = '~/shell_my/unexeshell/vim_config/YouCompleteMe_config/.c99_ycm_extra_conf.py'
"let g:ycm_key_invoke_completion = '<C-/>'
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_collect_identifiers_from_tags_files = 1
"let g:ycm_add_preview_to_completeopt = 1
let g:ycm_error_symbol = 'Er'
let g:ycm_warning_symbol = 'Wr'
highlight YcmErrorSection guibg=#000000
highlight YcmWarningSection guibg=#000000
"======================end for YouCompleteMe config=======

"===============for cscope===========================
nmap <F5> :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <F6> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <F7> :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <F2> :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <F12> :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <F10> :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-u> :tnext<CR><CR>
nmap <C-y> :tprevious<CR><CR>
"set cscopequickfix=s-,c-,d-,i-,t-,e-
"===============end cscope===========================

"=========== add this for chinese====================
let &termencoding=&encoding
set fileencodings=utf-8,gbk
"===========end for chinese=========================

"===========add for match===========================
set showmatch
"add for vim { < ( match
inoremap ( ()<ESC>i
""inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {<CR>}<ESC>O
""inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ []<ESC>i
""inoremap ] <c-r>=ClosePair(']')<CR>
inoremap " ""<ESC>i
inoremap ' ''<ESC>i
"=============end for match==========================

"=========add for comman=============================
command -nargs=1 Vgthisfile :vimgrep /<args>/ % | copen
command -nargs=1 Vgallfile :vimgrep /<args>/ **/*.* | copen
noremap <C-K> :Vgthisfile <C-R>=expand("<cword>")<CR><CR>
noremap <C-l> :Vgallfile <C-R>=expand("<cword>")<CR><CR>
command -nargs=0 Clearblank :%s/\s\+$//
"auto load ctags file
function! AddCtagsDatabase()
    let max = 30
    let dir = './'
    let i = 0
    let break = 0
    while isdirectory(dir) && i < max
        if filereadable(dir . 'tags')
            execute 'set tags =' . dir . 'tags'
            let break = 1
        endif
        if break == 1
            execute 'lcd ' . dir
            break
        endif
        let dir = dir . '../'
        let i = i + 1
    endwhile
endfunction
call AddCtagsDatabase()
"use system  clipboard
noremap y "+y
noremap Y "+Y
"map C-j to show buffers
nnoremap <C-j> :buffers<CR>:b<Space>
"=================end for add command===========
"=================add for cscope reset========="
map <c-p> :cscope reset<CR>
"=================end for cscope reset========="

"=========add for config ctrlp.vim=============
let g:ctrlp_map = '<c-i>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
    \ }
let g:ctrlp_working_path_mode='a'
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=2000
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=50000
let g:ctrlp_follow_symlinks=1
let g:ctrlp_max_depth = 40
"=================end for ctrip================

"==================add for cctree========
""cctree have some issue, leave for later
"==================end for cctree========

"=================add for command-t======
let g:CommandTMaxFiles=110000
let g:CommandTMaxDepth=40
let g:CommandTMaxHeight=200
let g:CommandTInputDebounce=100
"let g:CommandTMinHeight=50
let g:CommandTMatchWindowAtTop=0
let g:CommandTMatchWindowReverse=0
"let g:CommandTCancelMap='<Esc>'
let g:CommandTWildIgnore="*.o,*.obj"
nnoremap <C-h> :CommandT .
"if you want to find file from git root dir ,you can use :CommandT
"==================end for command-t=====

"==================add for quick show func by enter 'f'========
fun! ShowFuncName()
	let lnum = line(".")
	let col = col(".")
	echohl ModeMsg
	echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
	echohl None
	call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>
map F :call ShowFuncName() <CR>
"==================end for quick show func by enter 'f'========
"=========merge vim80 vimrc_example.vim =======================
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Jul 28
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval')
  packadd matchit
endif
"=========end merge vim80 vimrc_example.vim =======================
