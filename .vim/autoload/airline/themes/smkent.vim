" Based on the "powerlineish" theme from
" https://github.com/vim-airline/vim-airline-themes
"
" Modifications from "powerlineish":
" - Code formatting
" - Modified file names in orange
" - Inactive window color uses brighter gray instead of the same color used
"   for buffer backgrounds

" Theme to mimic the default colorscheme of powerline
" Not 100% the same so it's powerline... ish.
"
" Differences from default powerline:
" * Paste indicator isn't colored different
" * Far right hand section matches the color of the mode indicator
"
" Differences from other airline themes:
" * Visual mode only changes the mode section. Otherwise
"   it appears the same as normal mode

" "powerlineish" theme license:
"
" The MIT License (MIT)
"
" Copyright (C) 2013-2016 Bailey Ling & Contributors.
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the "Software"),
" to deal in the Software without restriction, including without limitation
" the rights to use, copy, modify, merge, publish, distribute, sublicense,
" and/or sell copies of the Software, and to permit persons to whom the
" Software is furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included
" in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
" OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
" DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
" TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
" OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

" Normal mode
let s:N1 = [ '#005f00', '#afd700', 22,  148 ]
let s:N2 = [ '#9e9e9e', '#303030', 247, 236 ]
let s:N3 = [ '#ffffff', '#121212', 231, 234 ]
let s:NB = [ '#9e9e9e', '#303030', 247, 236 ]

" Insert mode
let s:I1 = [ '#005f5f', '#ffffff', 23,  231 ]
let s:I2 = [ '#5fafd7', '#0087af', 74,  31  ]
let s:I3 = [ '#87d7ff', '#005f87', 117, 24  ]

" Visual mode
let s:V1 = [ '#080808', '#ffaf00', 232, 214 ]

" Replace mode
let s:RE = [ '#ffffff', '#d70000', 231, 160 ]

" Inactive
let s:IA = [ '#9e9e9e', '#303030', 247, 234 ]

let g:airline#themes#smkent#palette = {}

let g:airline#themes#smkent#palette.normal =
    \ airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#smkent#palette.normal.airline_b =
    \ [ s:NB[0], s:NB[1], s:NB[2], s:NB[3], '' ]
let g:airline#themes#smkent#palette.normal_modified = {
    \ 'airline_c': [ s:N1[1], s:N2[1], s:V1[3], s:N3[3], '' ] }

let g:airline#themes#smkent#palette.insert =
    \ airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#smkent#palette.insert_replace = {
    \ 'airline_a': [ s:RE[0], s:I1[1], s:RE[1], s:I1[3], '' ] }
let g:airline#themes#smkent#palette.insert_modified = {
    \ 'airline_c': [ s:I1[1], s:I2[1], s:V1[3], s:I3[3], '' ] }

let g:airline#themes#smkent#palette.visual = {
    \ 'airline_a': [ s:V1[0], s:V1[1], s:V1[2], s:V1[3], '' ] }

let g:airline#themes#smkent#palette.replace =
    \ copy(airline#themes#smkent#palette.normal)
let g:airline#themes#smkent#palette.replace.airline_a =
    \ [ s:RE[0], s:RE[1], s:RE[2], s:RE[3], '' ]
let g:airline#themes#smkent#palette.replace_modified =
    \ g:airline#themes#smkent#palette.normal_modified

let g:airline#themes#smkent#palette.inactive =
    \ airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#smkent#palette.inactive_modified = {
    \ 'airline_c': [ s:V1[1], '', s:V1[3], '', '' ] }
