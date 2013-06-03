function! FindIdent()
    if has("macunix")
        let l:ext = "dylib"
    else
        let l:ext = "so"
    endif
    let l:sofile = expand("~/.vim/plugin/if." . l:ext)
    execute libcall(l:sofile, "find_indent", expand("%"))
endfunction

augroup IndentFinder
    au! IndentFinder
    au BufRead * call FindIdent()
augroup End

