" smkent's vim colors file
"
" This color scheme is meant for 256-color terminals
"
" Partially inspired by:
" https://github.com/w0ng/vim-hybrid/
" https://github.com/tyrannicaltoucan/vim-deep-space

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
let g:colors_name="smkent"

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

" Preferred color palette
" Each array contains a 16-color fallback code followed by the preferred
" 256-color code
let s:p = {}
let s:p.foreground      = [ 7, 251 ]
let s:p.background      = [ 0, 233 ]
let s:p.void_background = [ 0, 234 ]
let s:p.color_column    = [ 8, 236 ]
let s:p.split_column    = [ 8, 249 ]
let s:p.comment         = [ 8, 244 ]
let s:p.underlined      = [ 6, 87  ]
let s:p.todo            = [ 3, 226 ]
let s:p.error           = [ 1, 196 ]
let s:p.incsearch_fg    = [ 0, 222 ]
let s:p.incsearch_bg    = [ 3, 66  ]
let s:p.visual_hl       = [ 3, 64  ]
let s:p.black           = [ 0, 16  ]
let s:p.gray            = [ 7, 244 ] " @TODO: Same as p.comment
let s:p.white           = [ 7, 231 ]
let s:p.red             = [ 1, 167 ]
let s:p.orange          = [ 3, 172 ]
let s:p.light_orange    = [ 3, 215 ]
let s:p.yellow          = [ 3, 221 ]
let s:p.light_yellow    = [ 3, 227 ]
let s:p.yellow_green    = [ 2, 148 ]
let s:p.green           = [ 2, 112 ]
let s:p.light_green     = [ 2, 119 ]
let s:p.cyan            = [ 6, 159 ]
let s:p.blue            = [ 4, 74  ]
let s:p.purple          = [ 5, 139 ]

if has("gui_running") || &t_Co == 256
    let s:color_index = 1
else
    let s:color_index = 0
endif

" Color set function {{{
fun s:C(group, fg, bg, attr)
    if a:fg != []
        exec "hi " . a:group . " guifg=#" . s:term_color_to_gui_color[a:fg[1]]
             \ . " ctermfg=" . a:fg[s:color_index]
    endif
    if a:bg != []
        exec "hi " . a:group . " guibg=#" . s:term_color_to_gui_color[a:bg[1]]
             \ . " ctermbg=" . a:bg[s:color_index]
    endif
    if a:attr != ""
        exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
    endif
endfun
" }}}

" Default highlight groups
" run ":help highlight-groups" for documentation
call s:C("ColorColumn", [], s:p.color_column, "")
" Conceal
" Cursor
" CursorIM
" Directory
" DiffAdd
" DiffChange
" DiffDelete
" DiffText
" ErrorMsg
call s:C("VertSplit", s:p.split_column, s:p.split_column, "reverse")
call s:C("Folded", s:p.blue, s:p.color_column, "bold")
call s:C("FoldColumn", s:p.blue, s:p.color_column, "bold")
call s:C("SignColumn", s:p.foreground, s:p.background, "")
call s:C("IncSearch", s:p.incsearch_fg, s:p.incsearch_bg, "bold")
call s:C("LineNr", s:p.gray, s:p.black, "")
call s:C("CursorLineNr", s:p.foreground, [], "bold")
call s:C("MatchParen", s:p.gray, s:p.green, "bold")
call s:C("ModeMsg", s:p.white, [], "")
call s:C("MoreMsg", s:p.yellow_green, [], "")
call s:C("NonText", s:p.cyan, s:p.void_background, "bold")
call s:C("Normal", s:p.foreground, s:p.background, "")
call s:C("Pmenu", s:p.white, s:p.color_column, "")
call s:C("PmenuSel", s:p.black, s:p.yellow_green, "")
" PMenuSbar
" PMenuThumb
call s:C("Question", s:p.yellow_green, [], "bold")
call s:C("Search", s:p.void_background, s:p.green, "bold")
call s:C("SpecialKey", s:p.error, [], "")
" SpellBad
" SpellCap
" SpellLocal
" SpellRare
call s:C("StatusLine", s:p.black, s:p.blue, "bold")
call s:C("StatusLineNC", s:p.comment, s:p.color_column, "reverse")
" TabLine
" TabLineFill
" TabLineSel
call s:C("Title", s:p.yellow_green, [], "")
call s:C("Visual", s:p.visual_hl, s:p.incsearch_fg, "reverse")
"VisualNOS
call s:C("WarningMsg", s:p.orange, [], "")
"WildMenu
"Menu
"Scrollbar
"Tooltip

" Syntax highlight groups
" run ":help group-name" for documentation and examples
call s:C("Comment",      s:p.comment, [], "")
call s:C("Constant",     s:p.light_orange, [], "")
call s:C("String",       s:p.yellow, [], "")
" Character
" Number
call s:C("Boolean",      s:p.red, [], "")
" Float
call s:C("Identifier",   s:p.cyan, [], "none")
call s:C("Function",     s:p.green, [], "none")
call s:C("Statement",    s:p.blue, [], "bold")
" Conditional
" Repeat
" Label
" Operator
" Keyword
" Exception
call s:C("PreProc",      s:p.purple, [], "")
call s:C("Include",      s:p.purple, [], "")
call s:C("Define",       s:p.blue, [], "")
call s:C("Macro",        s:p.purple, [], "")
call s:C("PreCondit",    s:p.purple, [], "")
call s:C("Type",         s:p.yellow_green, [], "bold")
" StorageClass
" Structure
call s:C("Typedef",      s:p.blue, [], "bold")
call s:C("Special",      s:p.orange, [], "")
call s:C("SpecialChar",  s:p.red, [], "")
" Tag
" Delimeter
" SpecialCommand
" Debug
call s:C("Underlined",   s:p.underlined, [], "")
call s:C("Ignore",       s:p.comment, [], "")
call s:C("Error",        [], s:p.error, "")
call s:C("Todo",         s:p.todo, s:p.comment, "bold")

" Syntax highlight overrides for specific file types
hi link gitrebaseCommit Type
hi link gitrebaseHash Type

" Plugin highlight groups

" Set Sy sign colors
call s:C("SignifySignAdd", s:p.light_green, s:p.background, "bold")
call s:C("SignifySignDelete", s:p.red, s:p.background, "bold")
call s:C("SignifySignChange", s:p.light_yellow, s:p.background, "bold")

" Customize sign column highlight
call s:C("GitGutterAdd", s:p.light_green, s:p.background, "bold")
call s:C("GitGutterDelete", s:p.red, s:p.background, "bold")
call s:C("GitGutterChange", s:p.light_yellow, s:p.background, "bold")
call s:C("GitGutterChangeDelete", s:p.light_yellow, s:p.background, "bold")

" Highlight lines with signs
call s:C("GitGutterAddLine", [], s:p.void_background, "")
call s:C("GitGutterDeleteLine", [], s:p.void_background, "")
call s:C("GitGutterChangeLine", [], s:p.void_background, "")
call s:C("GitGutterChangeDeleteLine", [], s:p.void_background, "")

" Custom highlight groups
call s:C("ExtraWhitespace", [], s:p.error, "")

" Delete set color function
delf s:C

" vim: set fdl=0 fdm=marker:
