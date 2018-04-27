" below add by haolong.zhang test 20140819
"===================misc for vim=================================
set nu
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
syntax on
set nocp
set completeopt=preview,menu
set completeopt=longest,menu
set autoindent
set smartindent
au BufNewFile,BufRead *.cu set filetype=cpp
au BufNewFile,BufRead *.opencl set filetype=cpp
au BufNewFile,BufRead *.cl set filetype=cpp
"===================add for codestyle switch=====================
function! LinuxCodestyle()
	set tabstop=8
	set shiftwidth=8
	set noexpandtab
endfunction

function! GoogleCodestyle()
	set tabstop=2
	set shiftwidth=2
	set expandtab
endfunction
autocmd BufNewFile,BufRead *.c call LinuxCodestyle()
autocmd BufNewFile,BufRead *.cpp call GoogleCodestyle()
autocmd BufNewFile,BufRead *.cc call GoogleCodestyle()
autocmd BufNewFile,BufRead *.c++ call GoogleCodestyle()
autocmd BufNewFile,BufRead *.java call GoogleCodestyle()
autocmd BufNewFile,BufRead *.aidl call GoogleCodestyle()
autocmd BufNewFile,BufRead *.mk call GoogleCodestyle()
autocmd BufNewFile,BufRead *.cu call GoogleCodestyle()
autocmd BufNewFile,BufRead *.hpp call GoogleCodestyle()
autocmd BufNewFile,BufRead *.opencl call GoogleCodestyle()
autocmd BufNewFile,BufRead *.vim call GoogleCodestyle()
"===================end add for codestyle switch==================
set hlsearch incsearch ignorecase
if has("gui_running")
colorscheme industry
endif
nmap <F3> :!goldendict <C-R>=expand("<cword>")<CR><CR>
"==================end for vim misc==============================

"==========for TlistToggle and Nerdtree==========================
nnoremap <silent> <F4> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1
"let Tlist_Auto_Open = 1
map <F9> :NERDTreeMirror<CR>
map <F9> :NERDTreeToggle<CR>
"nn <silent><F3> :exec("NERDTree ".expand('%:h'))<CR>
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
"==========end for TlistToggle and Nerdtree=====================

"==========for bundle===========================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.Vim'
"Plugin 'tpope/vim-fugitive'
"Plugin 'L9'
Plugin 'wincent/command-t'
"Plugin 'file:///home/gmarik/path/to/plugin'
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'Valloric/ListToggle'
"Bundle 'scrooloose/syntastic'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/nerdtree'
"Bundle 'hari-rangarajan/CCTree'
Bundle 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Bundle 'haolongzhangm/auto_update_cscope_ctags_database'
"Bundle 'kien/ctrlp.vim'
"Bundle 'Lokaltog/vim-powerline'
call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"=======================end bundle=============================

"===================for YouCompleteMe==========================
if filereadable('./.ycm_extra_conf.py')
	let g:ycm_global_ycm_extra_conf = '.ycm_extra_conf.py'
else
	let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
	autocmd BufNewFile,BufRead *.c let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.c99_ycm_extra_conf.py'
	autocmd BufNewFile,BufRead *.cpp let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
	autocmd BufNewFile,BufRead *.cc let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
	autocmd BufNewFile,BufRead *.c++ let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
endif
let g:ycm_confirm_extra_conf = 0

"let g:ycm_key_invoke_completion = '<C-/>'
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_collect_identifiers_from_tags_files = 0
"let g:ycm_add_preview_to_completeopt = 1
let g:ycm_error_symbol = 'Er'
let g:ycm_warning_symbol = 'Wr'
highlight YcmErrorSection guibg=#000000
highlight YcmWarningSection guibg=#000000
"add a interface to manual stop and start YouCompleteMe,sometime need use new-omni-completion
command! -nargs=0 -bar YouCompleteMeStartOrStop
    \  call YouCompleteMe_Start_Or_Stop()
