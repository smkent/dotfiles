" E-mail

" Enable wrapping
setlocal wrap

" Don't show trailing whitespace using a highlight group
let b:highlight_trailing_whitespace = 0

" Show trailing whitespace as a character instead of a highlight group
setlocal listchars+=trail:·

" Insert trailing spaces in paragraph lines for proper text reflowing
setlocal formatoptions+=w

" Limit text width to 72 characters and display colorcolumn after the boundary
setlocal textwidth=72
if exists('+colorcolumn')
    setlocal colorcolumn=73
endif

" Check if we are composing a message
if !search('Received:', 'nw')
    " Format quoted text properly for format=flowed. Adapted from:
    " http://vim.wikia.com/wiki/Correct_format-flowed_email_function
    " Collapse spaces between leading carats
    while search('^>\+ >', 'w') > 0
        silent! %s/^>\+\zs >/>/
    endwhile
    " Add spaces after carats
    silent! %s/^>\+\ze[^ >]/& /g
    " Match lines that start with carats, don't contain trailing spaces, and
    " aren't the last line in their respective paragraph
    silent! %g/^>\(>*$\)\@!.*[^ ]\ze\n\(^[> ]*$\)\@!/ s/$/ /

    " Reformat quoted messages in replies
    normal! gg}
    silent! %g/^On .* wrote:$/ | nohlsearch
    if getline(line('.')) =~ '^On '
        " Locate quoted lines where words from the following line would be
        " collapsed into the current line during automatic paragraph formatting,
        " and remove the trailing space to preserve the proper formatting.
        let s:quote_start_line = line('.')
        let s:lnum = s:quote_start_line
        while s:lnum < line('$') - 1
            let s:lnum = s:lnum + 1
            execute 'normal! ' . s:lnum . 'G'
            let s:ltext = getline(s:lnum)
            let s:nextltext = getline(s:lnum + 1)
            if s:ltext !~ ' $'
                continue
            endif
            if len(s:ltext) + len(matchstr(s:nextltext, "[^> ][^ ]*")) <= &tw
                silent! s/ \+$//
            endif
        endwhile
        execute 'normal! ' . s:quote_start_line . 'G'
        " Reformat the quoted message
        normal! gqG
    endif

    " Generate and insert a Message-ID header if none present
    " This prevents information leaks:
    " http://www.mutt.org/doc/manual/#security-leaks-mid
    if !search('Message-ID', 'nw') && exists('*strftime')
        " Move to the end of the headers list
        normal! gg}
        " Generate a Message-ID value
        let s:hash = sha256(localtime() . system('head -c 64 /dev/urandom'))
        let s:message_id =
            \ strftime('%Y%m') .
            \ substitute(system('date +%N'), '\n', '', '') . '.' .
            \ strpart(s:hash, 35) .
            \ '@localhost'
        " Insert the Message-ID header
        execute 'normal! O' . 'Message-ID: <' . s:message_id . '>'
    endif
endif

" Move the cursor past the headers
normal! gg}
