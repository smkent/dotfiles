" smkent's vim colors file
"
" This color scheme is meant for 256-color terminals
"
" Partially inspired by:
" https://github.com/w0ng/vim-hybrid/
" https://github.com/tyrannicaltoucan/vim-deep-space

" Clear all existing highlight groups {{{
" Color reset is from the "desert" theme (http://hans.fugal.net/vim/colors/)
set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
" }}}

let g:colors_name="smkent"

" Preferred color palette
" Each array contains a 16-color fallback code followed by the preferred
" 256-color code
let s:foreground      = [ 7, 251 ]
let s:background      = [ 0, 233 ]
let s:void_background = [ 0, 234 ]
let s:color_column    = [ 8, 236 ]
let s:split_column    = [ 8, 249 ]
let s:underlined      = [ 6, 87  ]
let s:todo            = [ 3, 226 ]
let s:error           = [ 1, 196 ]
let s:text_hl         = [ 0, 222 ]
let s:incsearch_hl    = [ 3, 66  ]
let s:visual_hl       = [ 3, 64  ]
let s:black           = [ 0, 16  ]
let s:gray            = [ 7, 244 ]
let s:white           = [ 7, 231 ]
let s:red             = [ 1, 167 ]
let s:orange          = [ 3, 172 ]
let s:light_orange    = [ 3, 215 ]
let s:yellow          = [ 3, 221 ]
let s:light_yellow    = [ 3, 227 ]
let s:yellow_green    = [ 2, 148 ]
let s:lt_yellow_green = [ 2, 192 ]
let s:green           = [ 2, 112 ]
let s:light_green     = [ 2, 119 ]
let s:cyan            = [ 6, 159 ]
let s:blue            = [ 4, 74  ]
let s:light_blue      = [ 4, 117 ]
let s:purple          = [ 5, 139 ]

" Terminal to GUI color map {{{
" Colors from http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
" 0-15: Basic terminal colors (0-7 regular, 8-15 bold)
" 16-231: Extended color palette
" 232-255: Shades of gray
let s:term_color_to_gui_color = [
 \ '000000', '800000', '008000', '808000', '000080', '800080', '008080',
 \ 'c0c0c0', '808080', 'ff0000', '00ff00', 'ffff00', '0000ff', 'ff00ff',
 \ '00ffff', 'ffffff', '000000', '00005f', '000087', '0000af', '0000d7',
 \ '0000ff', '005f00', '005f5f', '005f87', '005faf', '005fd7', '005fff',
 \ '008700', '00875f', '008787', '0087af', '0087d7', '0087ff', '00af00',
 \ '00af5f', '00af87', '00afaf', '00afd7', '00afff', '00d700', '00d75f',
 \ '00d787', '00d7af', '00d7d7', '00d7ff', '00ff00', '00ff5f', '00ff87',
 \ '00ffaf', '00ffd7', '00ffff', '5f0000', '5f005f', '5f0087', '5f00af',
 \ '5f00d7', '5f00ff', '5f5f00', '5f5f5f', '5f5f87', '5f5faf', '5f5fd7',
 \ '5f5fff', '5f8700', '5f875f', '5f8787', '5f87af', '5f87d7', '5f87ff',
 \ '5faf00', '5faf5f', '5faf87', '5fafaf', '5fafd7', '5fafff', '5fd700',
 \ '5fd75f', '5fd787', '5fd7af', '5fd7d7', '5fd7ff', '5fff00', '5fff5f',
 \ '5fff87', '5fffaf', '5fffd7', '5fffff', '870000', '87005f', '870087',
 \ '8700af', '8700d7', '8700ff', '875f00', '875f5f', '875f87', '875faf',
 \ '875fd7', '875fff', '878700', '87875f', '878787', '8787af', '8787d7',
 \ '8787ff', '87af00', '87af5f', '87af87', '87afaf', '87afd7', '87afff',
 \ '87d700', '87d75f', '87d787', '87d7af', '87d7d7', '87d7ff', '87ff00',
 \ '87ff5f', '87ff87', '87ffaf', '87ffd7', '87ffff', 'af0000', 'af005f',
 \ 'af0087', 'af00af', 'af00d7', 'af00ff', 'af5f00', 'af5f5f', 'af5f87',
 \ 'af5faf', 'af5fd7', 'af5fff', 'af8700', 'af875f', 'af8787', 'af87af',
 \ 'af87d7', 'af87ff', 'afaf00', 'afaf5f', 'afaf87', 'afafaf', 'afafd7',
 \ 'afafff', 'afd700', 'afd75f', 'afd787', 'afd7af', 'afd7d7', 'afd7ff',
 \ 'afff00', 'afff5f', 'afff87', 'afffaf', 'afffd7', 'afffff', 'd70000',
 \ 'd7005f', 'd70087', 'd700af', 'd700d7', 'd700ff', 'd75f00', 'd75f5f',
 \ 'd75f87', 'd75faf', 'd75fd7', 'd75fff', 'd78700', 'd7875f', 'd78787',
 \ 'd787af', 'd787d7', 'd787ff', 'd7af00', 'd7af5f', 'd7af87', 'd7afaf',
 \ 'd7afd7', 'd7afff', 'd7d700', 'd7d75f', 'd7d787', 'd7d7af', 'd7d7d7',
 \ 'd7d7ff', 'd7ff00', 'd7ff5f', 'd7ff87', 'd7ffaf', 'd7ffd7', 'd7ffff',
 \ 'ff0000', 'ff005f', 'ff0087', 'ff00af', 'ff00d7', 'ff00ff', 'ff5f00',
 \ 'ff5f5f', 'ff5f87', 'ff5faf', 'ff5fd7', 'ff5fff', 'ff8700', 'ff875f',
 \ 'ff8787', 'ff87af', 'ff87d7', 'ff87ff', 'ffaf00', 'ffaf5f', 'ffaf87',
 \ 'ffafaf', 'ffafd7', 'ffafff', 'ffd700', 'ffd75f', 'ffd787', 'ffd7af',
 \ 'ffd7d7', 'ffd7ff', 'ffff00', 'ffff5f', 'ffff87', 'ffffaf', 'ffffd7',
 \ 'ffffff', '080808', '121212', '1c1c1c', '262626', '303030', '3a3a3a',
 \ '444444', '4e4e4e', '585858', '606060', '666666', '767676', '808080',
 \ '8a8a8a', '949494', '9e9e9e', 'a8a8a8', 'b2b2b2', 'bcbcbc', 'c6c6c6',
 \ 'd0d0d0', 'dadada', 'e4e4e4', 'eeeeee', ]
