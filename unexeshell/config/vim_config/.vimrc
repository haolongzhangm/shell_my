" below add by haolong.zhang test 20140819
"===================misc for vim=================================
set nu
set relativenumber
set nocompatible
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
autocmd BufWinEnter * call ResCur()

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
"need call TlistAddFiles % or <F9> to update taglist
set statusline +=\ %{Tlist_Get_Tagname_By_Line()}
set hlsearch incsearch ignorecase
if has("gui_running")
	colorscheme industry
endif
"fix mouse isse when use ssh server mode, eg resize window by mouse
set ttymouse=xterm2
nnoremap <silent><F8> :exec 'match StatusLineTerm /' . expand('<cword>') . '/'<CR>
nmap <C-\>m :TranslateW -t <C-R>=expand("<cword>")<CR> -e youdao -tl zh -sl en
"setlocal spell spelllang=en_us

"customer \<F3> to general man, \<F2> to c++ std::api man
"caused by vim self shift+k man can not modify cursor words
"also caused by termdebug will override shift+k key bind
"about c++ api man may need install: libstdc++-x-doc (x: 9)
nmap \<F3> :!man <C-R>=expand("<cword>")<CR>
nmap \<F2> :!man std::<C-R>=expand("<cword>")<CR>
"==================end for vim misc==============================

"==========for TlistToggle and Nerdtree==========================
nnoremap <silent> <F9> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
"let Tlist_Auto_Open = 1
function! NERDTREE_OPEN_OR_CLOSE_WITH_FLUSH()
	if exists("g:NERDTree") && g:NERDTree.IsOpen()
		NERDTreeClose
	else
		NERDTree
	endif
endfunction
map <silent><F4> :call NERDTREE_OPEN_OR_CLOSE_WITH_FLUSH()<CR>
nn <silent><C-a> :NERDTreeClose<CR>:NERDTreeFind<CR>:echo "use <F4> to close NERDTree"<CR>
let NERDTreeWinPos='left'
let NERDChristmasTree=1
let NERDTreeAutoCenter=1
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
let NERDTreeHightCursorline=1
let NERDTreeShowLineNumbers=1
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
Plugin 'kana/vim-operator-user'
Plugin 'rhysd/vim-clang-format'
Plugin 'rking/ag.vim'
Plugin 'voldikss/vim-translator'
Plugin 'pboettch/vim-cmake-syntax'
Plugin 'francoiscabrol/ranger.vim'
call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"=======================end bundle=============================

"===================for YouCompleteMe==========================
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = ''
""let g:ycm_global_ycm_extra_conf = '~/.vim/YouCompleteMe_config/.default_ycm_extra_conf.py'
"as some reason, we may use clangd(eg linux kernel base bear make) or libclang(eg old project
"based on .ycm_extra_conf.py), so we build ycm with command:
"python3 install.py --clangd-completer --clang-completer
"then create a interface to switch ycm back-end, default use clangd
".ycm_extra_conf.py need imp Settings interface
let g:ycm_use_clangd = 1

let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_error_symbol = 'Er'
let g:ycm_warning_symbol = 'Wr'
let g:ycm_auto_trigger = 1
let g:ycm_disable_for_files_larger_than_kb = 2500
let g:ycm_clangd_binary_path = 'clangd-11'
""use to debug clangd issue
""let g:ycm_clangd_args = ['-log=verbose', '-pretty']
highlight YcmErrorSection guibg=#000000
highlight YcmWarningSection guibg=#000000
"add a interface to manual stop and start YouCompleteMe,sometime need use new-omni-completion
"or interface to swith ycm back-end, 1: clangd, 0: libclang
let s:already_enable_youcomplete = 1
function! YouCompleteMe_Start_Or_Stop(use_clangd)
	if 1 == a:use_clangd
		let g:ycm_use_clangd = 1
	else
		let g:ycm_use_clangd = 0
	endif

	if 1 == s:already_enable_youcomplete
		echo "Now manual disable YouCompleteMe"
		autocmd! ycmcompletemecursormove
		autocmd! youcompleteme
		set completeopt=longest,menu
		let s:already_enable_youcomplete = 0
	else
		if 1 == a:use_clangd
			echo "Now manual enable YouCompleteMe with clangd"
		else
			echo "Now manual enable YouCompleteMe with libclang"
		endif
		call youcompleteme#Enable()
		let s:already_enable_youcomplete = 1
	endif
