function! GetAutoTag()
     if !exists("b:cscopedir") && filereadable("cscope.out")
         let b:cscopedir = getcwd()
         execute "cscope add cscope.out"
     endif
endfunction

function! AutoTag()
    call GetAutoTag()
    if exists("b:cscopedir") && !filereadable(b:cscopedir . "/dont-autotag")
      call system("cd " . shellescape(b:cscopedir) . "; cscope -bR -s . >&/dev/null &")
      cscope reset
    endif
endfunction

augroup autotag
   au!
   autocmd BufReadPre * call GetAutoTag ()
   autocmd BufWritePost,FileWritePost * call AutoTag ()
augroup END

function! DoTag(tag)
    call GetAutoTag()
    execute "cs f g " . a:tag
endfunction
function! DoX(tag)
    call GetAutoTag()
    execute "cs f s " . a:tag
endfunction
:command! -nargs=1 A call DoTag("<args>")
:command! -nargs=1 S call DoX("<args>")


" vim:shiftwidth=3:ts=3
