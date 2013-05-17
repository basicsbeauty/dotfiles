set nocompatible
let mapleader=","
let g:LustyJugglerSuppressRubyWarning=1
let g:GetLatestVimScripts_allowautoinstall=1
noremap <leader>P :set paste!<CR>
noremap \ %
noremap <silent> <Leader>w :call ToggleWrap()<CR>
noremap <silent> k gk
noremap <silent> j gj
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
inoremap  <silent> <Home> g<Home>
noremap  <silent> <End>  g<End>
inoremap <silent> <Home> <C-o>g<Home>
inoremap <silent> <End>  <C-o>g<End>
noremap <C-k> <C-u>
noremap <C-j> <C-d>
noremap <S-j> 5j
noremap <S-k> 5k 
set background=dark
syntax on
set history=1000
set shortmess+=r
set showmode
set showcmd
set mouse=a
set nosmartindent
set nocindent
set autoindent
filetype on
filetype plugin on
filetype indent off

set ignorecase
set smartcase
set incsearch
set gdefault
set hidden
nnoremap ' `
nnoremap ` '
set scrolloff=5
set title
set ruler
set ttyfast
set noequalalways
set splitbelow

function! ReverseBackground()
 let Mysyn=&syntax
 if &bg=="light"
 se bg=dark
 syn on
 else
 se bg=light
 syn on
 hi Statement ctermfg=black cterm=bold
 hi Type ctermfg=blue

endif
 exe "set syntax=" . Mysyn
 echo "now syntax is "&syntax
endfunction
command! Invbg call ReverseBackground()
noremap <LEADER>n :Invbg<CR>
noremap <LEADER>w *
noremap <LEADER>b #
"let g:qname_hotkey="0"
set sts=4
set ts=4
set sw=4

set laststatus=2
let g:buftabs_in_statusline=1
:noremap <C-,> :bprev<CR>
:noremap <C-.> :bnext<CR>
nnoremap ,1 :1b<CR>
nnoremap ,2 :2b<CR>
nnoremap ,3 :3b<CR>
nnoremap ,4 :4b<CR>
nnoremap ,5 :5b<CR>
nnoremap ,6 :6b<CR>
nnoremap ,7 :7b<CR>
nnoremap ,8 :8b<CR>
nnoremap ,9 :9b<CR>
nnoremap ,k :bp<CR>

nnoremap ,l :bn<CR>
nnoremap ,g :e#<CR>
nmap 0 :LustyJuggler<CR>
nmap - ,lb
noremap ,V :source ~/.vimrc<CR>
set hlsearch
"set expandtab
noremap <HOME> ^
noremap ,<CR> :w<CR>:make<CR>
vnoremap ,\ <Esc>/\%V
noremap <C-A> <ESC>^
noremap <C-E> <ESC>$
nmap <C-A> ^
vmap <C-A> ^
imap <C-A> <ESC>I
nmap <C-E> $
vmap <C-E> $
imap <C-E> <ESC>A
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
au BufNewFile,BufRead *.pyc_dis set filetype=python
au BufNewFile,BufRead *.nim set filetype=nimrod
au BufNewFile,BufRead *.sp set filetype=sourcepawn
au BufNewFile,BufRead *.xc set filetype=xc
set formatoptions=l
set lbr
set wrap

function! TextMode()
    set nolinebreak
    set textwidth=70
    set formatoptions=tn
endfunction
command! Text call TextMode()
command! Paste %w !paste
nmap <silent> <C-X> :wincmd t<CR>
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
imap <C-w> <C-o><C-w>
set hl=lr
"drupal stuff
set expandtab
colorscheme desert256
set notitle
au! BufRead,BufNewFile *.json setfiletype json 
au! BufRead,BufNewFile *.rkt set ft=lisp | setlocal formatoptions-=c formatoptions-=r formatoptions-=o
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl set ft=glsl 
"au BufReadPost * :DetectIndent 

"let g:pydiction_location = "/Users/comex/.vim/after/ftplugin/pydiction/complete-dict"
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabMidWordCompletion = 0
let g:SuperTabMappingBackward=',<tab>'
set modeline
set modelines=5
set bs=2
"source ~/.vim/three.vim
:command! -nargs=1 G :grep <q-args> *.[chm]*
source ~/.vim/autotag.vim
set cscopetag 

"c+p:
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
nmap <C-x> :cs find s <C-R>=expand("<cword>")<CR><CR>  
"nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>  
"nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>  
nmap <LEADER>t :cs find t <C-R>=expand("<cword>")<CR><CR>  
"nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>  
"nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>  
"nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <LEADER>d :cs find d <C-R>=expand("<cword>")<CR><CR>  
nmap <CR> <C-]>

ab ASC TAsmCtx,TEnt
set wildmenu
set wildmode=list:longest


au FileType * setl fo-=cro 
"let g:detectindent_preferred_expandtab = 1
"let g:detectindent_preferred_indent = 4      
"let g:detectindent_max_lines_to_analyse = 10000
if has("gui_running")
    set guioptions=grL
endif
