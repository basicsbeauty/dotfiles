function! FindIdent()
    "if has("macunix") <-- false on new macports vim?
    if isdirectory("/Applications") 
        let l:ext = "dylib"
    else
        let l:ext = "so"
    endif
    let l:sofile = expand("~/.vim/plugin/if." . l:ext)
    execute libcall(l:sofile, "find_indent", join(getline(1, 1000), "\n"))
    "expand("%"))
endfunction
"
"function! FindIdent()
"    profile start /tmp/a
"    profile! file *
"    profile func *
"    call FindIdentReal()
"    profdel file *
"    profdel func *
"endfunction

augroup IndentFinder
    au! IndentFinder
    au BufRead * call FindIdent()
augroup End