endfunction
nnoremap <C-\>y :call YouCompleteMe_Start_Or_Stop(1)
nmap <F12> :YcmCompleter GoToDeclaration<CR>
nmap <F3> :YcmCompleter GoToDefinition<CR>
nmap <F7> :YcmCompleter GoToReferences<CR>
nmap \f :YcmCompleter FixIt<CR>
""let g:ycm_clangd_args = ['-log=verbose']
" disable ycm hover auto popup
let g:ycm_auto_hover = "0"
nmap <F10> <plug>(YCMHover)
"======================end for YouCompleteMe config============

"===============for cscope and ctags===========================
nmap <F5> :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <F6> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>r :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <F2> :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>a :cs find a <C-R>=expand("<cword>")<CR><CR>
"nmap <F12> :cs find g <C-R>=expand("<cword>")<CR><CR> "use vim defaule
"ctrl+] or ctrl+p to find define tag
nmap <C-\><F10> :cs find t <C-R>=expand("<cword>")<CR><CR>
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
	if a:echo_info == 1
		echo 'BUF: ' . b:comand_args
		echo 'CUR: ' . b:command_args_pwd
	elseif a:echo_info == 2
		return b:comand_args
	endif
	" easy for gdb with line
	" let b:line_number = line('.')
	" call setreg('*', b:comand_args . ':' . b:line_number)
	return b:file_path
endfunction

"=========add for command and customer shortcut key=============
command -nargs=1 Vgthisfile :vimgrep /<args>/ % | copen
function! AgGrepWithPath(use_may_tag_dir)
	let b:comand_args = './'
	let b:command_args_buffer_name = bufname('%')
	let b:command_args_pwd = getcwd()
	" bufname return val 47 means '/', 0 means 'NULL'
	if char2nr(b:command_args_buffer_name) == 47
		"echo "Absolute path"
		let b:comand_args = b:command_args_buffer_name
	elseif char2nr(b:command_args_buffer_name) == 0
		"echo "No buffers"
		let b:comand_args = b:command_args_pwd
	else
		"echo "relative path"
		let b:comand_args = b:command_args_pwd . '/' . b:command_args_buffer_name
	endif
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

	if a:use_may_tag_dir
		if l:project_dir == 'null'
			call setreg('z', expand("<cword>") . ' ' . b:file_path)
		else
			call setreg('z', expand("<cword>") . ' ' . l:project_dir)
		endif
	else
		call setreg('z', expand("<cword>") . ' ' . b:comand_args)
	endif
endfunction
noremap <C-\>l *N:call AgGrepWithPath(1)<CR>:Ag -w <C-r>z
noremap <C-l> *N:call AgGrepWithPath(0)<CR>:Ag -w <C-r>z
noremap <C-k> :cclose<CR>
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
nnoremap <C-n> :marks<CR>:'

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
"===================add for codestyle switch=====================
let g:codestyle = 'Codestyle:NULL'
function! LinuxCodestyle()
	let g:codestyle = 'LinuxCodestyle'
	set tabstop=8
	set shiftwidth=8
	set noexpandtab
endfunction

function! PythonCodestyle()
	let g:codestyle = 'PythonCodestyle'
	set tabstop=4
	set shiftwidth=4
	set expandtab
endfunction

function! ShellCodestyle()
	let g:codestyle = 'ShellCodestyle'
	set tabstop=4
	set shiftwidth=4
	set expandtab
endfunction

function! KaiCodestyle()
	let g:codestyle = 'KaiCodestyle'
	set tabstop=4
	set shiftwidth=4
	set expandtab
endfunction

" fuck why google has two cpp style code is AOSP?
function! GoogleCodestyle()
	let g:codestyle = 'GoogleCodestyle'
	set tabstop=4
	set shiftwidth=4
	set expandtab
endfunction

function! Codestyle()
	return '[' . g:codestyle . ':' . &filetype .']'
endfunction

