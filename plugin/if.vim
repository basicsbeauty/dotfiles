function! FindIdent()
        let l:sofile = expand("~/.vim/plugin/if.so")
        execute libcall(l:sofile, "find_indent", expand("%"))
endfunction

augroup IndentFinder
    au! IndentFinder
    au BufRead * call FindIdent()
augroup End