let s:already_enable_youcomplete = 1
function! YouCompleteMe_Start_Or_Stop()
	if 1 == s:already_enable_youcomplete
		echo "Now manual disable YouCompleteMe"
		autocmd! ycmcompletemecursormove
		autocmd! youcompleteme
		set completeopt=longest,menu
		let s:already_enable_youcomplete = 0
	else
		echo "Now manual enable YouCompleteMe"
		call youcompleteme#Enable()
		let s:already_enable_youcomplete = 1
	endif
endfunction
nnoremap <F12> :YouCompleteMeStartOrStop<CR>
nmap <C-\>r :YcmCompleter GoToDefinition<CR><CR>
"======================end for YouCompleteMe config============

"===============for cscope and ctags===========================
nmap <F5> :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <F6> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <F7> :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <F2> :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <F12> :cs find g <C-R>=expand("<cword>")<CR><CR> "use vim defaule
"ctrl+]to find define tag
nmap <F10> :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-u> :tnext<CR><CR>f
nmap <C-y> :tprevious<CR><CR>f
"set cscopequickfix=s-,c-,d-,i-,t-,e-
nmap <C-\>t :tselect <C-R>=expand("<cword>")<CR><CR>
"===============end cscope and ctags===========================

"=========== add this for chinese==============================
let &termencoding=&encoding
set fileencodings=utf-8,gbk
"===========end for chinese====================================

"===========add for match======================================
set showmatch
"add for vim { < ( match
"inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {<CR>}<ESC> k k $
""inoremap } <c-r>=ClosePair('}')<CR>
""inoremap [ []<ESC>i
""inoremap ] <c-r>=ClosePair(']')<CR>
""inoremap " ""<ESC>i
""inoremap ' ''<ESC>i
"=============end for match=====================================

"=========add for auto load ctags file==========================
"just add for backup, infact we use cscope now, auto load cscope
"database by ~/.vim/plugin/autoload_cscope.vim
function! AddCtagsDatabase()
    let max = 30
    let dir = './'
    let i = 0
    let break = 0
    while isdirectory(dir) && i < max
        if filereadable(dir . 'tags')
            execute 'set tags ='. dir . 'tags;'
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
"call AddCtagsDatabase()
"=========end add for auto load ctags file======================

