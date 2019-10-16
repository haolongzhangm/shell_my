" below add by haolong.zhang test 20140819
"===================misc for vim=================================
set nu
set relativenumber
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
syntax on
set nocp
set completeopt=preview,menu
set completeopt=longest,menu
set autoindent
set smartindent
au BufNewFile,BufRead *.cu set filetype=cpp
au BufNewFile,BufRead *.opencl set filetype=c
au BufNewFile,BufRead *.cl set filetype=c
au BufNewFile,BufRead *.inc set filetype=c
au BufNewFile,BufRead *.ph set filetype=c
"terminal always show file name and function name
set laststatus=2
set statusline=%f:%P:%v
"need call TlistAddFiles % or <F4> to update taglist
set statusline +=\ %{Tlist_Get_Tagname_By_Line()}
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
autocmd BufNewFile,BufRead *.cl call GoogleCodestyle()
autocmd BufNewFile,BufRead *.vim call GoogleCodestyle()
"===================end add for codestyle switch==================
set hlsearch incsearch ignorecase
if has("gui_running")
colorscheme industry
endif
nmap <C-\>r :!goldendict <C-R>=expand("<cword>")<CR><CR>
"fix mouse isse when use ssh server mode, eg resize window by mouse
set ttymouse=xterm2
"==================end for vim misc==============================

"==========for TlistToggle and Nerdtree==========================
nnoremap <silent> <F4> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1
"let Tlist_Auto_Open = 1
map <F9> :NERDTreeMirror<CR>
map <F9> :NERDTreeToggle<CR>
nn <silent><C-\><F9> :exec("NERDTree ".expand('%:h'))<CR>
let NERDTreeWinPos='right'
set nocompatible              " be iMproved, required
"filetype off                  " required
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
Plugin 'wincent/command-t'
Bundle 'Valloric/ListToggle'
Bundle 'ycm-core/YouCompleteMe'
Bundle 'scrooloose/nerdtree'
Bundle 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Bundle 'haolongzhangm/auto_update_cscope_ctags_database'
call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"=======================end bundle=============================

"===================for YouCompleteMe==========================
"YCM can auto load conf file
"if filereadable('./.ycm_extra_conf.py')
"	let g:ycm_global_ycm_extra_conf = '.ycm_extra_conf.py'
"else
"	let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
"	autocmd BufNewFile,BufRead *.c let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.c99_ycm_extra_conf.py'
"	autocmd BufNewFile,BufRead *.cpp let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
"	autocmd BufNewFile,BufRead *.cc let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
"	autocmd BufNewFile,BufRead *.c++ let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
"endif
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'

let g:ycm_key_invoke_completion = '<C-_>'
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
nnoremap <C-\>y :YouCompleteMeStartOrStop<CR>
nmap <F12> :YcmCompleter GoToDeclaration<CR>
nmap <F3> :YcmCompleter GoToDefinition<CR>
"======================end for YouCompleteMe config============

"===============for cscope and ctags===========================
nmap <F5> :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <F6> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <F7> :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <F2> :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>a :cs find a <C-R>=expand("<cword>")<CR><CR>
"nmap <F12> :cs find g <C-R>=expand("<cword>")<CR><CR> "use vim defaule
"ctrl+] or ctrl+p to find define tag
nmap <F10> :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-u> :tnext<CR><CR>:call ShowFuncName() <CR>
nmap <C-y> :tprevious<CR><CR>:call ShowFuncName() <CR>
"set cscopequickfix=s-,c-,d-,i-,t-,e-
nmap <C-p> :tjump <C-R>=expand("<cword>")<CR><CR>
"===============end cscope and ctags===========================

"=========== add this for chinese==============================
let &termencoding=&encoding
set fileencodings=utf-8,gbk
"===========end for chinese====================================

