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

" Normal mode                                    " fg             & bg
let s:N1 = [ '#005f00' , '#afd700' , 22  , 148 ] " darkestgreen   & brightgreen
"let s:N2 = [ '#00cc00' , '#001100' , 148 , 22 ] " darkestgreen   & brightgreen
let s:N2 = [ '#afd700' , '#303030' , 148 , 236 ] " gray8          & gray2
let s:NB = [ '#9e9e9e' , '#303030' , 247 , 236 ] " gray8          & gray2
let s:N3 = [ '#ffffff' , '#121212' , 231 , 233 ] " white          & gray4
let s:N4 = [ '#666462' , 241 ]                   " mediumgravel

" Insert mode                                    " fg             & bg
let s:I1 = [ '#005f5f' , '#ffffff' , 23  , 231 ] " darkestcyan    & white
let s:I2 = [ '#5fafd7' , '#0087af' , 74  , 31  ] " darkcyan       & darkblue
let s:I3 = [ '#87d7ff' , '#005f87' , 117 , 24  ] " mediumcyan     & darkestblue

" Visual mode                                    " fg             & bg
let s:V1 = [ '#080808' , '#ffaf00' , 232 , 214 ] " gray3          & brightestorange

" Replace mode                                   " fg             & bg
let s:RE = [ '#ffffff' , '#d70000' , 231 , 160 ] " white          & brightred

let g:airline#themes#smkent#palette = {}

let g:airline#themes#smkent#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#smkent#palette.normal.airline_b = [ s:NB[0] , s:NB[1] , s:NB[2] , s:NB[3] , '' ]
let g:airline#themes#smkent#palette.normal_modified = {
      \ 'airline_c': [ s:N1[1]   , s:N2[1]   , s:V1[3]   , s:N3[3]   , ''     ] }

let g:airline#themes#smkent#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#smkent#palette.insert_replace = {
      \ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }
let g:airline#themes#smkent#palette.insert_modified = {
      \ 'airline_c': [ s:I1[1]   , s:I2[1]   , s:V1[3]   , s:I3[3]   , ''     ] }

let g:airline#themes#smkent#palette.visual = {
      \ 'airline_a': [ s:V1[0]   , s:V1[1]   , s:V1[2]   , s:V1[3]   , ''     ] }

let g:airline#themes#smkent#palette.replace = copy(airline#themes#smkent#palette.normal)
let g:airline#themes#smkent#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]
let g:airline#themes#smkent#palette.replace_modified = g:airline#themes#smkent#palette.normal_modified


let s:IA = [ s:N2[1] , s:N3[1] , s:N2[3] , s:N3[3] , '' ]
let g:airline#themes#smkent#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#smkent#palette.inactive_modified = {
      \ 'airline_c': [ s:V1[1]   , ''        , s:V1[3]   , ''        , ''     ] }