" }}}

" Color support detection {{{
if has("gui_running") || &t_Co == 256
    let s:color_index = 1
else
    let s:color_index = 0
endif
" }}}

" Color set function {{{
fun s:C(group, fg, bg, attr)
    " Accept a named color variable (List), specific color code, or no color
    " ("") as foreground/background color inputs
    if type(a:fg) == type([])
        let l:fg = a:fg[s:color_index]
    elseif type(a:fg) == type(0)
        let l:fg = a:fg
    else
        let l:fg = ""
    endif
    if type(a:bg) == type([])
        let l:bg = a:bg[s:color_index]
    elseif type(a:bg) == type(0)
        let l:bg = a:bg
    else
        let l:bg = ""
    endif
    " Set highlight group colors
    if type(l:fg) == type(0)
        exec "hi " . a:group . " guifg=#" . s:term_color_to_gui_color[l:fg] .
             \ " ctermfg=" . l:fg
    endif
    if type(l:bg) == type(0)
        exec "hi " . a:group . " guibg=#" . s:term_color_to_gui_color[l:bg] .
             \ " ctermbg=" . l:bg
    endif
    if a:attr != ""
        exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
    endif
endfun
" }}}

" Default highlight groups
" run ":help highlight-groups" for documentation
call s:C("ColorColumn",     "",                 s:color_column,     "")
" Conceal
" Cursor
" CursorIM
" Directory
" DiffAdd
" DiffChange
" DiffDelete
" DiffText
" ErrorMsg
call s:C("VertSplit",       s:split_column,     s:split_column,     "reverse")
call s:C("Folded",          s:light_blue,       s:color_column,     "bold")
call s:C("FoldColumn",      s:light_blue,       s:color_column,     "bold")
call s:C("SignColumn",      s:foreground,       s:background,       "")
call s:C("IncSearch",       s:text_hl,          s:incsearch_hl,     "bold")
call s:C("LineNr",          s:gray,             s:black,            "")
call s:C("CursorLineNr",    s:foreground,       "",                 "bold")
call s:C("MatchParen",      s:gray,             s:green,            "bold")
call s:C("ModeMsg",         s:white,            "",                 "")
call s:C("MoreMsg",         s:yellow_green,     "",                 "")
call s:C("NonText",         s:cyan,             s:void_background,  "bold")
call s:C("Normal",          s:foreground,       s:background,       "")
call s:C("Pmenu",           s:white,            s:color_column,     "")
call s:C("PmenuSel",        s:black,            s:yellow_green,     "")
" PMenuSbar
" PMenuThumb
call s:C("Question",        s:yellow_green,     "",                 "bold")
call s:C("Search",          s:void_background,  s:green,            "bold")
call s:C("SpecialKey",      s:error,            "",                 "")
" SpellBad
" SpellCap
" SpellLocal
" SpellRare
call s:C("StatusLine",      s:black,            s:blue,             "bold")
call s:C("StatusLineNC",    s:gray,             s:color_column,     "reverse")
" TabLine
" TabLineFill
" TabLineSel
call s:C("Title",           s:yellow_green,     "",                 "bold")
call s:C("Visual",          s:visual_hl,        s:text_hl,          "reverse")
"VisualNOS
call s:C("WarningMsg",      s:orange,           "",                 "")
"WildMenu
"Menu
"Scrollbar
"Tooltip