"===========add for match======================================
set showmatch
"add for vim { < ( match
"inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {}<ESC>i
"EchoFunc will use ( to tiger, so we map (( to ()
inoremap (( ()<ESC>i
inoremap [ []<ESC>i
inoremap " ""<ESC>i
inoremap ' ''<ESC>i
""inoremap } <c-r>=ClosePair('}')<CR>
""inoremap [ []<ESC>i
""inoremap ] <c-r>=ClosePair(']')<CR>
""inoremap " ""<ESC>i
""inoremap ' ''<ESC>i
"=============end for match=====================================
function! GetFilePath(echo_info)
	let b:comand_args = './'
	let b:command_args_buffer_name = bufname('%')
	let b:command_args_pwd = getcwd()
	let b:file_path = './'
	" bufname return val 47 means '/', 0 means 'NULL'
	if char2nr(b:command_args_buffer_name) == 47
		"echo "Absolute path"
		let b:comand_args = b:command_args_buffer_name
		let b:file_path = b:comand_args[:strridx(b:comand_args, '/')]
	elseif char2nr(b:command_args_buffer_name) == 0
		"echo "No buffers"
		let b:comand_args = b:command_args_pwd
		let b:file_path = b:comand_args
	else
		"echo "relative path"
		let b:comand_args = b:command_args_pwd . '/' . b:command_args_buffer_name
		let b:file_path = b:comand_args[:strridx(b:comand_args, '/')]
	endif
	if a:echo_info
		echo 'BUF: ' . b:comand_args
		echo 'CUR: ' . b:command_args_pwd
	endif
	" easy for gdb with line
	let b:line_number = line('.')
	call setreg('*', b:comand_args . ':' . b:line_number)
	return b:file_path
endfunction

"=========add for command and customer shortcut key=============
function! VimGrepWithPath()
	let b:file_path = GetFilePath(1)

	call setreg('z', expand("<cword>") . ' ' . b:file_path . '**/*.*|copen')
endfunction
command -nargs=1 Vgthisfile :vimgrep /<args>/ % | copen
noremap <C-K> :Vgthisfile <C-R>=expand("<cword>")<CR><CR>
noremap <C-l> :call VimGrepWithPath()<CR>:vimgrep <C-r>z
command -nargs=0 Clearblank :%s/\s\+$//
"use system  clipboard
"noremap y "+y
"noremap Y "+Y

"map C-f to show buffers
nnoremap <C-f> :buffers<CR>:b<Space>

"for cscope quick reset
"auto update cscope datebase by command auto_updatecscope
map <c-\>t :Manualupdatedatabaseonetime<CR>

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

"map <C-\><F3> to vertical terminal
"map <C-\><F4> to terminal
nnoremap <C-\><F3> :vertical terminal<CR>
nnoremap <C-\><F4> :terminal<CR>

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
	echo ",/;        : repeat do f/F(find command)<vim default>"
	echo ".          : repeat do the last command of Normal model<vim default>"
	echo "<C-\\>,	 : jump to cursor localtion Fuc call Fuc"
	echo "<C-\\>.	 : jump to cursor locateion Fuc name  "
	echo "<C-\\>/	 : jump to cursor locateion Fuc refers  "
	echo "f/F        : find w in line <vim default>"
	echo "F2         :cscope:Find this file                "
	echo "F3         :YcmCompleter GoToDefinition                        "
	echo "F4         :TlistToggle                         "
	echo "F5         :cscope:Find functions calling this function"
	echo "F6         :cscope:Find this C symbol           "
	echo "F7         :cscope:Find functions called by this function"
	echo "[<C-\\>]F9 :NERDTree [PWD file]"
	echo "F10        :cscope:Find this text string        "
	echo "F12        :YcmCompleter GoToDeclaration                       "
	echo "<C-a>      :let Tlist_WinWidth=43               "
	echo "<C-u>/<C-y>:qucikfix tnext or tprevious         "
	echo "<C-K>/<C-l>:vimgrep func : Vgthisfile/config PWD vimgrep "
	echo "<C-f>      :buffers list                        "
	echo "<c-p>      :tjump func                        "
	echo "<C-d>      :show Myusage()                      "
	echo "<C-h>      :show CommandT(at tag dirs if possible)"
	echo "<C-\\>h    :show CommandT(force current buffer dir)"
	echo "<C-\\>p     :SrcExpl_prevDefKey                  "
	echo "<C-\\>u     :SrcExpl_nextDefKey                  "
	echo "<C-\\>s     :SrcExplToggle  open/close           "
	echo "<C-\\>c     :SrcExpl_winHeight config            "
	echo "<C-\\>i     :cscope:Find files #including this file"
	echo "<C-\\>a     :cscope:Find where this symbol is assigned a value"
	echo "<C-\\>g     :EchoFunc:show next func"
	echo "<C-\\>o     :EchoFunc:show prev func"
	echo "<C-\\>t     :Manualupdatedatabaseonetime                        "
	echo "<C-\\>f/F   :CommandTBuffer"
	echo "<C-\\>v/V   :show function name"
	echo "<C-\\>d     :bdelete current buffer              "
	echo "<C-\\>e     :enable or disable echofunc.vim      "
	echo "<C-\\>g     :gdb breakpoint command              "
	echo "<C-\\>r     :goldendict words[need install goldendict]"
	echo "<C-\\>y     :YouCompleteMe_Start_Or_Stop"
	echo "           :android env pre: adb forward tcp:1234 tcp:1234"
	echo "           :android env pre: let termdebugger=\"gdb_arm_linux_8_3\""
	echo "           :android env pre: let termdebugger=\"gdb_aarch64_linux_8_3\""
	echo "           :android env pre: let termdebugger=\"gdb_arm_macos_8_3\""
	echo "           :android env pre: let termdebugger=\"gdb_aarch64_macos_8_3\""
	echo "           :android env pre: (gdb)set solib-absolute-prefix ..."
	echo "           :android env pre: (gdb)set solib-search-path ..."
	echo "<C-\\><F3>     :vertical terminal             "
	echo "<C-\\><F4>     :terminal         "
	echo "<C-\\>j    : EchoFuncKeyNext     "
	echo "<C-\\>k    : EchoFuncKeyPrev     "
	echo "force reset vim   :source ~/.vimrc and :!reset"
endfunction

let g:enable_or_disable_echofunc=0
function! Enable_or_disable_echofunc()
	if 0 == g:enable_or_disable_echofunc
		let g:enable_or_disable_echofunc=1
		echo "enable echofunc"
	else
		let g:enable_or_disable_echofunc=0
		echo "disable echofunc"
	endif
endfunction

nnoremap <C-d> :call Myusage()<CR>
nnoremap <C-\>e :call Enable_or_disable_echofunc()<CR>
"=========end for add Myusage==================================

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
let g:CommandTWildIgnore=&wildignore . ",*.o,*.obj" . ",bazel-bin,bazel-mace,bazel-out"
function! ShowcommadT(use_may_tag_dir)
	let b:file_path = GetFilePath(1)
	let l:project_dir = 'null'
	if cscope_connection() > 0 && a:use_may_tag_dir
		echo 'Tag Dirs: ' . g:csdbpath
		let l:project_dir = g:csdbpath
	endif


	if l:project_dir == 'null'
		call setreg('z', b:file_path)
	else
		call setreg('z', l:project_dir)
	endif
endfunction

nnoremap <C-h> :call ShowcommadT(1)<CR>:CommandT <C-r>z
nnoremap <C-\>h :call ShowcommadT(0)<CR>:CommandT <C-r>z
map <c-\>f :CommandTBuffer<CR>
map <c-\>F :CommandTBuffer<CR>
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

map <c-\>v :call ShowFuncName() <CR>
map <c-\>V :call ShowFuncName() <CR>

function! Map_to_func_head_python_style()
	map <c-\>, [[w<F5>
	map <c-\>. [[w
	map <c-\>/ [[w<F6>
endfunction

function! Map_to_func_head_c_style()
	map <c-\>, :call getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')) <CR> %%b<F5>
	map <c-\>/ :call getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')) <CR> %%b<F6>
	map <c-\>. :call getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW')) <CR> %%b
endfunction

autocmd BufNewFile,BufRead *.c call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.cpp call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.cc call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.c++ call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.java call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.aidl call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.cl call Map_to_func_head_c_style()
autocmd BufNewFile,BufRead *.opencl call Map_to_func_head_c_style()
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
"compat for tmux copy mode,so use mouse mode
"if has('mouse')
"  set mouse=
"endif
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
let g:EchoFuncKeyNext='<C-\>j'
let g:EchoFuncKeyPrev='<C-\>k'
"show balloon_eval meg
set balloonevalterm
set ballooneval
"========end for echofunc.vim===================================
"========add for auto update cscope ctags log ==================
let g:Auto_update_cscope_ctags_debug_log = 0
let g:auto_run_function_when_cscope_connect = 1
let g:check_update_when_first_load_vim = 1
"========end for auto update cscope ctags log ==================
"========add for vim gdb config=================================
packadd termdebug
nmap <C-\>g :Break<CR>
"example for config --host=x86_64-linux-gnu --target=aarch64-elf-linux gdb
"let termdebugger = "/media/zhl/second/code/gdb-8.2/gdb/gdb"
"Termdebug vmlinux
"========end for vim gdb config=================================

"===============add GitBranchOrTag==============================
let b:GitBranchOrTagInfoNeedReFresh = 1
let b:GitBranchOrTagOld = 'null'
autocmd BufNewFile,BufRead * let b:GitBranchOrTagInfoNeedReFresh= 1
function! GitBranchOrTag()
	" try exception:
	" err happened when no buffer after do delete buffer
	" into cmdwin node
	try
		if 0 == b:GitBranchOrTagInfoNeedReFresh
			return b:GitBranchOrTagOld
		endif
	catch /.*/
		"echo 'into unknown buffers status'
		return ''
	endtry

	let b:file_path = GetFilePath(0)
	" do command: git branch 2>/dev/null | grep '\* ' | tr -d '\n'
	let b:git_run_c = 'cd ' . b:file_path . ";git branch 2>/dev/null | grep \'\\* \' | tr -d '\n' "
	let b:ret_system = system(b:git_run_c)
	let b:ret_branch = ''
	if strlen(b:ret_system) > 0
		let b:ret_branch = '[' . b:ret_system[2:-1] . ']'
	endif
	let b:GitBranchOrTagInfoNeedReFresh = 0
	let b:GitBranchOrTagOld = b:ret_branch
	return b:ret_branch
endfunction
set statusline+=%{GitBranchOrTag()}
"===============end GitBranchOrTag==============================
