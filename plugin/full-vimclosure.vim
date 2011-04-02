" InsertGt -> Inserts closure only if at the end of the line {{{1
" Else continue editing
function! s:InsertClosure( )
    execute "normal! a}"

    let column = virtcol('.')
    let line_content = getline(line('.'))

    if (matchstr(line_content, '{') == '')
        startinsert
    else

        if (matchstr(line_content, '}\s*}$') != '')
            execute "normal d$"
            execute "normal i\<Cr>"
            execute "normal i\<Cr>"
            let new_line = line('.')
            let spaces = matchstr(line_content, '^\s*')
            "let command = new_line.",".new_line." s/^\\s*//"
            "execute command
            execute "normal i}"
            execute "normal k"
            execute "normal a".spaces
            execute "normal a\<Tab>"
            startinsert!
        else
            let character = getline('.')[column - 1]

            if (character == '}')
                let previous_characters = matchstr(line_content, '{\s*}$')
                if (len(previous_characters) == 2)
                    execute "normal! i"." "
                    execute "normal! i"." "
                    execute "normal! l"
                endif
                if (len(previous_characters) > 2)
                    execute "normal! l"
                    execute "normal! i"." "
                endif
                startinsert
            else 
                execute "normal! l"
                startinsert
            endif
        endif

    endif

endfunction

inoremap <buffer> } <Esc>:call <SID>InsertClosure()<Cr>
