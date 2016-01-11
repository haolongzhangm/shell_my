" below add by haolng test 20140819
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

nnoremap <silent> <F4> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1
"let Tlist_Auto_Open = 1
map <F9> :NERDTreeMirror<CR>
map <F9> :NERDTreeToggle<CR>
nn <silent><F3> :exec("NERDTree ".expand('%:h'))<CR>
let NERDTreeWinPos='right'
set nocompatible              " be iMproved, required
filetype off                  " required

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
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'Valloric/ListToggle'
Bundle 'scrooloose/syntastic'
" Avoid a name conflict with L9
Plugin 'user/L9', {'name': 'newL9'}
"YouCompleteMe"
Bundle 'Valloric/YouCompleteMe'
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
"'let g:ycm_error_symbol = 'Er'
"end for YouCompleteMe config
"grep"
"nnoremap <silent> <F6> :Grep<CR>"
"for cscope"
nmap <F5> :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <F6> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <F7> :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <F2> :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <F12> :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <F10> :cs find t <C-R>=expand("<cword>")<CR><CR>
" add this for chinese
let &termencoding=&encoding
set fileencodings=utf-8,gbk
let NERDChristmasTree=1
let NERDTreeAutoCenter=1
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
let NERDTreeHightCursorline=1
let NERDTreeShowLineNumbers=1
"set cscopequickfix=s-,c-,d-,i-,t-,e-
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
"function! ClosePair(char)
"    if getline('.')[col('.') - 1] == a:char
"        return "\<Right>"
"    else
"        return a:char
"    endif
"endfunction
" find result to quickfix
command -nargs=1 Vgthisfile :vimgrep /<args>/ % | copen
command -nargs=1 Vgallfile :vimgrep /<args>/ **/*.* | copen
nmap <C-K> :Vgthisfile <C-R>=expand("<cword>")<CR><CR>
nmap <C-l> :Vgallfile <C-R>=expand("<cword>")<CR><CR>
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