" Syntax highlight groups
" run ":help group-name" for documentation and examples
call s:C("Comment",         s:gray,             "",                 "")
call s:C("Constant",        s:light_orange,     "",                 "")
call s:C("String",          s:yellow,           "",                 "")
" Character
" Number
call s:C("Boolean",         s:red,              "",                 "")
" Float
call s:C("Identifier",      s:lt_yellow_green,  "",                 "none")
call s:C("Function",        s:yellow_green,     "",                 "bold")
call s:C("Statement",       s:blue,             "",                 "bold")
" Conditional
" Repeat
" Label
" Operator
" Keyword
" Exception
call s:C("PreProc",         s:purple,           "",                 "")
call s:C("Include",         s:purple,           "",                 "")
call s:C("Define",          s:blue,             "",                 "")
call s:C("Macro",           s:purple,           "",                 "")
call s:C("PreCondit",       s:purple,           "",                 "")
call s:C("Type",            s:cyan,             "",                 "bold")
" StorageClass
" Structure
call s:C("Typedef",         s:blue,             "",                 "bold")
call s:C("Special",         s:orange,           "",                 "")
call s:C("SpecialChar",     s:red,              "",                 "")
" Tag
" Delimeter
" SpecialCommand
" Debug
call s:C("Underlined",      s:underlined,       "",                 "")
call s:C("Ignore",          s:gray,             "",                 "")
call s:C("Error",           "",                 s:error,            "")
call s:C("Todo",            s:todo,             s:gray,             "bold")

" Syntax highlight overrides for specific file types
" git: red/yellow/green for diff, branches in green, refs in yellow-green bold
call s:C("diffAdded",       s:yellow_green,     "",                 "")
call s:C("diffChanged",     s:yellow,           "",                 "")
call s:C("diffRemoved",     s:red,              "",                 "")
hi link gitcommitType Function
hi link gitcommitBranch Identifier
hi link gitrebaseHash Function
" Python: Separate highlight group for built-ins from function names
hi link pythonBuiltin Identifier
" Markdown: Use blue for heading hashtag delimeters
hi link markdownHeadingDelimiter Statement

" Plugin highlight groups

" CtrlP colors
" Show buffer file names in Normal white instead of Comment gray
hi link CtrlPBufferHid Normal

" Set Sy sign colors
call s:C("SignifySignAdd",    s:light_green,    s:background,       "bold")
call s:C("SignifySignDelete", s:red,            s:background,       "bold")
call s:C("SignifySignChange", s:light_yellow,   s:background,       "bold")

" Customize sign column highlight
call s:C("GitGutterAdd",    s:light_green,      s:background,       "bold")
call s:C("GitGutterDelete", s:red,              s:background,       "bold")
call s:C("GitGutterChange", s:light_yellow,     s:background,       "bold")
hi link GitGutterChangeDelete GitGutterChange

" Highlight lines with signs
call s:C("GitGutterAddLine", "",                s:void_background,  "")
hi link GitGutterDeleteLine GitGutterAddLine
hi link GitGutterChangeLine GitGutterAddLine
hi link GitGutterChangeDeleteLine GitGutterAddLine

" Delete set color function {{{
delf s:C
" }}}

" vim: set fdl=0 fdm=marker:
