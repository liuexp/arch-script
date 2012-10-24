set nobackup
set hlsearch
set incsearch
set autoindent
set number
set smartindent
set cindent
set fileencodings=utf8,cp936
"---for vundle
"filetype off
set nocompatible
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'dag/vim2hs'
Bundle 'eagletmt/ghcmod-vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-fugitive'
Bundle 'spf13/vim-markdown'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'amirh/HTML-AutoCloseTag'
Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
Bundle 'AutoClose'
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle 'scrooloose/syntastic'
Bundle 'liuexp/vim-snipmate'
Bundle 'liuexp/snipmate-snippets'
Bundle 'derekwyatt/vim-scala'
Bundle 'osyo-manga/neocomplcache-clang_complete'
Bundle 'Lokaltog/vim-powerline'
Bundle ''
" Pick either python-mode or pyflakes & pydoc
Bundle 'klen/python-mode'
Bundle 'python.vim'
Bundle 'python_match.vim'
Bundle 'pythoncomplete'
"--end of vundle

syntax on
syntax enable
filetype on

set guifont=Monaco\ for\ Powerline
let g:Powerline_symbols = 'fancy'
" Source support_function.vim to support snipmate-snippets.
if filereadable(expand("~/.vim/bundle/snipmate-snippets/snippets/support_functions.vim"))
    source ~/.vim/bundle/snipmate-snippets/snippets/support_functions.vim
endif
let g:solarized_termcolors=256
set t_Co=256
set background=dark
if has('gui_running')
	set background=dark
else
	set background=light
endif
colorscheme solarized


"vim2hs conceal with unicode
let g:haskell_conceal_wide = 1
"nerdtree
autocmd vimenter * if !argc() | NERDTree | endif
autocmd vimenter * if !argc() | set encoding=utf8 | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

filetype plugin on
filetype indent on
"set tabstop=4
"set softtabstop=4
"set shiftwidth=4

au BufNewFile,BufRead *.cpp set syntax=cpp11
au BufNewFile,BufRead *.cpp set foldmethod=syntax
au BufNewFile,BufRead *.cu set foldmethod=syntax
au BufNewFile,BufRead *.tex set tabstop=4
au BufNewFile,BufRead *.tex set softtabstop=4
au BufNewFile,BufRead *.tex set shiftwidth=4
augroup filetype
  au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
augroup END
au Syntax jflex    so ~/.vim/syntax/jflex.vim

" vimwiki
let g:vimwiki_use_mouse = 1
let g:vimwiki_list = [{'path': '/home/liuexp/vimwiki/',
\ 'path_html': '/home/liuexp/vimwiki/html/',
\ 'html_header': '/home/liuexp/vimwiki/template/header.tpl',}]

" vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

" vim-buf
:noremap <C-left> :bprev<CR> 
:noremap <C-right> :bnext<CR> 

" haskell
au Bufenter *.hs compiler ghc
let g:haddock_browser = "chromium"
if &filetype=="haskell"
	set expandtab
	set ts=4
endif

" default macro
map <F9> :call Compile()<CR>
function! Compile()
exec "w"
if &filetype=="cpp"
exec "!g++ -std=c++11 % -o %< -g -Wall"
elseif &filetype=="verilog"
exec "!iverilog -o %< %"
elseif &filetype=="cuda"
exec "!nvcc % -o %<"
elseif &filetype=="jflex"
exec "!jflex %"
elseif &filetype=="haskell"
exec "!ghc -o %< %"
elseif &filetype=="java"
exec "!javac %"
elseif &filetype=="python"
exec "!python2 %"
elseif &filetype=="tex"
exec "!xelatex %"
elseif &filetype=="asm"
exec "!lc3as %"
else
exec "!make"
endif
endfunction
map <F8> :call Debuger()<CR>
function! Debuger()
exec "!gdb %<"
endfunction
map <F5> :call Run()<CR>
function! Run()
if &filetype=="java"
exec "!java %<.class"
elseif &filetype=="python"
exec "!time ./%"
elseif &filetype=="tex"
exec "!evince %<.pdf"
elseif &filetype=="asm"
exec "!lc3sim-tk %<.obj"
elseif &filetype=="haskell"
exec "!runghc %<.hs"
else
exec "!time ./%<"
endif
endfunction


" use neocomplcache & clang_complete
" add neocomplcache option
let g:neocomplcache_force_overwrite_completefunc=1
" add clang_complete option
let g:clang_complete_auto=1

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'







" Key (re)Mappings {

    "The default leader is '\', but many people prefer ',' as it's in a standard
    "location
    let mapleader = ','

    " Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
    nnoremap ; :

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " The following two lines conflict with moving to top and bottom of the
    " screen
    " If you prefer that functionality, comment them out.
"    map <S-H> gT
"    map <S-L> gt

    " Stupid shift key fixes
    cmap WQ wq
    cmap wQ wq
    cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    """ Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    "clearing highlighted search
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>

" }


" AutoCloseTag {
    " Make it so AutoCloseTag works for xml and xhtml files as well
    au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }


