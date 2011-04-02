" InsertGt -> Inserts closure only if at the end of the line {{{1
" Else continue editing
function! s:InsertClosure(open, close, append_spaces)
    let open_character = a:open
    let close_character = a:close
    let append_spaces = a:append_spaces
    execute "normal! a".close_character

    let column = virtcol('.')
    let line_content = getline(line('.'))
    let spaces = matchstr(line_content, '^\s*')

    if (matchstr(line_content, open_character) == '')
        execute "normal l"
        startinsert
    else
        let end_reg = close_character.'\s*'.close_character.'$'
        if (matchstr(line_content, end_reg) != '')
            execute "normal d$"
            execute "normal i\<Cr>"
            execute "normal i\<Cr>"
            execute "normal d$"
            execute "normal! i".close_character
            let new_line = line('.')
            let command = new_line.",".new_line." s/^\\s*/".spaces."/"
            execute command

            execute "normal k"
            execute "normal a".spaces
            execute "normal a\<Tab>"
            startinsert!
        else
            let character = getline('.')[column - 1]

            if (character == close_character)
                let previous_characters = matchstr(line_content, open_character.'\s*'.close_character.'$')
                if (len(previous_characters) == 2)
                    if (append_spaces)
                        execute "normal! i"." "
                        execute "normal! i"." "
                    endif
                    execute "normal! l"
                endif
                if (len(previous_characters) > 2)
                    execute "normal! l"
                    if (append_spaces)
                        execute "normal! i"." "
                    endif
                endif
                startinsert
            else 
                execute "normal! l"
                startinsert
            endif
        endif

    endif

endfunction

inoremap <buffer> } <Esc>:call <SID>InsertClosure('{', '}', 1)<Cr>
"inoremap <buffer> ) <Esc>:call <SID>InsertClosure('(', ')', 0)<Cr>
"inoremap <buffer> ] <Esc>:call <SID>InsertClosure('[', ']', 0)<Cr>