"=========add for command and customer shortcut key=============
command -nargs=1 Vgthisfile :vimgrep /<args>/ % | copen
command -nargs=1 Vgallfile :vimgrep /<args>/ **/*.* | copen
noremap <C-K> :Vgthisfile <C-R>=expand("<cword>")<CR><CR>
noremap <C-l> :Vgallfile <C-R>=expand("<cword>")<CR><CR>
command -nargs=0 Clearblank :%s/\s\+$//
"use system  clipboard
noremap y "+y
noremap Y "+Y
"map C-f to show buffers
nnoremap <C-f> :buffers<CR>:b<Space>

"for cscope quick reset
"auto update cscope datebase by command auto_updatecscope
map <c-p> :Manualupdatedatabaseonetime<CR>

"quick for marks show ,then use ' + [num] to jump
nnoremap <C-b> :marks<CR>g

"quick show changs list,
"then use [num] + g + ; to jump back
"or use   [num] + g + , to jump forward
nnoremap <C-c> :changes<CR>

"qucik show register info, then use " + [register] + p to paste
nnoremap <C-e> :registers<CR>

"quick show jump list,
"then use [num] + ctrl + o to jump back
"or   use [num] + ctrl + i to jump forward
nnoremap <C-j> :jumps<CR>

"quick delete current buffer
nmap <C-\>d :bdelete<CR>
"=========end for command and customer shortcut key============

"=========ADD for add Myusage==================================
function! Myusage()
	echo "Myusage:"
	echo "Bookmarks  : <C-b> : ' + [num]                  "
	echo "changslist : <C-c> : [num] + g + ;  <<back      "
	echo "                   : [num] + g + ,  <<forward   "
	echo "registers  : <C-e> :  \"+ [register] + p        "
	echo "jumps      : <C-j> : [num] + ctrl + o <<back    "
	echo "                   : [num] + ctrl + i <<forward "
	echo ",          : jump to cursor localtion Fuc call Fuc"
	echo ".          : jump to cursor locateion Fuc name  "
	echo "f/F        : just show cursor  locateion Func name"
	echo "F2         :cscope:Find this file                "
	echo "F3         :goldendict words[need install goldendict]"
	echo "F9         :NERDTree PWD file"
	echo "F4         :TlistToggle                         "
	echo "F5         :cscope:Find functions calling this function"
	echo "F6         :cscope:Find this C symbol           "
	echo "F7         :cscope:Find functions called by this function"
	echo "F10        :cscope:Find this text string        "
	echo "F12        :YouCompleteMeStartOrStop            "
	echo "<C-a>      :let Tlist_WinWidth=43               "
	echo "<C-u>/<C-y>:qucikfix tnext or tprevious         "
	echo "<C-K>/<C-l>:vimgrep func : Vgthisfile/Vgallfile "
	echo "<C-f>      :buffers list                        "
	echo "<c-p>      :Manualupdatedatabaseonetime                        "
	echo "<C-d>      :show Myusage()                      "
	echo "<C-h>      :show CommandT                       "
	echo "<C-\\>p     :SrcExpl_prevDefKey                  "
	echo "<C-\\>u     :SrcExpl_nextDefKey                  "
	echo "<C-\\>s     :SrcExplToggle  open/close           "
	echo "<C-\\>c     :SrcExpl_winHeight config            "
	echo "<C-\\>i     :cscope:Find files #including this file"
	echo "<C-\\>a     :cscope:Find where this symbol is assigned a value"
	echo "<C-\\>g     :EchoFunc:show next func"
	echo "<C-\\>o     :EchoFunc:show prev func"
	echo "<C-\\>t     :tselect func                        "
	echo "<C-\\>r     :YcmCompleter GoToDefinition                        "
	echo "<C-\\>d     :bdelete current buffer              "
	echo "command: YouCompleteMeStartOrStop :manual stop or start YCM"
let g:EchoFuncKeyNext='<C-\>g'
let g:EchoFuncKeyPrev='<C-\>o'
endfunction
nnoremap <C-d> :call Myusage()<CR>
"=========end for add Myusage==================================

"=========add for config ctrlp.vim=============================
"""just for backup , infact we use command-t now
""let g:ctrlp_map = '<c-i>'
""let g:ctrlp_cmd = 'CtrlP'
""let g:ctrlp_custom_ignore = {
""    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
""    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
""    \ }
""let g:ctrlp_working_path_mode='a'
""let g:ctrlp_match_window_bottom=1
""let g:ctrlp_max_height=2000
""let g:ctrlp_match_window_reversed=0
""let g:ctrlp_mruf_max=50000
""let g:ctrlp_follow_symlinks=1
""let g:ctrlp_max_depth = 40
"=================end for ctrip=================================

"==================add for cctree===============================
""cctree have some issue, leave for later
"==================end for cctree===============================

"=================add for command-t=============================
let g:CommandTMaxFiles=110000
let g:CommandTMaxDepth=40
let g:CommandTSuppressMaxFilesWarning=0
let g:CommandTMaxHeight=200
let g:CommandTInputDebounce=100
"let g:CommandTMinHeight=50
let g:CommandTMatchWindowAtTop=0
let g:CommandTMatchWindowReverse=0
"let g:CommandTCancelMap='<Esc>'
let g:CommandTWildIgnore="*.o,*.obj"
function! ShowcommadT()
	let l:comand_args = './'
	let l:command_args_buffer_name = bufname('%')
	let l:command_args_pwd = getcwd()
	" bufname return val 47 means '/', 0 means 'NULL'
	if char2nr(l:command_args_buffer_name) == 47
		"echo "Absolute path"
		let l:comand_args = l:command_args_buffer_name
	elseif char2nr(l:command_args_buffer_name) == 0
		"echo "No buffers"
		let l:comand_args = l:command_args_pwd
		call setreg('z', l:comand_args)
		return
	else
		"echo "relative path"
		let l:comand_args = l:command_args_pwd . '/' . l:command_args_buffer_name
	endif
	echo 'BUF: ' . l:comand_args
	"use plug commandt buildin-func commandt#FileFinder
	"call commandt#FileFinder(l:command_args_pwd)
	echo 'CUR: ' . l:command_args_pwd
	let l:project_dir = 'null'
	if cscope_connection() > 0
		echo 'ITE: ' . g:csdbpath
		let l:project_dir = g:csdbpath
	endif
if has('pythonx')
pyx << EOF
import vim
tmp_str = vim.eval("l:comand_args")
project_dir = vim.eval("l:project_dir")
if project_dir == 'null':
	command_str = "call setreg('z', '%s')" %  (tmp_str[:tmp_str.rindex("/")])
else:
	command_str = "call setreg('z', '%s')" %  (project_dir)
command_str_f = "call setreg('*', '%s')" %  (tmp_str)
vim.command(command_str)
vim.command(command_str_f)
EOF
else
	echo 'Pls build vim with python'
	call setreg('z', l:comand_args)
endif
endfunction

nnoremap <C-h> :call ShowcommadT()<CR>:CommandT <C-r>z
"==================end for command-t=============================

"==================add for quick show func by enter 'f'==========
function! ShowFuncName()
	let lnum = line(".")
	let col = col(".")
	echohl ModeMsg
	echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
	echohl None
	call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfunction

map f :call ShowFuncName() <CR>
map F :call ShowFuncName() <CR>

function! Map_to_func_head_python_style()
	map , [[w<F5>
	map . [[w
endfunction

function! Map_to_func_head_c_style()
	map , :call getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')) <CR> %%b<F5>
	map . :call getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')) <CR> %%b
endfunction

autocmd BufNewFile,BufRead *.c call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.cpp call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.cc call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.c++ call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.java call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.aidl call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.mk call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.py call Map_to_func_head_python_style()
autocmd BufNewFile,BufRead *.vim call Map_to_func_head_python_style()
"==================end for quick show func by enter 'f'==========

"==================add source vimrc_example.vim==================
"==================just for linux/unix style env=================
source $VIMRUNTIME/vimrc_example.vim
"==================end add source vimrc_example.vim==============

"=========add Froce hiserach color to ctermbg=Red================
hi Search ctermbg=Red
"=========End hiserach color to ctermbg=Red======================

"=========override mouse set from default.vim(vimrc_example.vim)=
if has('mouse')
  set mouse=
endif
set nobackup
"=========end override mouse and nobackup set from default.vim===

"=========do not back undofile===================================
set noundofile
"set undodir=~/.vim_undodir
"=========end do not back undofile===============================

"=========add for srcexpl.vim====================================
let g:SrcExpl_isUpdateTags = 0
let g:SrcExpl_refreshTime = 600
let g:SrcExpl_searchLocalDef = 1
let g:SrcExpl_prevDefKey = '<C-\>p'
let g:SrcExpl_nextDefKey = '<C-\>u'
nmap <C-\>s :SrcExplToggle<CR>
"nmap <C-\>c :SrcExplClose<CR>
nnoremap <C-\>c :let g:SrcExpl_winHeight = 25
let g:SrcExpl_winHeight = 20
let g:SrcExpl_pluginList = [
        \ "__Tag_List__",
		\ "_NERD_tree_"
    \ ]
"========end for srcexpl.vim====================================

"========add for echofunc.vim===================================
let g:EchoFuncKeyNext='<C-\>g'
let g:EchoFuncKeyPrev='<C-\>o'
"========end for echofunc.vim===================================
"========add for auto update cscope ctags log ==================
let g:Auto_update_cscope_ctags_debug_log = 1
let g:auto_run_function_when_cscope_connect = 0
let g:check_update_when_first_load_vim = 1
"========end for auto update cscope ctags log ==================