function! IntoCodestyle()
	let b:file_path = GetFilePath(0)
	if &filetype ==# 'python'
		call PythonCodestyle()
	elseif &filetype ==# 'vim'
		call LinuxCodestyle()
	elseif &filetype ==# 'sh'
		call ShellCodestyle()
	elseif match(b:file_path, "megvii") > 0 || match(b:file_path, "brain") > 0
		call KaiCodestyle()
	elseif match(b:file_path, "aosp") > 0
		call GoogleCodestyle()
	elseif match(b:file_path, "linux") > 0
		call LinuxCodestyle()
	elseif &filetype ==# 'c'
		call LinuxCodestyle()
	elseif &filetype ==# 'cpp' || &filetype ==# 'java' || &filetype ==# 'make'
		call GoogleCodestyle()
	else
		call LinuxCodestyle()
	endif
endfunction
autocmd BufNewFile,BufRead * call IntoCodestyle()
"clang format
let g:clang_format#command = 'clang-format'
"auto detect .clang-format file
let g:clang_format#detect_style_file = 1
"do not plug ClangFormat to =, caused by linux-kernel code,
"so just use command: [start,end]ClangFormat
" other user bind == to call ClangFormat
if $USER != "zhl" && $USER != "zhanghaolong"
	autocmd FileType c,cpp,objc,opencl,cuda map <buffer> = <Plug>(operator-clang-format)
endif
function! FormatClangManua()
	let b:line = line('.')

	call setreg('z', b:line . ', +' . 'ClangFormat')
endfunction

nnoremap <C-\>c :call FormatClangManua()<CR>:<C-r>z
			\ <left><left><left><left><left><left><left><left><left><left><left><left>
"===================end add for codestyle switch==================

