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
        normal! gqG
    endif
endif

" Move the cursor past the headers
normal! gg}