"=========ADD for add Myusage==================================
function! Myusage()
	echo "Myusage:"
	let l:help_msg = {
        \ "Bookmarks    ": "<C-n> : ' + [num]",
	\ "changslist   ": "<C-c> : [num] + g + ;  <<back/[num] + g + ,  <<forward",
	\ "registers    ": "<C-e> :  \"+ [register] + p",
	\ "marks        ": "<C-n>",
	\ "jumps        ": "<C-j> : [num] + ctrl + o <<back/[num] + ctrl + i <<forward",
	\ ",/;          ": "repeat do f/F(find command)<vim default>",
	\ ".            ": "repeat do the last command of Normal model<vim default>",
	\ "<C-\\>,       ": "jump to cursor localtion Fuc call Fuc",
	\ "<C-\\>.       ": "jump to cursor locateion Fuc name",
	\ "<C-\\>/       ": "jump to cursor locateion Fuc refers",
	\ "f/F          ": "find w in line <vim default>",
	\ "cscope       ": "F2 -- Find this file\n
	\                 F5 -- Find functions calling this function\n
	\                 F6 -- Find this C symbol\n
	\                 <C-\\>r -- Find functions called by this function\n
	\                 <C-\\>F10 -- Find this text string\n
	\                 <C-\\>i -- Find files #including this file\n
	\                 <C-\\>a -- Find where this symbol is assigned a value",
	\ "YCM          ": "F3 -- GoToDefinition\n
	\                 F7 -- GoToReferences\n
	\                 F10 -- YCMHover\n
	\                 F12 -- GoToDeclaration\n
	\                 \\f FixIt\n
	\                 <C-\\>y YouCompleteMe_Start_Or_Stop(flag) 1:clangd, 0:libclang",
	\ "window navi  ": "F9 -- TlistToggle\n
	\                 F4 -- NERDTree [pwd]\n
	\                 [<C-a>] -- NERDTree [CUR file]\n
	\                 \\F4 Ranger [pwd]",
	\ "man          ": "\\F2 \\F3 -- run !man xx need install libstdc++-x-doc (x: 9)",
	\ "qucikfix     ": "<C-u> -- tnext | <C-y> -- tprevious",
	\ "copen        ": "<C-K> -- close copen",
	\ "Ag grep      ": "<C-\\>l -- Ag func tag dir | <C-l> -- Ag func cur file",
	\ "<C-f>        ": "buffers list",
	\ "ctag jump    ": "<C-p> -- tjump func\n
	\                 <C-u> -- tnext\n
	\                 <C-y> -- tprevious",
	\ "<C-d>        ": "show Myusage",
	\ "CommandT     ": "<C-h> -- call CommandT at tag dirs if possible\n
	\                 <C-\\>h -- call CommandT at current buffer dir\n
	\                 <C-\\>f/F -- CommandTBuffer",
	\ "SrcExpl      ": "<C-\\>p -- SrcExpl_prevDefKey\n
	\                 <C-\\>u -- SrcExpl_nextDefKey\n
	\                 <C-\\>s -- SrcExplToggle  open/close",
	\ "<C-\\>c       ": "call ClangFormat manually",
	\ "<C-\\>v/V     ": "show function name",
	\ "<C-\\>d       ": "bdelete current buffer",
	\ "\\g           ": "show git blame info",
	\ "<C-\\><F3>    ": "vertical terminal",
	\ "<C-\\><F4>    ": "terminal",
	\ "<C-\\>m       ": "call TranslateW",
	\ "<F8>         ": "highlight words with search",
	\ "EchoFunc     ": "<C-\\>j -- EchoFuncKeyNext\n
	\                 <C-\\>k -- EchoFuncKeyPrev\n
	\                 <C-\\>e -- enable or disable echofunc",
	\ "createtag    ": ":Createtag -- create tag\n
	\                  <C-\\>t -- Manualupdatedatabaseonetime",
	\ "termdebug    ": ":Gdblinuxarm -- config linux-arm host cross gdb env\n
	\                 :Gdblinuxarm64 -- config linux-arm64 host cross gdb env\n
	\                 :Gdbmacosarm -- config macos-arm host cross gdb env\n
	\                 :Gdbmacosarm64 -- config macos-arm64 host cross gdb env\n
	\                 :Gdblocalhost -- config local gdb env\n
	\                 <C-\\>g -- gdb breakpoint command\n
	\                 Android env example: adb forward tcp:1234 tcp:1234\n
	\                         (gdb)set solib-absolute-prefix ...\n
	\                         (gdb)set solib-search-path ...",
	\ "vim          ": ":source ~/.vimrc and :!reset -- reset vimrc\n
	\                 :mksession file.vim then vim -S file.vim -- vim snapshoot",
	\ }
	for key in keys(help_msg)
		echo key . '--> ' . help_msg[key]
	endfor
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
"let g:CommandTFileScanne="find"
let g:CommandTMaxFiles=440000
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
command -nargs=0 Gdblinuxarm :let termdebugger="gdb_arm_linux_10_1"
command -nargs=0 Gdblinuxarm64 :let termdebugger="gdb_aarch64_linux_10_1"
command -nargs=0 Gdbmacosarm :let termdebugger="gdb_arm_macos_8_3"
command -nargs=0 Gdbmacosarm64 :let termdebugger="gdb_aarch64_macos_8_3"
command -nargs=0 Gdblocalhost :let termdebugger="gdb"
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
function! GitBlame()
	let b:file_path = GetFilePath(0)
	let b:cur_line= line('.')
	" default max show 20 line code git blame
	let b:end_line= line('.') + 40
	" do command: git blame curfile
	let b:git_run_c = 'cd ' . b:file_path . ";git blame -c " . GetFilePath(2) . " -L " . b:cur_line . "," . b:end_line
	"echo b:git_run_c
	let b:ret_system = system(b:git_run_c)
	call popup_create(split(b:ret_system, "\n"), #{
				\ close: 'click',
				\ pos: 'center',
				\ highlight: 'Search',
				\ time: 8000, drag: 1,
				\})
endfunction
nmap \g :call GitBlame()<CR>
function! ChangeStatuslineColor()
	if (mode() =~# '\v(n|no)')
		exe 'hi! StatusLine ctermfg=005'
	elseif (mode() =~# '\v(v|V)')
		exe 'hi! StatusLine ctermfg=008'
	elseif (mode() ==# 'i')
		exe 'hi! StatusLine ctermfg=004'
	else
		exe 'hi! StatusLine ctermfg=00f'
	endif
	return ''
endfunction
set statusline+=%{GitBranchOrTag()}
set statusline+=%{ChangeStatuslineColor()}
set statusline+=%{Codestyle()}
"===============end GitBranchOrTag==============================
"
"===============start ranger==============================
let g:ranger_map_keys = 0
map <silent>\<F4> :Ranger<CR>
"===============end ranger================================
