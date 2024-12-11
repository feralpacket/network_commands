" Notes {{{
" Vim syntax file
" Language: cisco configuration files
" Version: .628
" 
" Inception: 29-jan-2006
" Inspiration:  Harry Schroeder's original cisco vim syntax file, and a discussion
"               on reddit.com in the vim subreddit on highlighting ip addresses in
"               a syntax file in 2005.  Grown from there.
" Notes:    
"           This does not follow the conventional notion in vim of separate
"           language and color definition files.  That's because cisco
"           configuration syntax, in spite of the misnomer 'code' used when
"           referring to cisco config files, is not a language.  It has no
"           branch logic, data structures, or flow control.  Moreover, in
"           terms purely of syntax, is doesn't have a consistent structure and
"           form.  Configuration lines do not express logic, but rather
"           command parameters.  The chief structure are subcommands, and
"           depending on the command chosen, there are a variable number of
"           nested subcommand mixed with parameters.  Also, I wanted to
"           underline major mode commands like 'interface' and underlining
"           isn't really available in all the syntax mode.  Pandoc does it,
"           but depending on the color scheme it's not always there and in
"           general it's confusing to highlight a command or subcomand using
"           tags meant for programming languages.  What's really needed are
"           tags for the cisco command structure.
"
"           So rather than define new two files, one for colors of highlighted
"           elements and one for determing which configuration words are
"           catagorized as which highlighting elements, all is in one file, to
"           simplify the process of adding new command/configuration line
"           elements.  To add highlighting for a new configuration line, a new
"           section is added to this file. However, in time a consistent
"           logical heirarchy may emerge as a result of this effort, and a
"           workable list of configuration syntax elements consistent and
"           common across all cisco gear and configurations may come into
"           existance.  At that point it will make sense to split this file
"           out into color theme and syntax definition files.
"
"
"           While there are a large collection of keywords as in Schroeder's work, 
"           a smaller set was chosen and highlighting changed so later keywords 
"           in a config line would receive different highlighting.
"
"
"           The most significant change was added when the Conqueterm plugin
"           became available, and a terminal session could be opened in a vim
"           buffer.  That allowed live terminal sessions to be highlighted
"           using a vim syntax file.  Chiefly, error conditions were given
"           initial attention, mostly in the output of 'show interface'
"           command.  From there other selected elements in command output
"           such as versions, interface status, and other items of interest.
"
"           Used with ConqueTerm running bash there is an undesireable side
"           effect when connecting to cisco nexus equipment, when a backspace
"           will 'blank' a line.  
"           To get around this:
"           :ConqueTerm screen -c ~/.screenrcnull
"
"           where .screenrcnull has:
"               vbell off
"           and nothing else.
"
"           screen apparently cleans out what I think are superfluous CR or
"           LF characters from the nexus gear the Conqueterm doesn't handle.
"
"           The foreground colors will as such look the same in any color
"           scheme, so this will look good on some schemes like solarized, and
"           not as good in others, depending on the background.  In essence,
"           about all switching color schemes will do is change the background
"           color and the color of the default text.
"
"           A quick note about versioning.  Currently, three digits are used
"           past the decimal point, i.e. .621 where .622 indicates minor
"           tweaks and additions to highlighting in the third digit.  Whereas
"           .63 would indicate a new subcommand infrastructure.  This is not a
"           particularily good versioning system right now, so this will
"           likely change in the future.
"
" Recent Revision notes:
"           .623
"               Added a global variable g:cisco_background, since I use a
"               terminal with a middle grey background that gives both black
"               and white charactes about the same visibility, about #888888.
"               This is checked for first if the mode is cterm, othewise
"               ignored.
"           .624
"               fixed big number interface rate highlighting
"               changed the switchport command to use keyword/parameter
"               conventions
"               misc removal of old color explicit highlighting syntax
"
"           .625
"               fixes some of the error highlighting for the output of
"               'show interface'
"
"           .626
"               Additions: logging, vrf, others
"
"           .627
"               Added coloring of any large numbers in liu of the rate
"               highlighting for interface statistics
"
"           .628
"               Additions: helper-address, logging onboard, route-cache
"
" }}}
" Setup {{{
synt clear
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

"syn case ignore
setlocal iskeyword+=/
setlocal iskeyword+=:
setlocal iskeyword+=.
setlocal iskeyword+=-

" Define the default hightlighting.

"}}}
" detect and mark gui .vs. term mode set light .vs. dark background color pallets {{{
" gui and 256 terminals will end up with a much richer set of colors.  In the
" 16 color terminal world, colors will that don't exist will just get
" duplicated with the next nearest color - i.e. light red will just be red.
if (has("gui_running"))
    let s:vmode       = " gui"
    if &background == "light"
        let s:white         =   "#ffffff"  " 256 term color 15
        let s:gray          =   "#808080"  " 256 term color 244
        let s:black         =   "#444444"  " 256 term color 238
        let s:param         =   "#303030"  " 256 term color 236
        let s:red           =   "#cd0000"  " 256 term color 1
        let s:orange        =   "#af5f00"  " 256 term color 130
        let s:brown         =   "#875f00"  " 256 term color 94
        let s:yellow        =   "#af8700"  " 256 term color 136
        let s:blue          =   "#0000ff"  " 256 term color 21
        let s:bluegreen     =   "#005f5f"  " 256 term color 23
        let s:cyan          =   "#008787"  " 256 term color 30
        let s:green         =   "#005f00"  " 256 term color 22
        let s:magenta       =   "#5f005f"  " 256 term color 53
        let s:lightmagenta  =   "#ff00ff"  " 256 term color 201
        let s:purple        =   "#5f0087"  " 256 term color 54
        let s:pink          =   "#af005f"  " 256 term color 125
        let s:lime          =   "#5f8700"  " 256 term color 64
        let s:emph_bg       =   "#ffdddd"  " 256 term color 15
        let s:lightblue     =   "#005fff"  " 256 term color 27
    else " assume dark background
        let s:white         =   "#eeeeee"  " 256 term color 255
        let s:gray          =   "#8a8a8a"  " 256 term color 246
        let s:black         =   "#303030"  " 256 term color 236
        let s:param         =   "#e5e5e5"  " 256 term color 7
        let s:red           =   "#ff0000"  " 256 term color 196
        let s:orange        =   "#ff8700"  " 256 term color 208
        let s:brown         =   "#af8700"  " 256 term color 136
        let s:yellow        =   "#ffff00"  " 256 term color 226
        let s:blue          =   "#0087ff"  " 256 term color 33
        let s:bluegreen     =   "#008787"  " 256 term color 30
        let s:cyan          =   "#00ffff"  " 256 term color 51
        let s:green         =   "#00ff00"  " 256 term color 46
        let s:magenta       =   "#ff00ff"  " 256 term color 201
        let s:lightmagenta  =   "#ff87ff"  " 256 term color 213
        let s:purple        =   "#af5fff"  " 256 term color 135
        let s:pink          =   "#ff5fd7"  " 256 term color 206
        let s:lime          =   "#5fff00"  " 256 term color 82
        let s:emph_bg       =   "#400000"  " 256 term color 0
        let s:lightblue     =   "#00afff"  " 256 term color 39
    endif
else " assume terminal mode
    let s:vmode = " cterm"
    if &t_Co == 256
        if g:cisco_background == "grey"
            let s:white         =   "15"
            let s:gray          =   "244"
            let s:black         =   "232"
            let s:param         =   "236"
            let s:red           =   "124"
            let s:orange        =   "130"
            let s:brown         =   "52"
            let s:yellow        =   "226"
            let s:blue          =   "19"
            let s:bluegreen     =   "30"
            let s:cyan          =   "14"
            let s:green         =   "10"
            let s:magenta       =   "126"
            let s:lightmagenta  =   "165"
            let s:purple        =   "54"
            let s:pink          =   "126"
            let s:lime          =   "118"
            let s:emph_bg       =   "176"
            let s:lightblue     =   "26"
        elseif &background == "light"
            let s:white         =   "15"
            let s:gray          =   "244"
            let s:black         =   "232"
            let s:param         =   "236"
            let s:red           =   "1"
            let s:orange        =   "130"
            let s:brown         =   "94"
            let s:yellow        =   "136"
            let s:blue          =   "19"
            let s:bluegreen     =   "37"
            let s:cyan          =   "30"
            let s:green         =   "22"
            let s:magenta       =   "53"
            let s:lightmagenta  =   "199"
            let s:purple        =   "54"
            let s:pink          =   "125"
            let s:lime          =   "64"
            let s:emph_bg       =   "183"
            let s:lightblue     =   "27"
        else " assume dark background
            let s:white         =   "255"
            let s:gray          =   "246"
            let s:black         =   "238"
            let s:param         =   "7"  
            let s:red           =   "196"
            let s:orange        =   "208"
            let s:brown         =   "136"
            let s:yellow        =   "226"
            let s:blue          =   "33"
            let s:bluegreen     =   "30"
            let s:cyan          =   "51"
            let s:green         =   "46"
            let s:magenta       =   "200"
            let s:lightmagenta  =   "213"
            let s:purple        =   "135"
            let s:pink          =   "206"
            let s:lime          =   "82"
            let s:emph_bg       =   "0"
            let s:lightblue     =   "39"
        endif
    else
        if &background == "light"
            let s:white         =   "15"
            let s:gray          =   "8"
            let s:black         =   "0"
            let s:param         =   "0"
            let s:red           =   "1"
            let s:orange        =   "9"
            let s:brown         =   "1"
            let s:yellow        =   "3"
            let s:blue          =   "4"
            let s:bluegreen     =   "6"
            let s:cyan          =   "6"
            let s:green         =   "2"
            let s:magenta       =   "5"
            let s:lightmagenta  =   "5 term=bold"
            let s:purple        =   "12 term=bold"
            let s:pink          =   "5 term=bold"
            let s:lime          =   "2"
            let s:emph_bg       =   "7"
            let s:lightblue     =   "12 term=bold"
        else " assume dark background
            let s:white         =   "15"
            let s:gray          =   "8"
            let s:black         =   "8"
            let s:param         =   "15"  
            let s:red           =   "9"
            let s:orange        =   "9 term=bold"
            let s:brown         =   "1 term=bold"
            let s:yellow        =   "11"
            let s:blue          =   "12"
            let s:bluegreen     =   "14"
            let s:cyan          =   "14"
            let s:green         =   "10"
            let s:magenta       =   "13"
            let s:lightmagenta  =   "13 term=bold"
            let s:purple        =   "12 term=bold"
            let s:pink          =   "13 term=bold"
            let s:lime          =   "10"
            let s:emph_bg       =   "1 term=bold"
            let s:lightblue     =   "12 term=bold"
        endif
    endif
endif
" }}}
" Define formatting {{{
let s:none          = s:vmode."=NONE"
let s:ul            = s:vmode."=underline"
let s:underline     = s:vmode."=underline"
let s:rev           = s:vmode."=reverse"
let s:standout      = s:vmode."=standout"
let s:bold          = s:vmode."=bold"
if (has("gui_running"))
    let s:italic        = s:vmode."=italic"
    let s:ul_italic     = s:vmode."=underline,italic"
    let s:italic_rev    = s:vmode."=italic,reverse"
    let s:italic_stand  = s:vmode."=italic,standout"
    let s:bold_italic   = s:vmode."=bold,italic"
else
    let s:italic        = s:vmode."=none"
    let s:ul_italic     = s:vmode."=underline"
    let s:italic_rev    = s:vmode."=reverse"
    let s:italic_stand  = s:vmode."=standout"
    let s:bold_italic   = s:vmode."=bold"
endif
let s:ul_bold       = s:vmode."=underline,bold"
let s:ul_rev        = s:vmode."=underline,reverse"
let s:ul_stand      = s:vmode."=underline,standout"
let s:bold_rev      = s:vmode."=bold,reverse"
let s:bold_stand    = s:vmode."=bold,standout"
" }}}
" Highlighting commands {{{
let s:h = "hi! "
" this may not be in use - check
exe "let s:interface_type = ' ".s:ul." ".s:vmode."fg=".s:cyan." ".s:vmode."bg=".s:none."'"
" }}}
" background and foreground variables {{{

let s:fgparameter       =   s:vmode . "fg=" . s:param           . " "
let s:fgparameter2      =   s:vmode . "fg=" . s:orange        . " "
let s:fgparameter3      =   s:vmode . "fg=" . s:yellow        . " "
let s:fgparameter4      =   s:vmode . "fg=" . s:cyan          . " "
let s:fgparameter5      =   s:vmode . "fg=" . s:red           . " "
" the keyword heirarchy
let s:fgkeyword         =   s:vmode . "fg=" . s:lightblue       . " "
let s:fgkeyword2        =   s:vmode . "fg=" . s:bluegreen       . " "
let s:fgkeyword3        =   s:vmode . "fg=" . s:purple          . " "
let s:fgkeyword4        =   s:vmode . "fg=" . s:magenta         . " "
let s:fgkeyword5        =   s:vmode . "fg=" . s:green           . " "
let s:fgkeyword6        =   s:vmode . "fg=" . s:lightmagenta    . " "
let s:fgkeyword7        =   s:vmode . "fg=" . s:blue            . " "
" the other foreground stuff...
let s:fgwhite           =   s:vmode . "fg=" . s:white           . " "
let s:fggray            =   s:vmode . "fg=" . s:gray            . " "
let s:fgblack           =   s:vmode . "fg=" . s:black           . " "
let s:fgred             =   s:vmode . "fg=" . s:red             . " "
let s:fgorange          =   s:vmode . "fg=" . s:orange          . " "
let s:fgbrown           =   s:vmode . "fg=" . s:brown           . " "
let s:fgyellow          =   s:vmode . "fg=" . s:yellow          . " "
let s:fgblue            =   s:vmode . "fg=" . s:blue            . " "
let s:fglightblue       =   s:vmode . "fg=" . s:lightblue       . " "
let s:fgbluegreen       =   s:vmode . "fg=" . s:bluegreen       . " "
let s:fgcyan            =   s:vmode . "fg=" . s:cyan            . " "
let s:fggreen           =   s:vmode . "fg=" . s:green           . " "
let s:fgmagenta         =   s:vmode . "fg=" . s:magenta         . " "
let s:fglightmagenta    =   s:vmode . "fg=" . s:lightmagenta    . " "
let s:fgpurple          =   s:vmode . "fg=" . s:purple          . " "
let s:fgpink            =   s:vmode . "fg=" . s:pink            . " "
let s:fglime            =   s:vmode . "fg=" . s:lime            . " "
" backgrounds
let s:bgparameter       =   s:vmode . "bg=" . s:param           . " "
let s:bgwhite           =   s:vmode . "bg=" . s:white           . " "
let s:bggray            =   s:vmode . "bg=" . s:gray            . " "
let s:bgblack           =   s:vmode . "bg=" . s:black           . " "
let s:bgred             =   s:vmode . "bg=" . s:red             . " "
let s:bgorange          =   s:vmode . "bg=" . s:orange          . " "
let s:bgbrown           =   s:vmode . "bg=" . s:brown           . " "
let s:bgyellow          =   s:vmode . "bg=" . s:yellow          . " "
let s:bgblue            =   s:vmode . "bg=" . s:blue            . " "
let s:bglightblue       =   s:vmode . "bg=" . s:lightblue       . " "
let s:bgbluegreen       =   s:vmode . "bg=" . s:bluegreen       . " "
let s:bgcyan            =   s:vmode . "bg=" . s:cyan            . " "
let s:bggreen           =   s:vmode . "bg=" . s:green           . " "
let s:bgmagenta         =   s:vmode . "bg=" . s:magenta         . " "
let s:bglightmagenta    =   s:vmode . "bg=" . s:lightmagenta    . " "
let s:bgpurple          =   s:vmode . "bg=" . s:purple          . " "
let s:bgpink            =   s:vmode . "bg=" . s:pink            . " "
let s:bglime            =   s:vmode . "bg=" . s:lime            . " "
let s:bgemph            =   s:vmode . "bg=" . s:emph_bg         . " "
let s:bgprompt          =   s:vmode . "bg=" . s:lightblue       . " "
" }}}
" formatting Meta {{{
" This may be where themes may at one point come to be.
"
let s:description = s:fgbrown . s:bold_italic
let s:parameter1 = s:bold_italic . s:fgparameter
let s:parameter2 = s:bold_italic . s:fgparameter2
let s:parameter3 = s:bold_italic . s:fgparameter3
let s:parameter4 = s:bold_italic . s:fgparameter4
let s:parameter5 = s:bold_italic . s:fgparameter5
let s:keyword1 = s:fgkeyword    " lightblue
let s:keyword2 = s:fgkeyword2   " purple
let s:keyword3 = s:fgkeyword3   " bluegreen
let s:keyword4 = s:fgkeyword4   " magenta
let s:keyword5 = s:fgkeyword5   " green
let s:keyword6 = s:fgkeyword6   " light magenta
let s:keyword7 = s:fgkeyword7   " blue
let s:emphasis = s:fgred . s:bgemph
let s:error = s:bold . s:fgwhite . s:bgred

synt match parameter1 /[^ ]\+/ skipwhite contained
exe s:h . 'parameter1' . s:parameter1

synt match parameter2 /[^ ]\+/ skipwhite contained
exe s:h . 'parameter2' . s:parameter2

synt match parameter3 /[^ ]\+/ skipwhite contained
exe s:h . 'parameter3' . s:parameter3

synt match parameter4 /[^ ]\+/ skipwhite contained
exe s:h . 'parameter4' . s:parameter4

synt match parameter5 /[^ ]\+/ skipwhite contained
exe s:h . 'parameter5' . s:parameter5

synt match numeric_parameter1 /[0-9]\+/ skipwhite contained
exe s:h . 'numeric_parameter1' . s:parameter1

synt match numeric_parameter2 /[0-9]\+/ skipwhite contained
exe s:h . 'numeric_parameter2' . s:parameter2

synt match numeric_parameter3 /[0-9]\+/ skipwhite contained
exe s:h . 'numeric_parameter3' . s:parameter3

synt match numeric_parameter4 /[0-9]\+/ skipwhite contained
exe s:h . 'numeric_parameter4' . s:parameter4

synt match numeric_parameter5 /[0-9]\+/ skipwhite contained
exe s:h . 'numeric_parameter5' . s:parameter5

synt match cisco_auth_string /[^ ]\+/ skipwhite contained
synt match cisco_auth_string /0/ skipwhite contained nextgroup=parameter5
synt match cisco_auth_string /7/ skipwhite contained nextgroup=parameter2
exe s:h . 'cisco_auth_string' . s:parameter1

" }}}
" Generic parameter nextgroups {{{
" This can be used as a nextgroup in most situations
synt match parameter /[^ ]\+/ contained
exe s:h . "parameter" . s:parameter1
synt match parameter2 /[^ ]\+/ contained
exe s:h . "parameter2" . s:parameter2
synt match parameter3 /[^ ]\+/ contained
exe s:h . "parameter3" . s:parameter3
synt match parameter4 /[^ ]\+/ contained
exe s:h . "parameter4" . s:parameter4
synt match parameter5 /[^ ]\+/ contained
exe s:h . "parameter5" . s:parameter5
" }}}
" other show interface info of interest {{{
synt match channel_members /Members in this channel:/ 
exe s:h . " channel_members " . s:fgmagenta

synt match half_duplex /[Hh]alf-duplex/ 
exe s:h . " half_duplex " . s:fgwhite . s:bgred

synt region media_type excludenl start=/media type is /hs=e+1 end=/$/ excludenl
exe s:h . " media_type " . s:fgpurple

synt match output_drops /output drops: [1-9][0-9]*/ excludenl
exe s:h . " output_drops " . s:bold . s:fgwhite . s:bgred

synt match no_input_output_rate /rate 0 bits\/sec/hs=s+4 
exe s:h . " no_input_output_rate " . s:fgred

synt match tx_rx_load /[rt]xload [0-9]\{1,3}\/[0-9]\{1,3}/ excludenl
exe s:h . " tx_rx_load " . s:fgblue

synt match jumbos /[1-9][0-9]* jumbo/ 
exe s:h . "jumbos" . s:bold . s:bgred

synt match is_down /is down/ 
exe s:h . " is_down " . s:ul . s:fgred

synt match is_up /is up/
exe s:h . " is_up " . s:ul . s:fggreen

synt match int_resets /[1-9][0-9]* interface resets/ excludenl
exe "hi int_resets " . s:bold . s:fgred

"syn cluster show_interface_highlights contains=input_output_rate,is_down,is_up,int_resets,ciscodescription

synt match rxtx_pause /[1-9][0-9]* [RT]x pause/
exe s:h . " rxtx_pause " . s:fgred . s:bgemph

synt match lastclearing /Last clearing of "show interface" counters/ nextgroup=lastclearing_time skipwhite
exe s:h . " lastclearing " . s:italic

synt match lastclearing_time /.*$/ contained excludenl
exe s:h . "lastclearing_time" . s:fgorange

synt match output_buffers_swapped_out /[1-9][0-9]* output buffers swapped out/ excludenl
exe s:h . "output_buffers_swapped_out" . s:bold . s:fgred

synt match SFP_not_inserted /SFP not inserted/
exe s:h . "SFP_not_inserted" . s:bgyellow . s:fgred

"}}}
" Interface names {{{
" This is the secion where the interface name is highlighted.
synt match ciscointerfacetype excludenl /[A-Za-z\-]\{2,} \{0,1}/                 nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[vV][Ee]th \{0,1}/                      nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[vV][Ee]thernet \{0,1}/                 nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ee]th \{0,1}/                          nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ee]thernet \{0,1}/                     nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ff]a \{0,1}/                           nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ff]as \{0,1}/                          nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ff]ast[Ee]thernet \{0,1}/              nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Gg]i \{0,1}/                           nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Gg]ig \{0,1}/                          nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Gg]igabit[Ee]thernet \{0,1}/           nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Tt]e \{0,1}/                           nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Tt]en \{0,1}/                          nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Tt]en[Gg]i \{0,1}/                     nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Tt]en[Gg]igabit[Ee]thernet \{0,1}/     nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Dd]ot11[Rr]adio \{0,1}/                nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ss]er \{0,1}/                          nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ss]erial \{0,1}/                       nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ll]o \{0,1}/                           nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ll]oop \{0,1}/                         nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Ll]oopback \{0,1}/                     nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Tt]un \{0,1}/                          nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Tt]unnel \{0,1}/                       nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Pp][oO][sS]\{0,1}/                     nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Pp]o \{0,1}/                           nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Pp]ort.\{0,1}[cC]hannel \{0,1}/        nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Vv]l \{0,1}/                           nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Vv]lan \{0,1}/                         nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /[Pp][Vv]lan \{0,1}/                     nextgroup=ciscointerfacenumber skipwhite contained 
synt match ciscointerfacetype excludenl /mgmt/                                   nextgroup=ciscointerfacenumber skipwhite contained 
exe s:h . "ciscointerfacetype" . s:ul_bold . s:fgcyan

synt match ciscoNullinterface excludenl /Null0/ 
exe s:h . "ciscoNullinterface" . s:bgemph . s:ul_bold . s:fgred

synt match ciscointerfacenumber excludenl /\d\{1,4}/ contained nextgroup=interfacenumberafterslash skipwhite 
exe s:h . "ciscointerfacenumber" . s:ul_bold . s:fgyellow

synt match interfacenumberafterslash excludenl /\/\d\{1,2}\/\{0,1}\d\{0,2}/ contained nextgroup=ciscosubinterface skipwhite 
exe s:h . "interfacenumberafterslash"  . s:ul_bold . s:fgyellow

synt match ciscosubinterface excludenl /[:.]\{0,1}\d\{0,4}/ contained 
exe s:h . "ciscosubinterface" . s:ul_bold . s:fgorange
" this section is where the interface name region is detected.  Above is where
" it is highlighted
synt region ciscointregion excludenl start="\v[vV][eE]th {0,1}\d{-1,4}[^0-9a-zA-Z]"          end=/$/ end="[,-: ]\|\s"re=e-1 transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[vV][eE]thernet {0,1}\d{-1,4}"                 end=/$/ end="[,-: ]\|\s"re=e-1 transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[eE]th {0,1}\d{-1,3}[^0-9a-zA-Z]"              end=/$/ end="[,-: ]\|\s"re=e-1 transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[eE]thernet {0,1}\d{-1,3}"                     end=/$/ end="[,-: ]\|\s"re=e-1 transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[fF]as{0,1} {0,1}\d{-1,2}[^0-9a-zA-Z]"         end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[fF]ast[eE]thernet {0,1}\d{-1,2}"              end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[gG]ig{0,1} {0,1}\d{-1,2}[^0-9a-zA-Z]"         end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[gG]igabit[eE]thernet {0,1}\d{-1,2}"           end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[tT]en{0,1} {0,1}\d{-1,2}[^0-9a-zA-Z]"         end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[tT]en[gG]i {0,1}\d{-1,2}"                     end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[tT]en[gG]igabit[eE]thernet {0,1}\d{-1,2}"     end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[Dd]ot11[Rr]adio {0,1}\d{-1,2}"                end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[pP][oO][sS]{0,1}\d{-1,4}[^0-9a-zA-Z]"         end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[pP]o {0,1}\d{-1,4}[^0-9a-zA-Z]"               end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[pP]ort.{0,1}[Cc]hannel {0,1}\d{-1,4}"         end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[vV]lan {0,1}\d{-1,4}"                         end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[vV]l {0,1}\d{-1,4}"                           end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[pP][vV]lan {0,1}\d{-1,2}"                     end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[lL]oop {0,1}\d{-1,2}"                     end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[lL]oopback {0,1}\d{-1,2}"                     end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[tT]unnel {0,1}\d{-1,2}"                       end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[sS]erial {0,1}\d{-1,2}"                       end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[lL]o {0,1}\d{1,4}[^0-9a-zA-Z]"                end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[tT]un {0,1}\d{1,4}[^0-9a-zA-Z]"               end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\v[sS]er {0,1}\d{1,4}[^0-9a-zA-Z]"               end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
synt region ciscointregion excludenl start="\vmgmt\d{1,2}[^0-9a-zA-Z]"                       end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype
"synt region ciscointregion excludenl start="Null0"                                           end=/$/ end="[,-: ]\|\s" transparent contains=ciscointerfacetype

synt match dont_highlight excludenl /\v[a-zA-Z0-9][Tt]e {0,1}\d{-1,2}/me=e-3                 skipwhite
synt match dont_highlight excludenl /\v[a-zA-Z0-9][Gg]i {0,1}\d{-1,2}/me=e-3                 skipwhite

"syn region dont_highlight excludenl start=/\v[a-zA-Z0-9][Tt]e {0,1}\d{-1,2}/                end="[,: ]"re=e-3,he=e-3 contains=nohighlight transparent skipwhite
"syn region dont_highlight excludenl start=/\v[a-zA-Z0-9][Gg]i {0,1}\d{-1,2}/                end="[,: ]"re=e-2,he=e-2 contains=nohighlight
"syn match nohighlight /.*/ contained 

"}}}
" interface line config highlighting region {{{

synt match ciscointerface /^int / contained nextgroup=ciscointerfacetype skipwhite 
synt match ciscointerface /^interface / contained nextgroup=ciscointerfacetype skipwhite 
synt match ciscointerface /^Interface:/ contained nextgroup=ciscointerfacetype skipwhite 
exe s:h . "ciscointerface" . s:ul_bold . s:keyword1

synt region interfaceregion  excludenl start="^int[e]\{,1}[r]\{,1}[f]\{,1}[a]\{,1}[c]\{,1}[e]\{,1}" end=".$" transparent keepend contains=ciscointerface

"}}}
" vservices creation line {{{
synt match vserviceline /vservice /          contained containedin=vserviceline_config nextgroup=vserviceline_mode
exe s:h . "vserviceline" . s:ul_bold . s:keyword1

synt match vserviceline_mode /global /       contained containedin=vserviceline nextgroup=vserviceline_kw1
synt match vserviceline_mode /node /         contained containedin=vserviceline nextgroup=vserviceline_node_name
synt match vserviceline_mode /path /         contained containedin=vserviceline nextgroup=vserviceline_path_name
exe s:h . "vserviceline_mode" . s:ul . s:fgorange

synt match vserviceline_kw1 /type /          contained nextgroup=vserviceline_type
exe s:h . "vserviceline_kw1" . s:ul . s:keyword2

synt match vserviceline_type /[^ ]\+$/       contained
exe s:h . "vserviceline_type" . s:ul_bold . s:fgpurple

synt match vserviceline_path_name /[^ ]\+/   contained 
exe s:h . "vserviceline_path_name" . s:ul . s:fgcyan

synt match vserviceline_node_name /[^ ]\+ /  contained nextgroup=vserviceline_kw1
exe s:h . "vserviceline_node_name" . s:ul . s:fgcyan

synt region vserviceline_config start=/^vservice / end=/.$/ excludenl transparent keepend contains=vserviceline

"}}}
" vservice line mirrors vservice creation line sans underline {{{
synt match vservice /vservice /          contained containedin=vservice_line nextgroup=vservice_mode
exe s:h . "vservice" .  s:keyword1

synt match vservice_mode /path /         contained containedin=vservice nextgroup=vservice_path_name
exe s:h . "vservice_mode" . s:keyword2

synt match vservice_path_name /[^ ]\+/   contained containedin=vservice_mode
exe s:h . "vservice_path_name" . s:parameter1

synt region vservice_line start=/^  vservice / end=/.$/ excludenl transparent keepend contains=vservice

"}}}
" Nexus 1000v org line in port profiles {{{
synt match org_root /^  org root\// nextgroup=org_root_name
exe s:h . "org_root" . s:keyword1 

sy match org_root_name /[^ /]\+/ contained containedin=org_root_slash
exe s:h . "org_root_name" . s:bold . s:parameter1

"}}}
" port-profile config highlighting region {{{

synt match port_profile /\v^port-p[r]{0,1}[o]{0,1}[f]{0,1}[i]{0,1}[l]{0,1}[e]{0,1} / skipwhite contained nextgroup=port_profile_kw
synt match port_profile excludenl /^port-profile / skipwhite contained containedin=port_profile_region nextgroup=port_profile_kw
exe s:h . "port_profile" . s:ul_bold . s:keyword1

synt match port_profile_kw /type / skipwhite contained containedin=port_profile nextgroup=port_profiletype
exe s:h ."port_profile_kw" . s:ul . s:keyword2

synt match port_profiletype /vethernet / contained containedin=port_profile_kw nextgroup=port_profilename
exe s:h . "port_profiletype" . s:ul . s:fgblue

synt match port_profilename /[^ ]\+$/ contained containedin=port_profiletype
exe s:h . "port_profilename" . s:ul_bold . s:fggreen

synt region port_profile_region  start="\v^port-p[r]{,1}[o]{,1}[f]{,1}[i]{,1}[l]{,1}[e]{,1}" end="$" transparent keepend contains=port_profile

" kind of related
synt region port_profile_default_region matchgroup=port_profile_default_group start="\v^port-profile default" end="$" transparent keepend contains=port_profile_defaults

synt match port_profile_default_group excludenl /\v^port-profile default/ skipwhite contained containedin=port_profile_default_region
exe s:h . "port_profile_default_group" . s:keyword1

synt match port_profile_defaults excludenl /max-ports /    skipwhite contained containedin=port_profile_default_region nextgroup=port_profile_default_param
synt match port_profile_defaults excludenl /port-binding / skipwhite contained containedin=port_profile_default_region nextgroup=port_profile_default_param
exe s:h . "port_profile_defaults" . s:keyword2

synt match port_profile_default_param /[^ ]\+$/ skipwhite contained containedin=port_profile_defaults
exe s:h . "port_profile_default_param" . s:parameter1


"}}}
" virtual-service-blade config highlighting region {{{

synt match virtual_service_blade /\v^vi[r]{0,1}[t]{0,1}[u]{0,1}[a]{0,1}[l]{0,1}[-]{0,1}[s]{0,1}[e]{0,1}[r]{0,1}[v]{0,1}[i]{0,1}[c]{0,1}[e]{0,1}[-]{0,1}[b]{0,1}[l]{0,1}[a]{0,1}[d]{0,1}[e]{0,1} / skipwhite contained nextgroup=virtual_service_bladetype_kw
synt match virtual_service_blade /^virtual-service-blade / contained containedin=virtual_service_blade_region nextgroup=virtual_service_blade_name
exe s:h . "virtual_service_blade" . s:ul_bold . s:fglightmagenta

synt match virtual_service_blade_name /[^ ]\+$/ contained containedin=virtual_service_blade_region
exe s:h . "virtual_service_blade_name" . s:ul_bold . s:fggreen

synt region virtual_service_blade_region  start="\v^vi[r]{0,1}[t]{0,1}[u]{0,1}[a]{0,1}[l]{0,1}[-]{0,1}[s]{0,1}[e]{0,1}[r]{0,1}[v]{0,1}[i]{0,1}[c]{0,1}[e]{0,1}[-]{0,1}[b]{0,1}[l]{0,1}[a]{0,1}[d]{0,1}[e]{0,1}" end=".$" transparent keepend contains=virtual_service_blade

"}}}
" show cdp neighbor  {{{

synt match DeviceID_text excludenl /[^ ()]\+/ contained nextgroup=DeviceID_Serial 
exe s:h . "DeviceID_text" . s:ul_bold . s:fgblue

synt match DeviceID_Serial excludenl /(.*)/ contained 
exe s:h . "DeviceID_Serial" . s:fgorange

synt match DeviceID_kw excludenl /Device ID: \?/ nextgroup=DeviceID_text
"exe s:h . "DeviceID_kw" . s:fgblue

"syn region DeviceID start="Device ID:" end=".$" contains=DeviceID_kw,DeviceID_Serial,DeviceID_text keepend transparent 

synt match SystemName_text excludenl /[^ ]\+/ contained 
exe s:h . "SystemName_text" . s:fgblue

synt match SystemName_KW excludenl /System Name:/ nextgroup=SystemName_text skipwhite
"exe s:h . "SystemName_KW" . s:fgblue

"syn region SystemName start="System Name:" end=".$" contains=SystemName_KW,SystemName_text keepend transparent 

"}}}
" Misc Global Keywords {{{
" 
syntax match ciscono / no / skipwhite
syntax match ciscono /^no / skipwhite
exe s:h . "ciscono" . s:fgred

synt match connected /connected/ skipwhite
exe s:h . "connected" . s:fggreen

synt match default_KW /default/ skipwhite
exe s:h . 'default_KW' . s:parameter1 

synt match notconnect /not *connect/
synt match notconnect /not *connec[t]\{,1}[e]\{,1}[d]\{,1}/
synt match notconnect /secViolEr/
synt match notconnect /errDisable/
exe s:h . "notconnect" . s:rev . s:fgred

synt match ciscodisable /disable[d]/
exe s:h . "ciscodisable" . s:bold_rev . s:fgorange

synt region vlan_list_reg start=/^vlan [0-9]\{-1,4},/ end="$" contains=vlan_kw,vlan_number transparent keepend
synt match vlan_kw /vlan/ contained
exe s:h . "vlan_kw" . s:keyword1

synt match vlan_number /\d\{1,4}/ contained
exe s:h . "vlan_number" . s:fgparameter

synt match hostname_keyword /hostname / nextgroup=hostname
exe s:h . "hostname_keyword" . s:keyword1

synt match hostname /[^ ]\+ */ contained
exe s:h . "hostname" . s:parameter2 . s:underline

synt match name_keyword / name / nextgroup=name_text
synt match name_keyword /^name / nextgroup=name_text
exe s:h . "name_keyword" . s:keyword1

synt match name_text /[^ ]\+ */ contained
exe s:h . "name_text" . s:parameter2 . s:underline

synt match version_keyword /[vV]ersion/ contained
exe s:h . "version_keyword" . s:keyword1

synt match version_number excludenl /[^ ]\+ */ contained containedin=version_region
exe s:h . "version_number" . s:parameter2 . s:underline

synt region version_region matchgroup=version_keyword start=/[Vv]ersion / end=/$/ end=/ / keepend transparent skipwhite contains=version_number

synt match feature_keyword /feature / nextgroup=feature
exe s:h . "feature_keyword" . s:keyword1

synt match feature /[^ ]\+ */ contained
exe s:h . "feature" . s:parameter2

synt match permit_statement /permit/
exe s:h . "permit_statement" . s:fggreen 

synt match deny_statement /deny/
exe s:h . "deny_statement" . s:fgred 

synt match match_any_keyword /match-any / nextgroup=match_any_text
exe s:h . "match_any_keyword" . s:parameter4

synt match match_any_text /[^ ]\+ */ contained
exe s:h . "match_any_text" . s:parameter2 

synt match misc_keywords1 / location/ nextgroup=name_text skipwhite
synt match misc_keywords1 /contact/ nextgroup=name_text skipwhite
synt match misc_keywords1 /network/ skipwhite
synt match misc_keywords1 /autonomous-system/ skipwhite nextgroup=parameter1
synt match misc_keywords1 /passive-interface/ skipwhite 
synt match misc_keywords1 /load-interval/ skipwhite nextgroup=parameter1

exe s:h . "misc_keywords1" . s:keyword1

synt match boot_system_flash_phrase /boot system flash / nextgroup=boot_image_name skipwhite
exe s:h . "boot_system_flash_phrase" . s:keyword1

synt match boot_image_name /.*/ contained
exe s:h . "boot_image_name" . s:parameter2

synt match interface_speed /^ \?speed/ nextgroup=speed skipwhite
exe s:h . " interface_speed " . s:keyword1

synt match speed /[0-9]\{2,5}/ contained containedin=interface_speed
exe s:h . " speed " . s:bold . s:parameter1

synt match duplex_error excludenl /\v[^ ]+/ contained
exe s:h . " duplex_error " . s:rev . s:fgred

synt match interface_duplex /^ \?duplex/ nextgroup=duplex_full,duplex_half,duplex_auto,duplex_error skipwhite
exe s:h . " interface_duplex " . s:keyword1

synt match duplex_auto /auto/ contained containedin=interface_duplex
exe s:h . "duplex_auto" . s:bold . s:parameter1

synt match duplex_half /half/ contained containedin=interface_duplex
exe s:h . " duplex_half " . s:parameter5

synt match duplex_full /full/ contained containedin=interface_duplex
exe s:h . " duplex_full " . s:parameter1

synt match negotiation_KW /negotiation/ skipwhite nextgroup=parameter1
exe s:h . 'negotiation_KW' . s:keyword1

"syn match cisco_no /no /he=e-1
"exe s:h " cisco_no " . s:bold

synt match shutdown /shutdown/
exe s:h . "shutdown" . s:parameter5

synt match no_shutdown / *no shut/
synt match no_shutdown / *no shutdown/
exe s:h . "no_shutdown" . s:bold . s:fggreen 

synt match Console_Error /^%.*/
exe s:h . "Console_Error" . s:emphasis


"}}}

" Key chain {{{
synt match key_KW /^key/ skipwhite nextgroup=key_chain_KW
exe s:h . 'key_KW' . s:keyword1

synt match key_chain_KW /chain/ skipwhite contained nextgroup=parameter1
exe s:h . 'key_chain_KW' . s:keyword2

synt match key_mode_key_KW / \+key/ skipwhite nextgroup=parameter1
exe s:h . 'key_mode_key_KW' . s:keyword3

synt match key_mode_keystring_KW / \+key-string/ skipwhite nextgroup=parameter2
exe s:h . 'key_mode_keystring_KW' . s:keyword4

"}}}

" show vlan region {{{
"syntax match vlannumber /^[0-9]\{1,4}/ contained nextgroup=vlanname
"HiLink    vlannumber       Keyword
"syntax match vlanname /[a-zA-Z]\{1,32}/ contained
"HiLink    vlanname         Repeat  
"syntax region showvlan start="sh.*vl" end="^[^ ]\{1,63}#" end=/[\r]\{1,63}\#/ contains=vlannumber,ciscointerfacetype,more,ciscointregion,hash_prompt
"}}}
" MTU {{{
synt match MTU_kw excludenl /mtu/ nextgroup=MTU_parameter skipwhite
exe s:h . "MTU_kw" . s:keyword1

synt match MTU_parameter excludenl /[0-9]\{3,4}/ contained containedin=MTU_kw
exe s:h . "MTU_parameter" . s:parameter1

"}}}

" Interface Description and comment highlighting {{{

synt match ciscodescription excludenl /[dD]escription[:]\{0,1}/ nextgroup=ciscodescriptiontext skipwhite
exe s:h . "ciscodescription" . s:keyword1

synt match ciscodescriptiontext excludenl /.*$/ contained
exe s:h . "ciscodescriptiontext" . s:description

synt match commenttext excludenl /.*$/ contained
exe s:h . "commenttext"  . s:italic . s:fggray 

synt region comment excludenl start=/\!/ end=/$/ contains=commenttext keepend transparent

"}}}
" route-map highlighting {{{
synt match routemap_match_WORD /[^ ]\+ */ contained
exe s:h . "routemap_match_WORD" . s:parameter2

synt match routemap_match_kw1 /address/                skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /access-group/           skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /name/                   skipwhite contained containedin=routemap_match_region nextgroup=routemap_match_WORD
synt match routemap_match_kw1 /next-hop/               skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /route-source/           skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /prefix-list/            skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /redistribution-source/  skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /multicast/              skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /unicast/                skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /level-1/                skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /level-2/                skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /local/                  skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /nssa-external/          skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /external/               skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /internal/               skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /bgp/                    skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /connected/              skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /eigrp/                  skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /isis/                   skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /mobile/                 skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /ospf/                   skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /rip /                   skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /static/                 skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /as-path/                skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /cln /                   skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /community/              skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /extcommunity/           skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /interface/              skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /ip /                    skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /ipv6/                   skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /length/                 skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /local-preference/       skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /metric/                 skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /mpls-label/             skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /nlri/                   skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /policy-list/            skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /route-type/             skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /source-protocol/        skipwhite contained containedin=routemap_match_region
synt match routemap_match_kw1 /tag /                   skipwhite contained containedin=routemap_match_region
exe s:h . "routemap_match_kw1" . s:keyword1

synt match routemap_match_kw /match / contained
exe s:h . "routemap_match_kw" . s:keyword1

synt region routemap_match_region matchgroup=routemap_match_kw start=/[ ]*[ ]\+match / end=/$/ transparent contains=routemap_match_kw1

"}}}
" Cisco vrf highlighting {{{
synt match vrf_kw /vrf/ contained containedin=vrf_region nextgroup=vrf_keyword skipwhite
exe s:h . "vrf_kw" . s:keyword1

synt match vrf_keyword /context/     contained containedin=vrf_region nextgroup=vrf_name skipwhite
synt match vrf_keyword /member/      contained containedin=vrf_region nextgroup=vrf_name skipwhite
synt match vrf_keyword /forwarding/  contained containedin=vrf_region nextgroup=vrf_name skipwhite
synt match vrf_keyword /definition/  contained containedin=vrf_region nextgroup=vrf_name skipwhite
exe s:h . "vrf_keyword" . s:keyword2

synt match vrf_name /[^ ]\+ */ contained skipwhite
exe s:h . "vrf_name" . s:parameter5 . s:underline

synt region vrf_region start="vrf context" start="vrf forwarding" start="vrf member" start=/vrf definition/ end="$" skipwhite excludenl keepend transparent contains=vrf_kw, vrf_keyword

synt match vrf_route_table_listing /Table for VRF/ nextgroup=vrf_name skipwhite
exe s:h . "vrf_route_table_listing" s:keyword2

"}}}
" switchport command {{{
" This is a good example of why cisco highlighting can't really be done well
" in the context of highlighting a conventional programming language.  One
" could simply re-use keyword, preproc, repeat, and so forth, but it's more
" straightforward to just say "purple", blue, green, and so forth.  That said,
" the highlighting variable "s:keyword" is used in places, but not to the
" extent of "s:keyword,2,3,4" and so on.  That's one approach that would
" make it easier to have custom color schemes, but that also doesn't fit the
" paradigm of highlighting a conventional programming language.
"
" TODO  make these local to each subgroup, even at the expense of defining
"       the same pattern with different names

"syn match switchport_kw_err excludenl /\v[^ ]+/ contained 
"exe s:h . "switchport_kw_err" . s:rev . s:fgred

synt match encapsulation_tag /\v[0-9]{1,4}/    skipwhite contained
synt match encapsulation_tag /ethertype/       skipwhite contained
exe s:h . "encapsulation_tag" . s:parameter2

synt match switchport_keyword /switchport/
exe s:h . "switchport_keyword" . s:keyword1

" the base set following the root.
" TODO  each should get its own subregion
synt match switchport_base_kwds excludenl /access/         contained 
synt match switchport_base_kwds excludenl /autostate/      contained skipwhite nextgroup=switchport_autostate_kw,switchport_kw_err
synt match switchport_base_kwds excludenl /backup/         contained skipwhite nextgroup=switchport_backup_kw,switchport_kw_err
synt match switchport_base_kwds excludenl /block/          contained skipwhite nextgroup=switchport_block_kw,switchport_kw_err
synt match switchport_base_kwds excludenl /capture/        contained 
synt match switchport_base_kwds excludenl /dot1q /         contained
synt match switchport_base_kwds excludenl /host/           contained 
synt match switchport_base_kwds excludenl /mode/           contained skipwhite nextgroup=switchport_mode_kwds
synt match switchport_base_kwds excludenl /monitor/        contained 
synt match switchport_base_kwds excludenl /trunk/          contained 
synt match switchport_base_kwds excludenl /port-security/  contained 
synt match switchport_base_kwds excludenl /private-vlan/   contained skipwhite nextgroup=switchport_mode_privatevlan_kwds 
synt match switchport_base_kwds excludenl /block/          contained 
synt match switchport_base_kwds excludenl /priority/       contained 
synt match switchport_base_kwds excludenl /encapsulation/  contained 
exe s:h . "switchport_base_kwds" . s:keyword2

" the switchport_command region contains subregions which in turn have end of line terminations
synt region switchport_command matchgroup=switchport_keyword start=/switchport/rs=e+1 end=/$/ contains=switchport_base_kwds,ethernet_address skipwhite keepend transparent

" switchport command nextgroups {{{2

synt match switchport_autostate_kw excludenl /exclude/ contained containedin=switchport_base_kwds skipwhite
exe s:h . "switchport_autostate_kw" . s:keyword3

synt match switchport_backup_kw excludenl /interface/ contained containedin=switchport_base_kwds skipwhite nextgroup=ciscointerfacetype
exe s:h . "switchport_backup_kw" . s:keyword3

synt match switchport_block_kw /unicast/ contained
synt match switchport_block_kw /multicast/ contained
exe s:h . "switchport_block_kw" . s:keyword4
"hi switchport_block_kw ctermfg=red guifg=darkorange

"}}}
" switchport dot1q ethertype {{{2

synt match switchport_dot1q_kw /[dD]ot1[qQ] / contained containedin=switchport_dot1q_ethertype_region
exe s:h . "switchport_dot1q_kw" . s:keyword2 

synt match switchport_dot1q_ethertype_kw /ethertype/ contained containedin=switchport_dot1q_ethertype_region skipwhite nextgroup=switchport_dot1q_ethertype_value
exe s:h . "switchport_dot1q_ethertype_kw" . s:keyword3

synt match switchport_dot1q_ethertype_value /0x[6-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]/ contained containedin=switchport_dot1q_ethertype_kw
exe s:h . "switchport_dot1q_ethertype_value" . s:parameter1

synt region switchport_dot1q_ethertype_region start=/[dD]ot1[qQ] ethertype/ end=/$/ transparent contained containedin=switchport_command
"}}}
" switchport capture allowed vlan {{{2

synt match switchport_capture_allowed_vlan excludenl  /add/     contained containedin=switchport_capture_allowed_vlan_region skipwhite nextgroup=switchport_capture_allowed_vlan_kw
synt match switchport_capture_allowed_vlan excludenl  /except/  contained containedin=switchport_capture_allowed_vlan_region skipwhite nextgroup=switchport_capture_allowed_vlan_kw
synt match switchport_capture_allowed_vlan excludenl  /remove/  contained containedin=switchport_capture_allowed_vlan_region skipwhite nextgroup=switchport_capture_allowed_vlan_kw
synt match switchport_capture_allowed_vlan excludenl  /all/     contained containedin=switchport_capture_allowed_vlan_region
exe s:h . "switchport_capture_allowed_vlan" . s:keyword3 

synt match switchport_capture_allowed_vlan_kw excludenl  /vlan/ contained containedin=switchport_capture_allowed_vlan_region
exe s:h . "switchport_capture_allowed_vlan_kw" . s:keyword4

synt match switchport_capture_allowed_kw excludenl  /allowed/ contained containedin=switchport_capture_allowed_vlan_region
exe s:h . "switchport_capture_allowed_kw" . s:keyword5

synt match switchport_capture_allowed_vlan_list excludenl  /[0-9,-]\+/ contained containedin=switchport_capture_allowed_vlan
exe s:h . "switchport_capture_allowed_vlan_list" . s:parameter1

synt region switchport_capture_allowed_vlan_region matchgroup=switchport_base_kwds start=/capture allowed vlan/rs=e-13 end=/$/ contains=switchport_kw_err skipwhite transparent contained containedin=switchport_command
"}}}
" switchport access {{{2

synt match switchport_conf_access_vlan_kw excludenl  /vlan/ skipwhite contained containedin=switchport_conf_access nextgroup=switchport_conf_access_kw_WORDS
exe s:h . "switchport_conf_access_vlan_kw" . s:keyword4 

synt match switchport_conf_access_kw_WORDS excludenl  /[0-9 ,]\+/ contained containedin=switchport_conf_access
exe s:h . "switchport_conf_access_kw_WORDS" . s:parameter1

synt region switchport_conf_access matchgroup=switchport_base_kwds start=/access/rs=e end=/$/ skipwhite contained containedin=switchport_command

"}}}
" switchport trunk {{{2

synt match switchport_trunk_kwds /encapsulation/ contained skipwhite containedin=switchport_trunk nextgroup=switchport_trunk_encap_kwds
synt match switchport_trunk_kwds /ethertype/     contained skipwhite containedin=switchport_trunk nextgroup=switchport_trunk_ethertype_value
synt match switchport_trunk_kwds /pruning/       contained skipwhite containedin=switchport_trunk nextgroup=switchport_trunk_pruning_vlan_list
synt match switchport_trunk_kwds /allowed/       contained skipwhite containedin=switchport_trunk 
synt match switchport_trunk_kwds /native/        contained skipwhite containedin=switchport_trunk 
exe s:h . "switchport_trunk_kwds" . s:keyword3

synt match switchport_trunk_encap_kwds /encapsulation [Dd]ot1[qQ]/ms=s+13,hs=s+13 contained containedin=switchport_trunk_encap_kwds
synt match switchport_trunk_encap_kwds /[iI][sS][lL]/ contained containedin=switchport_trunk_kwds,switchport_trunk,switchport_command
synt match switchport_trunk_encap_kwds /negotiate/ contained containedin=switchport_trunk_kwds,switchport_trunk
exe s:h . "switchport_trunk_encap_kwds" . s:keyword4 

synt match switchport_trunk_native_vlan_ID /\d\{-1,4}/ contained containedin=switchport_trunk_kwds
synt match switchport_trunk_native_vlan_ID /tag/       contained containedin=switchport_trunk_kwds
exe s:h . "switchport_trunk_native_vlan_ID" . s:parameter1

synt match switchport_trunk_ethertype_value /0x[05-9a-fA-F][e-fE-F]\{0,1}[fF]\{0,1}[fF]\{0,1}/ contained containedin=switchport_trunk_kwds
exe s:h . "switchport_trunk_ethertype_value" . s:parameter1

synt match switchport_trunk_pruning_vlan_list /[0-9,\- ]\+/ contained containedin=switchport_trunk_kwds
exe s:h . "switchport_trunk_pruning_vlan_list" . s:parameter1

" switchport trunk may have subregions that in turn have end of line terminations
synt region switchport_trunk matchgroup=switchport_base_kwds start=/trunk/rs=e end=/$/ skipwhite keepend transparent contained containedin=switchport_command

"}}}
" switchport trunk allowed vlan {{{2
synt match switchport_trunk_allowed_vlan_kwds /add/      skipwhite contained containedin=switchport_trunk_allowed_vlan_region nextgroup=switchport_trunk_allowed_vlan_list
synt match switchport_trunk_allowed_vlan_kwds /all/      skipwhite contained containedin=switchport_trunk_allowed_vlan_region
synt match switchport_trunk_allowed_vlan_kwds /except/   skipwhite contained containedin=switchport_trunk_allowed_vlan_region nextgroup=switchport_trunk_allowed_vlan_list
synt match switchport_trunk_allowed_vlan_kwds /remove/   skipwhite contained containedin=switchport_trunk_allowed_vlan_region nextgroup=switchport_trunk_allowed_vlan_list
synt match switchport_trunk_allowed_vlan_kwds /none/     contained 
exe s:h . "switchport_trunk_allowed_vlan_kwds" . s:keyword5

synt match switchport_trunk_allowed_vlan_list /\v[0-9,\- ]+/ contained containedin=switchport_trunk_allowed_vlan_kwds,switchport_trunk_allowed_vlan_region
exe s:h . "switchport_trunk_allowed_vlan_list" . s:parameter1

"syn match switchport_trunk_allowed_kw /allowed/ contained excludenl containedin=switchport_trunk_allowed_vlan_region
"exe s:h . "switchport_trunk_allowed_kw" . s:keyword4

synt match switchport_trunk_allowed_vlan_kw /vlan/ contained containedin=switchport_trunk_allowed_vlan_region nextgroup=switchport_trunk_allowed_vlan_list
exe s:h . "switchport_trunk_allowed_vlan_kw" . s:keyword4

" NOTE: inserting 'keepend' here breaks it, but removing 'keepend' up at the switchport_trunk region definition also breaks it
synt region switchport_trunk_allowed_vlan_region matchgroup=switchport_trunk_kwds start=/allowed/ end=/$/ skipwhite transparent contained containedin=switchport_command

"}}}
" switchport trunk native vlan {{{2

synt match switchport_trunk_native_vlan_list /\v[0-9,-]+/ contained containedin=switchport_trunk_native_vlan_kw,switchport_trunk_native_vlan_region
exe s:h . "switchport_trunk_native_vlan_list" . s:parameter1

synt match switchport_trunk_native_kw /native/ contained containedin=switchport_trunk_native_vlan_region
exe s:h . "switchport_trunk_native_kw" . s:keyword3

synt match switchport_trunk_native_vlan_kw /vlan/ contained containedin=switchport_trunk_native_vlan_region
exe s:h . "switchport_trunk_native_vlan_kw" . s:keyword4

synt region switchport_trunk_native_vlan_region matchgroup=switchport_trunk_kwds start=/native/ end=/$/ skipwhite transparent contained containedin=switchport_trunk,switchport_command

"}}}
" switchport mode private-vlan {{{2

synt match switchport_mode_privatevlan_kwds /host/               contained skipwhite containedin=switchport_privatevlan
synt match switchport_mode_privatevlan_kwds /promiscuous/        contained skipwhite containedin=switchport_privatevlan
synt match switchport_mode_privatevlan_kwds /mapping/            contained skipwhite containedin=switchport_privatevlan nextgroup=switchport_privatevlan_1
synt match switchport_mode_privatevlan_kwds /native/             contained skipwhite containedin=switchport_privatevlan nextgroup=switchport_privatevlan_1
synt match switchport_mode_privatevlan_kwds /allowed/            contained skipwhite containedin=switchport_privatevlan nextgroup=switchport_privatevlan_1
synt match switchport_mode_privatevlan_kwds /vlan/               contained skipwhite containedin=switchport_privatevlan nextgroup=switchport_privatevlan_1
synt match switchport_mode_privatevlan_kwds /trunk/              contained skipwhite containedin=switchport_privatevlan nextgroup=switchport_trunk
synt match switchport_mode_privatevlan_kwds /host\-association/   contained skipwhite containedin=switchport_privatevlan nextgroup=switchport_privatevlan_1
exe s:h . "switchport_mode_privatevlan_kwds" . s:keyword4

synt match switchport_privatevlan_1 /\v[0-9\- ]+/ contained containedin=switchport_mode_privatevlan_kwds skipwhite nextgroup=switchport_privatevlan_2
exe s:h . "switchport_privatevlan_1" . s:parameter2

synt match switchport_privatevlan_2 /\v[0-9\- ]+/ contained 
exe s:h . "switchport_privatevlan_2" . s:parameter4
"hi switchport_privatevlan_2 ctermfg=red guifg=red gui=italic

synt region switchport_privatevlan matchgroup=switchport_base_kwds start=/private-vlan/rs=e+1 end=/$/ contains=switchport_kw_err skipwhite transparent keepend contained containedin=switchport_trunk,switchport_mode

" }}}
" switchport mode {{{2
synt match switchport_mode_kwds /access/             contained containedin=switchport_mode
synt match switchport_mode_kwds /dot1q\-tunnel/      contained containedin=switchport_mode
synt match switchport_mode_kwds /fex\-fabric/        contained containedin=switchport_mode
synt match switchport_mode_kwds /trunk/              contained containedin=switchport_mode
synt match switchport_mode_kwds /dynamic/            contained containedin=switchport_mode
synt match switchport_mode_kwds /dot1[qQ]\-tunnel/   contained containedin=switchport_mode
synt match switchport_mode_kwds /private-vlan/       contained containedin=switchport_mode skipwhite nextgroup=parameter
exe s:h . "switchport_mode_kwds" . s:keyword3

synt region switchport_mode matchgroup=switchport_base_kwds start=/mode/rs=e end=/$/ skipwhite transparent contained containedin=switchport_command
" }}}
"
" switchport block {{{2
synt match switchport_block_kw /unicast/     contained containedin=switchport_block
synt match switchport_block_kw /multicast/   contained containedin=switchport_block
exe s:h . "switchport_block_kw" . s:keyword3
"hi switchport_block_kw ctermfg=darkyellow

synt region switchport_block matchgroup=switchport_base_kwds start=/block/rs=e end=/$/ contains=switchport_kw_err skipwhite transparent contained containedin=switchport_command
"}}}
"switchport priority {{{2

synt match switchport_priority_extend_kw /extend/    contained containedin=switchport_priority nextgroup=switchport_priority_extend_words
exe s:h . "switchport_priority_extend_kw" . s:keyword3

synt match switchport_priority_extend_words /trust/  contained containedin=switchport_priority 
synt match switchport_priority_extend_words /[0-7]/  contained containedin=switchport_priority
synt match switchport_priority_extend_words /cos/    contained skipwhite containedin=switchport_priority nextgroup=switchport_extent_cos_values
exe s:h . "switchport_priority_extend_words" . s:keyword4

synt match switchport_extent_cos_values /[0-9]\{-1,3}/ contained containedin=switchport_priority_extend_words
exe s:h . "switchport_extent_cos_values" . s:parameter3

synt region switchport_priority matchgroup=switchport_base_kwds start=/priority/rs=e+1 end=/$/ contains=switchport_kw_err contained transparent skipwhite containedin=switchport_command

"}}}
" encapsulation command {{{

"syn match encapsulation_error /\v[^ ]+/ contained
"exe s:h . "encapsulation_error" . s:rev . s:fgred

synt match encapsulation_kw /encapsulation/ contained excludenl containedin=encapsulation_command skipwhite nextgroup=encapsulation_type
exe s:h . "encapsulation_kw" . s:keyword1

" encapsulation_tag was defined in switchport command - re-using it in this region
synt match encapsulation_type /dot1[qQ]/ contained skipwhite nextgroup=encapsulation_tag
exe s:h . "encapsulation_type" . s:keyword2

"syn region encapsulation_command excludenl start=/encapsulation / end=/$/ contains=encapsulation_error keepend transparent
synt region encapsulation_command excludenl start=/ \+encapsulation / end=/$/ keepend transparent

" }}}
" channeling {{{
" NOTE: this is currently a template to be backmigrated to other areas if it
" works out well - JDB 1/9/2015

synt region channel_group_region start=/channel-group / end=/$/ transparent 

synt match channel_group_kw /channel-group/ contained containedin=channel_group_region skipwhite nextgroup=channel_group_number
exe s:h . "channel_group_kw" . s:keyword1

synt match channel_group_number /\v[0-9]+/ contained containedin=channel_group_kw  skipwhite nextgroup=channel_group_mode_kw
exe s:h . "channel_group_number" . s:parameter1

synt match channel_group_mode_kw /mode/ contained skipwhite nextgroup=channel_group_mode
exe s:h . "channel_group_mode_kw" . s:keyword2

synt match channel_group_mode /on/           contained containedin=channel_group_mode_kw 
synt match channel_group_mode /active/       contained containedin=channel_group_mode_kw
synt match channel_group_mode /passive/      contained containedin=channel_group_mode_kw
synt match channel_group_mode /auto/         contained containedin=channel_group_mode_kw
synt match channel_group_mode /desirable/    contained containedin=channel_group_mode_kw
exe s:h . "channel_group_mode" . s:parameter1

synt region channel_protocol_region start=/channel-protocol / end=/$/ transparent 

synt match channel_protocol_kw /channel-protocol/ contained containedin=channel_protocol_region skipwhite nextgroup=channel_protocol
exe s:h "channel_protocol_kw" . s:keyword1

synt match channel_protocol /lacp/ contained skipwhite containedin=channel_protocol_kw 
synt match channel_protocol /pagp/ contained skipwhite containedin=channel_protocol_kw 
exe s:h . "channel_protocol" . s:parameter1

" LACP port priority {{{2
synt region lacp_priority_region start=/lacp port\-prior/ end=/$/ transparent 

synt match lacp_kw /lacp/ contained containedin=lacp_priority_region contained skipwhite containedin=lacp_priority_region
exe s:h . "lacp_kw" . s:keyword1

synt match lacp_port_priority_kw /port\-priority/ contained skipwhite containedin=lacp_priority_region nextgroup=lacp_port_priority
exe s:h . "lacp_port_priority_kw" . s:keyword2

synt match lacp_port_priority /\v[0-9]+/ contained skipwhite containedin=lacp_priority_region
exe s:h . "lacp_port_priority" . s:parameter1
"}}}
" }}}
" interface mode subcommands {{{
"
"TODO: build out each KW into it's own region

synt match int_ip_KW /ip/ contained containedin=int_ip_reg
exe s:h . "int_ip_KW" . s:keyword1

synt region int_ip matchgroup=int_ip_KW start=/^ \+ip / end=/$/ keepend transparent

synt match int_ip_subcommands /router/ skipwhite contained containedin=int_ip nextgroup=int_ip_router_protocol
synt match int_ip_subcommands /route-cache/ skipwhite contained containedin=int_ip
synt match int_ip_subcommands /address/ skipwhite contained containedin=int_ip
synt match int_ip_subcommands /helper-address/ skipwhite contained containedin=int_ip
synt match int_ip_subcommands /summary-address/ skipwhite contained containedin=int_ip nextgroup=int_ip_summ
synt match int_ip_subcommands /pim/ skipwhite contained containedin=int_ip nextgroup=ip_pim_subs
synt match int_ip_subcommands /authentication/ skipwhite contained containedin=int_ip nextgroup=ip_auth_subs
exe s:h . "int_ip_subcommands" . s:keyword2

synt match int_ip_summ /eigrp/ skipwhite contained nextgroup=parameter1
exe s:h . 'int_ip_summ' . s:keyword3

synt match ip_auth_subs /mode/ skipwhite contained nextgroup=ip_auth_mode
synt match ip_auth_subs /key-chain/ skipwhite contained nextgroup=ip_auth_mode
exe s:h . "ip_auth_subs" . s:keyword3

synt match ip_auth_mode /eigrp/ skipwhite contained nextgroup=ip_auth_mode_eigrp_autonomous_number
exe s:h . "ip_auth_mode" . s:keyword4

synt match ip_auth_mode_eigrp_autonomous_number /[0-9]\+ / skipwhite contained nextgroup=ip_auth_mode_hashval
exe s:h . "ip_auth_mode_eigrp_autonomous_number" . s:parameter1

synt match ip_auth_mode_hashval /[^ ]\+/ contained
exe s:h . "ip_auth_mode_hashval" . s:parameter2

synt match ip_pim_subs /border/
synt match ip_pim_subs /dr-delay/ contained skipwhite nextgroup=parameter1
synt match ip_pim_subs /dr-priority/ contained skipwhite nextgroup=parameter1
synt match ip_pim_subs /hello-authentication/ contained skipwhite nextgroup=hello_authentication
synt match ip_pim_subs /hello-interval/ contained skipwhite nextgroup=parameter1
synt match ip_pim_subs /jp-policy/ contained skipwhite nextgroup=parameter1,jp_policy
synt match ip_pim_subs /neighbor-policy/ contained skipwhite nextgroup=neighbor_policy
synt match ip_pim_subs /sparse-mode/ contained 
exe s:h . "ip_pim_subs" . s:keyword3

synt match int_ip_router_protocol /[^ ]\+/ skipwhite contained nextgroup=process_tag
exe s:h . "int_ip_router_protocol" . s:parameter1

synt match process_tag /[0-9]\+/ skipwhite contained 
exe s:h . "process_tag" . s:parameter2

synt region hsrp matchgroup=hsrp_KW start=/^ \+ hsrp / end=/$/ keepend transparent contains=numeric_parameter1

synt match hsrp_KW /hsrp/ skipwhite contained
exe s:h . 'hsrp_KW' . s:keyword1

synt match hsrp_subs /bfd/           skipwhite contained containedin=hsrp
synt match hsrp_subs /delay/         skipwhite contained containedin=hsrp nextgroup=hsrp_delay
synt match hsrp_subs /mac-refresh/   skipwhite contained containedin=hsrp nextgroup=numeric_parameter1
synt match hsrp_subs /use-bia/       skipwhite contained containedin=hsrp
synt match hsrp_subs /version/       skipwhite contained containedin=hsrp nextgroup=numeric_parameter1
exe s:h . "hsrp_subs" . s:keyword2

synt match hsrp_delay /minimum/  skipwhite contained nextgroup=numeric_parameter1
synt match hsrp_delay /reload/   skipwhite contained nextgroup=numeric_parameter1
exe s:h . "hsrp_delay" . s:keyword3

synt match misc_interface_keywords /  \+authentication/ skipwhite nextgroup=parameter1,hsrp_auth_subs
synt match misc_interface_keywords /  \+preempt/ skipwhite nextgroup=preempt_subs
synt match misc_interface_keywords /   \+priority/ skipwhite nextgroup=numeric_parameter1
exe s:h . 'misc_interface_keywords' . s:keyword1

synt match preempt_subs /delay/ skipwhite contained nextgroup=preempt_delay_subs
exe s:h . 'preempt_delay' . s:keyword2

synt match preempt_delay_subs /minimum/  skipwhite contained nextgroup=numeric_parameter1
synt match preempt_delay_subs /reload/   skipwhite contained nextgroup=numeric_parameter1
synt match preempt_delay_subs /sync/     skipwhite contained nextgroup=numeric_parameter1
exe s:h . 'preempt_delay_subs' . s:keyword3

synt match hsrp_auth_subs /md5/    skipwhite contained nextgroup=hsrp_auth_md5_subs
synt match hsrp_auth_subs /text/   skipwhite contained nextgroup=parameter1
exe s:h . 'hsrp_auth_subs' . s:keyword2

synt match hsrp_auth_md5_subs /key-chain/   contained skipwhite nextgroup=parameter1
synt match hsrp_auth_md5_subs /key-string/  contained skipwhite nextgroup=cisco_auth_string
exe s:h . 'hsrp_auth_md5_subs' . s:keyword3

" int_ip_reg_KW {{{2
synt match int_ip_reg_KW /address/            skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /arp/                skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /authentication/     skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /bandwidth-percent/  skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /bandwidth/          skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /delay/              skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /directed-broadcast/ skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /distribute-list/    skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /eigrp/              skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /hello-interval/     skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /hold-time/          skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /igmp/               skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /local-proxy-arp/    skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /mtu/                skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /next-hop-self/      skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /offset-list/        skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /passive-interface/  skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /pim/                skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /policy/             skipwhite contained containedin=int_ip_reg nextgroup=ip_policy_rm
synt match int_ip_reg_KW /port-unreachable/   skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /proxy-arp/          skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /redirects/          skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /router/             skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /split-horizon/      skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /summary-address/    skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /unreachables/       skipwhite contained containedin=int_ip_reg 
synt match int_ip_reg_KW /vrf/                skipwhite contained containedin=int_ip_reg 
exe s:h . "int_ip_reg_KW" . s:keyword2
" }}}2

synt match ip_policy_rm /route-map/      skipwhite contained nextgroup=parameter4
exe s:h . "ip_policy_rm" . s:keyword3

"syn region int_ip_reg matchgroup=int_ip_KW start=/\v {-1,2}ip / start=/#ip/   end=/$/ skipwhite keepend transparent contains=int_ip_reg_KW,ipaddr_in_ciscoipaddr
"syn region int_ip_reg matchgroup=int_ip_KW start=/ip /  end=/$/ skipwhite keepend transparent contains=int_ip_reg_KW,ipaddr_in_ciscoipaddr


" ip authentication {{{2
synt match int_ip_auth_key_chain /[^ ]\+/ skipwhite contained containedin=int_ip_auth_region 
exe s:h . "int_ip_auth_key_chain" . s:parameter2

synt match int_ip_auth_AS /[0-9]\+ /      skipwhite contained containedin=int_ip_auth_region nextgroup=int_ip_auth_key_chain
exe  s:h . "int_ip_auth_AS" . s:parameter1

synt match int_ip_auth_eigrp_KW /eigrp/   skipwhite contained containedin=int_ip_auth_region nextgroup=int_ip_auth_AS
exe s:h . "int_ip_auth_eigrp_KW" . s:keyword4

synt match int_ip_auth_KW /mode/          skipwhite contained containedin=int_ip_auth_region nextgroup=int_ip_auth_eigrp_KW
synt match int_ip_auth_KW /key-chain/     skipwhite contained containedin=int_ip_auth_region nextgroup=int_ip_auth_eigrp_KW
exe  s:h . "int_ip_auth_KW" . s:keyword3

synt region int_ip_auth_region matchgroup=int_ip_reg_KW start=/authentication/rs=e end=/$/ skipwhite transparent contained containedin=int_ip_reg
"}}}

" ip vrf {{{2
synt match int_ip_vrf_kw /vrf/ contained containedin=int_ip_vrf_region nextgroup=vrf_keyword skipwhite
exe s:h . "int_ip_vrf_kw" . s:keyword2

synt match int_ip_vrf_keyword /autoclassify/ contained containedin=int_ip_vrf_region
synt match int_ip_vrf_keyword /receive/      contained containedin=int_ip_vrf_region
synt match int_ip_vrf_keyword /select/       contained containedin=int_ip_vrf_region
synt match int_ip_vrf_keyword /sitemap/      contained containedin=int_ip_vrf_region
synt match int_ip_vrf_keyword /context/      contained containedin=int_ip_vrf_region nextgroup=int_ip_vrf_name skipwhite
synt match int_ip_vrf_keyword /member/       contained containedin=int_ip_vrf_region nextgroup=int_ip_vrf_name skipwhite
synt match int_ip_vrf_keyword /forwarding/   contained containedin=int_ip_vrf_region nextgroup=int_ip_vrf_name skipwhite
exe s:h . "int_ip_vrf_keyword" . s:keyword3

synt match int_ip_vrf_name /[^ ]\+ */ contained containedin=int_ip_vrf_region
exe s:h . "int_ip_vrf_name" . s:parameter5

synt region int_ip_vrf_region matchgroup=int_ip_reg_KW start=/context\|forwarding\|member/rs=e end="$" skipwhite transparent contained containedin=int_ip_reg
"  }}}
" ip pim {{{2

synt match int_ip_pim_KW /bidir-neighbor-filter/     skipwhite contained containedin=int_ip_pim nextgroup=parameter
synt match int_ip_pim_KW /dr-priority/               skipwhite contained containedin=int_ip_pim nextgroup=parameter
synt match int_ip_pim_KW /neighbor-filter/           skipwhite contained containedin=int_ip_pim nextgroup=parameter
synt match int_ip_pim_KW /query-interval/            skipwhite contained containedin=int_ip_pim nextgroup=parameter
synt match int_ip_pim_KW /state-refresh/             skipwhite contained containedin=int_ip_pim nextgroup=state_refresh_orig_intvl
exe s:h . "int_ip_pim_KW" . s:keyword3

synt match state_refresh_orig_intvl /origination-interval/ skipwhite contained containedin=int_ip_pim nextgroup=parameter
exe s:h . "state_refresh_orig_intvl" . s:keyword4

synt match int_ip_pim_param1 /passive/              skipwhite contained containedin=int_ip_pim
synt match int_ip_pim_param1 /nbma-mode/            skipwhite contained containedin=int_ip_pim
synt match int_ip_pim_param1 /bsr-border/           skipwhite contained containedin=int_ip_pim
synt match int_ip_pim_param1 /dense-mode/           skipwhite contained containedin=int_ip_pim
synt match int_ip_pim_param1 /sparse-dense-mode/    skipwhite contained containedin=int_ip_pim
synt match int_ip_pim_param1 /sparse-mode/          skipwhite contained containedin=int_ip_pim
exe s:h . "int_ip_pim_param1" . s:parameter1

synt region int_ip_pim matchgroup=int_ip_reg_KW start=/pim /rs=e end=/$/ skipwhite transparent contained containedin=int_ip_reg


" }}}
" }}}
" router mode command {{{

synt match router_kw /router / skipwhite contained containedin=router_mode_region nextgroup=routing_protocol
exe s:h . 'router_kw' . s:keyword1 . s:underline

 
synt match routing_protocol /bgp /        skipwhite contained nextgroup=process_id 
synt match routing_protocol /eigrp /      skipwhite contained nextgroup=process_id 
synt match routing_protocol /isis /       skipwhite contained nextgroup=process_id 
synt match routing_protocol /iso\-igrp /  skipwhite contained nextgroup=process_id 
synt match routing_protocol /lisp /       skipwhite contained nextgroup=process_id 
synt match routing_protocol /mobile /     skipwhite contained 
synt match routing_protocol /odr /        skipwhite contained 
synt match routing_protocol /ospf /       skipwhite contained nextgroup=process_id 
synt match routing_protocol /ospfv3 /     skipwhite contained nextgroup=process_id 
synt match routing_protocol /rip /        skipwhite contained 
exe s:h . "routing_protocol" . s:keyword2 . s:underline

synt match process_id /[^ ]\+ */ skipwhite contained
exe s:h . "process_id" . s:parameter1 . s:underline

synt region router_mode_region start=/^router / end=/$/ keepend excludenl skipwhite transparent

"}}}
" address-family {{{

synt match address_family_kw /address\-family/ contained containedin=address_family_region skipwhite nextgroup=ip_version
exe s:h . 'address_family_kw' . s:keyword1

synt match ip_version /ipv4/     skipwhite contained nextgroup=address_family_kw3
synt match ip_version /ipv6/     skipwhite contained nextgroup=address_family_kw3
exe s:h . "ip_version" . s:keyword2

synt match address_family_kw3 /vrf/      skipwhite contained nextgroup=vrf_name
synt match address_family_kw3 /unicast/  skipwhite contained nextgroup=af_vrf_kw
exe s:h . "address_family_kw3" . s:keyword3

synt match af_vrf_kw /vrf/   skipwhite contained nextgroup=vrf_name
exe s:h . "af_vrf_kw" . s:keyword4 

synt region address_family_region start=/ address\-family/ end=/$/ transparent keepend excludenl

synt match exit_address_family /exit\-address\-family/ skipwhite
exe s:h . "exit_address_family" . s:fggray 
" }}}
"distribute-list {{{

synt match dl_kw /distribute\-list/  skipwhite contained containedin=distribute_list_region nextgroup=dl_kw2
exe s:h . "dl_kw" . s:keyword1

synt match dl_kw2 /gateway/      skipwhite contained nextgroup=dl_prefix_name
synt match dl_kw2 /prefix/       skipwhite contained nextgroup=dl_prefix_name
synt match dl_kw2 /route-map/    skipwhite contained nextgroup=dl_prefix_name
exe s:h . "dl_kw2" . s:keyword2

synt match dl_prefix_name /[^ ]\+ \+/ skipwhite contained nextgroup=dl_in_out
exe s:h . "dl_prefix_name" . s:parameter3 s:italic

synt match dl_in_out /in/    skipwhite contained
synt match dl_in_out /out/   skipwhite contained
exe s:h . "dl_in_out" . s:keyword3 

synt region distribute_list_region start=/distribute\-list/ end=/$/ transparent excludenl keepend

"}}}
" ip route {{{
" first the global IP command for a few
synt region ip_rt start=/ip route/ end=/$/ keepend transparent 

synt match ip_KW /ip/ skipwhite contained containedin=ip_rt
exe s:h . 'ip_KW' . s:keyword1

synt match ip_route / route/ skipwhite contained containedin=ip_rt nextgroup=ip_route_vrf,ipaddress,subnetmask,wildcard
exe s:h . "ip_route" . s:keyword2

synt match ip_route / route-cache/ skipwhite contained containedin=ip_rt
exe s:h . "ip_route" . s:keyword2

synt match ip_route_vrf /vrf/ skipwhite contained containedin=ip_route nextgroup=ip_route_vrf_name skipwhite
exe s:h . "ip_route_vrf" . s:bold . s:fgred

synt match ip_route_vrf_name / [^ ]\+/ms=s+1 contained containedin=ip_route_vrf skipwhite
exe s:h . "ip_route_vrf_name" . s:none . s:parameter1

synt cluster follows_ip_route contains=ipaddr,ip_route_vrf

synt match route_name_kw /name / skipwhite contained containedin=ip_rt nextgroup=route_name_text
exe s:h . "route_name_kw" . s:fgbrown

synt match route_name_text /.*/ skipwhite contained 
exe s:h . "route_name_text" . s:parameter3

synt match ip_rt_address /address/ skipwhite contained containedin=ip_rt
exe s:h . "ip_rt_address" . s:parameter2

" }}}
" crypto isakmp {{{
synt region crypto_isakmp start=/crypto isakmp/ end=/$/ keepend transparent contains=crypto_KW,isakmp_KW,isakmp_key_KW,crypto_isakmp_address_KW,ipaddress

synt match crypto_KW /crypto/ skipwhite contained  nextgroup=isakmp_KW
exe s:h . "crypto_KW" . s:keyword1

synt match isakmp_KW /isakmp/ skipwhite contained nextgroup=isakmp_key_KW
exe s:h . "isakmp_KW" . s:keyword2

synt match isakmp_key_KW /key/ skipwhite contained  nextgroup=parameter
exe s:h . "isakmp_key_KW" . s:keyword3

synt match crypto_isakmp_address_KW /address/ skipwhite contained 
exe s:h . "crypto_isakmp_address_KW" . s:keyword5

"}}}
" crypto isakmp policy {{{
synt region crypto_isakmp_policy start=/crypto isakmp policy/ end=/$/ keepend transparent contains=crypto_pol_KW,isakmp_pol_KW,crypto_isakmp_policy_KW,crypto_isakmp_policy_number

synt match crypto_pol_KW /crypto / contained  nextgroup=isakmp_pol_KW
exe s:h . "crypto_pol_KW" . s:keyword1 . s:underline

synt match isakmp_pol_KW /isakmp / contained nextgroup=isakmp_key_KW nextgroup=crypto_isakmp_policy_KW
exe s:h . "isakmp_pol_KW" . s:keyword2 . s:underline

synt match crypto_isakmp_policy_KW /policy / contained nextgroup=crypto_isakmp_policy_number
exe s:h . "crypto_isakmp_policy_KW" . s:keyword3 . s:underline

synt match crypto_isakmp_policy_number /[0-9]\+/ skipwhite contained
exe s:h . "crypto_isakmp_policy_number" . s:fgparameter . s:underline

"}}}
" crypto map {{{
synt region crypto_map start=/crypto map/ end=/$/ keepend transparent contains=crypto_map_crypto_KW,crypto_map_map_KW,crypto_map_number

synt match crypto_map_name /[^ ]\+ / contained nextgroup=crypto_map_number
exe s:h . "crypto_map_name" . s:fgparameter . s:underline

synt match crypto_map_crypto_KW /crypto / contained nextgroup=crypto_map_map_KW
exe s:h . "crypto_map_crypto_KW" . s:keyword1 . s:underline

synt match crypto_map_map_KW /map / contained nextgroup=crypto_map_name
exe s:h . "crypto_map_map_KW" . s:keyword2 . s:underline

synt match crypto_map_number /[0-9]\+ / contained nextgroup=crypto_map_type
exe s:h . "crypto_map_number" . s:fgparameter2 . s:underline

synt match crypto_map_type / [^ ]\+/ contained containedin=crypto_map_number
exe s:h . "crypto_map_type" . s:fgparameter3 . s:underline

" }}}
" prefix-list {{{
synt match prefix_name excludenl  / [^ ]\+/ skipwhite contained containedin=prefix_list_kw
exe s:h . "prefix_name" . s:fgbluegreen

synt match prefix_list_kw excludenl /prefix-list/ contained containedin=ip nextgroup=parameter3 skipwhite 
exe s:h . "prefix_list_kw" . s:keyword2

syntax cluster prefix_list contains=prefix_name,prefix_list_kw

synt match seq excludenl  /seq/ skipwhite contained containedin=ip nextgroup=parameter1
exe s:h . "seq" . s:keyword3

synt match seqnum excludenl  /\v\d{1,5}/ skipwhite contained containedin=seq
exe s:h . "seqnum" . s:fggreen

"}}}
" Ethernet address {{{

synt match ethernet_address excludenl /\v[0-9A-Fa-f]{4}\.[0-9A-Fa-f]{4}\.[0-9A-Fa-f]{4}/ 
synt match ethernet_address excludenl /\v[0-9A-Fa-f]{2}[-:][0-9A-Fa-f]{2}[-:][0-9A-Fa-f]{2}[-:][0-9A-Fa-f]{2}[-:][0-9A-Fa-f]{2}[-:][0-9A-Fa-f]{2}/ 
exe s:h . "ethernet_address" . s:bold . s:fgred

"}}}
" IP Address highlighting {{{
" The error catching isn't really vetted out here.  It should highlight *any*
" bad IP address or subnet mask in a way such to show it's wrong.  Doesn't
" quite do that yet.
"
" experimental ip address octet by octet matching and error catch {{{2
" ends up looking kind of trippy, but gives a good impression of how match
" progression works.
"
"syn match anyerror /[^0-9]*/ contained
"syn match anyerror /[0-9][^0-9]\+/ contained
"HiLink    anyerror ErrorMsg
"
"syn match ipaddr_octet_1 /\v(25[0-4]|2[0-4]\d|1\d{,2}|\d{1,2})\./ nextgroup=ipaddr_octet_2,anyerror contained containedin=ipaddr_region
"HiLink ipaddr_octet_1 gitcommitDiscardedType
"
"syn match ipaddr_octet_2 contained /\v(25[0-4]|2[0-4]\d|1\d{,2}|\d{1,2})\./ nextgroup=ipaddr_octet_3,anyerror
"HiLink ipaddr_octet_2 pandocSubscript
"
"syn match ipaddr_octet_3 contained /\v(25[0-4]|2[0-4]\d|1\d{,2}|\d{1,2})\./ nextgroup=ipaddr_octet_4,anyerror
"HiLink ipaddr_octet_3 javaScript
"
"syn match ipaddr_octet_4 contained /\v(25[0-4]|2[0-4]\d|1\d{,2}|\d{1,2})/ nextgroup=cidr
"HiLink ipaddr_octet_4 helpNote

"2}}}
synt match zeros excludenl /\s0\.0\.0\.0/ nextgroup=ipaddr,ipaddr_cidr,subnetmask,wildcard skipwhite 
exe s:h . "zeros" . s:bold . s:fgpink

"syn match ipaddress /(1\d\d|2[0-4]\d|25[0-5]|[1-9]\d|\d)\.(1\d\d|2[0-4]\d|25[0-5]|[1-9]\d|\d)\.(1\d\d|2[0-4]\d|25[0-5]|[1-9]\d|\d)\.(1\d\d|2[0-4]\d|25[0-5]|[1-9]\d|\d)/


synt match ipaddress excludenl /\v\s(25[0-4]|2[0-4]\d|1\d{1,2}|[1-9]\d|[1-9])\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})/ nextgroup=ipaddr,ipaddr_cidr,subnetmask,wildcard skipwhite 
exe s:h . "ipaddress" . s:fgpink


"syn match badmask /\v (12[0-79]|19[013-9]|1[013-8]\d|22[0-35-9]|24[13-9]|25[0136-9]|0\d{1,})\.
"					   \(12[0-79]|19[013-9]|1[013-8]\d|22[0-35-9]|24[13-9]|25[0136-9]|0\d{1,})\.
"					   \(12[0-79]|19[013-9]|1[013-8]\d|22[0-35-9]|24[13-9]|25[0136-9]|0\d{1,})\.
"					   \(12[0-79]|19[013-9]|1[013-8]\d|22[0-35-9]|24[13-9]|25[0136-9]|0\d{1,})excludenl / contained 
"exe s:h . "badmask" . s:rev . s:fgred

" BadIPaddr match {{{2
"syn match BadIPaddr /\v(25[6-9]|2[6-9]\d|[3-9]\d\d)\.\d{1,3}\.\d{1,3}\.\d{1,3}/       contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.(2[5][6-9]|2[6-9]\d|[3-9]\d\d)\.\d{1,3}\.\d{1,3}/     contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.\d{0,3}\.(2[5][6-9]|2[6-9]\d|[3-9]\d\d)\.\d{1,3}/     contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.\d{1,3}\.\d{1,3}\.(2[5][6-9]|2[6-9]\d|[3-9]\d\d)/     contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v(25[6-9]|2[6-9]\d|[3-9]\d\d)\.
"                        \(25[6-9]|2[6-9]\d|[3-9]\d\d)\.
"                        \(25[6-9]|2[6-9]\d|[3-9]\d\d)\.
"                        \(25[6-9]|2[6-9]\d|[3-9]\d\d)/                                contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.\d{1,3}\.\d{4,}\.\d{1,3}/                             contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.\d{4,}\.\d{1,3}\.\d{1,3}/                             contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{4,}\.\d{1,3}\.\d{1,3}\.\d{1,3}/                             contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{4,}\./                           contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.\d{1,3}\.\d{4,}\.\d{1,3}\./                           contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.\d{4,}\.\d{1,3}\.\d{1,3}\./                           contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{4,}\.\d{1,3}\.\d{1,3}\.\d{1,3}\./                           contained excludenl containedin=ipaddr_region
"syn match BadIPaddr /\v\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{4,}/                             contained excludenl containedin=ipaddr_region
"exe s:h . "BadIPaddr" . s:standout . s:fgred
"2}}}


synt match subnetmask contained excludenl  /\v (0|192|224|240|248|252|254|255)\.(0|128|192|224|240|248|252|254|255)\.(0|128|192|224|240|248|252|254|255)\.(0|128|192|224|240|248|252|254|255)/he=e+1
exe s:h . "subnetmask" . s:italic . s:keyword1

synt match wildcard contained excludenl  /\v (127|63|31|15|7|3|1|0)\.(255|127|63|31|15|7|3|1|0)\.(255|127|63|31|15|7|3|1|0)\.(255|127|63|31|15|7|3|1|0)/he=e+1
exe s:h . "wildcard" . s:italic . s:fgblue

synt match ipaddr_kw excludenl /ip address/ contained 
exe s:h . "ipaddr_kw" . s:keyword1

"syn match badmaskoctect excludenl /\v( 12[0-79]|19[013-9]|1[013-8]\d|22[0-35-9]|24[13-9]|25[0136-9]|0\d{1,})/ contained 
"exe s:h . "badmaskoctect" . s:standout . s:fgred

"syn match ipaddr_anyerror "\a\|\d\|[.()!#^&*\-_=+{};'",.excludenl  /<>?]\+" contained containedin=ipaddr_region
"exe s:h . "ipaddr_anyerror" . s:rev . s:fgred

synt match ipaddr_otherkw_param excludenl /.\+$/ contained 
exe s:h . "ipaddr_otherkw_param" . s:fgorange

" add more keywords that follow "ip address" in various places below as needed.
synt match ipaddr_other_keywords "prefix-lists:" nextgroup=ipaddr_otherkw_param skipwhite containedin=ipaddr_region
exe s:h . "ipaddr_other_keywords" . s:bold . s:keyword2

synt match ipaddr_cidr contained excludenl   /\v[/]\d{1,3}/
exe s:h . "ipaddr_cidr" . s:italic . s:keyword1

" an IP address that follows another IP address
synt match ipaddr excludenl /\v(25[0-4]|2[0-4]\d|1\d{1,2}|[1-9]\d|[1-9])\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})/ nextgroup=ipaddr_cidr,subnetmask,wildcard
synt match ipaddr excludenl /\v(25[0-5]|2[0-4]\d|1\d{1,2}|[1-9]\d|[1-9])\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})/
exe s:h . "ipaddr" . s:fgpink . s:bold_italic

"syn region ipaddr_subnetmask_in_ipaddr matchgroup=subnetmask start=/\v(0|192|224|240|248|252|254|255)\.(0|128|192|240|224|248|252|254|255)\.(0|128|192|224|240|248|252|254|255)\.(0|128|192|224|240|248|252|254|255)/ end=/$/ keepend skipwhite transparent excludenl contains=subnetmask contained

"syn region ipaddr_in_ciscoipaddr matchgroup=ipaddr start=/\v(25[0-4]|2[0-4]\d|1\d\d|\d{1,2})\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2}|0)\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2}|0)\.(25[0-5]|2[0-4]\d|1\d\d|\d{1,2})/ end=/$/ keepend skipwhite excludenl transparent contains=ipaddr_cidr,ipaddr,ipaddr_subnetmask_in_ipaddr 

synt region ipaddr_region matchgroup=ipaddr_kw start=/ip addr[e]\{,1}[s]\{,1}[s]\{,1}/rs=e+1 end=/$/ contains=ipaddr_in_ciscoipaddr,ipaddr,ipaddr_cidr,subnetmask,wildcard keepend excludenl transparent skipwhite

"}}}
"
" logging {{{


synt match logging /logging/ skipwhite nextgroup=logging_kw2 contained
exe s:h . "logging" . s:keyword1

" logging_kw2 {{{2
synt match logging_kw2 /event/           skipwhite contained nextgroup=logging_event_type
synt match logging_kw2 /alarm/           skipwhite contained nextgroup=logging_alarm
synt match logging_kw2 /buffered/        skipwhite contained nextgroup=logging_buffered
synt match logging_kw2 /buginf/          skipwhite contained
synt match logging_kw2 /cns-events/      skipwhite contained nextgroup=logging_severity
synt match logging_kw2 /console/         skipwhite contained nextgroup=logging_buffered
synt match logging_kw2 /count/           skipwhite contained
synt match logging_kw2 /delimiter/       skipwhite contained nextgroup=parameter2
synt match logging_kw2 /discriminator/   skipwhite contained nextgroup=parameter2
synt match logging_kw2 /esm/             skipwhite contained nextgroup=parameter2
synt match logging_kw2 /exception/       skipwhite contained nextgroup=parameter2
synt match logging_kw2 /facility/        skipwhite contained nextgroup=logging_facility
synt match logging_kw2 /filter/          skipwhite contained nextgroup=logging_filter
synt match logging_kw2 /history/         skipwhite contained nextgroup=logging_severity
synt match logging_kw2 /host/            skipwhite contained
synt match logging_kw2 /message-counter/ skipwhite contained nextgroup=logging_mc
synt match logging_kw2 /monitor/         skipwhite contained nextgroup=logging_buffered
synt match logging_kw2 /on/              skipwhite contained
synt match logging_kw2 /onboard/              skipwhite contained
synt match logging_kw2 /origin\-id/      skipwhite contained nextgroup=parameter2
synt match logging_kw2 /persistent/           skipwhite contained
synt match logging_kw2 /queue-limit/          skipwhite contained
synt match logging_kw2 /rate-limit/           skipwhite contained
synt match logging_kw2 /reload/               skipwhite contained
synt match logging_kw2 /server\-arp/          skipwhite contained
synt match logging_kw2 /source\-interface/    skipwhite contained
synt match logging_kw2 /trap/                 skipwhite contained
synt match logging_kw2 /userinfo/             skipwhite contained
exe s:h . "logging_kw2" . s:keyword2
" }}}2

" logging_alarm {{{2
synt match logging_alarm /minor/             skipwhite contained
synt match logging_alarm /major/             skipwhite contained
synt match logging_alarm /informational/     skipwhite contained
synt match logging_alarm /critical/          skipwhite contained
synt match logging_alarm /[0-4]/             skipwhite contained
exe s:h . "logging_alarm" . s:keyword3
" }}} 2

"logging_buffered {{{2
synt match logging_buffered /alerts/         skipwhite contained
synt match logging_buffered /critical/       skipwhite contained
synt match logging_buffered /debugging/      skipwhite contained
synt match logging_buffered /discriminator/  skipwhite contained nextgroup=parameter2
synt match logging_buffered /emergencies/    skipwhite contained
synt match logging_buffered /errors/         skipwhite contained
synt match logging_buffered /filtered/       skipwhite contained
synt match logging_buffered /informational/  skipwhite contained
synt match logging_buffered /notifications/  skipwhite contained
synt match logging_buffered /warnings/       skipwhite contained
synt match logging_buffered /xml/            skipwhite contained
synt match logging_buffered /[0-4]/          skipwhite contained
synt match logging_buffered /4[0-9][0-9][0-9][0-9]\{0,}/ skipwhite contained nextgroup=logging_severity
exe s:h . "logging_buffered" . s:parameter1 
" }}}2

" logging_severity {{{2
synt match logging_severity /[0-7]/          skipwhite contained
synt match logging_severity /alerts/         skipwhite contained
synt match logging_severity /critical/       skipwhite contained
synt match logging_severity /debugging/      skipwhite contained
synt match logging_severity /emergencies/    skipwhite contained
synt match logging_severity /errors/         skipwhite contained
synt match logging_severity /informational/  skipwhite contained
synt match logging_severity /notifications/  skipwhite contained
synt match logging_severity /warnings/       skipwhite contained
exe s:h . "logging_severity" . s:parameter2 
" }}}2

" logging_facility {{{2
synt match logging_facility /auth/       skipwhite contained
synt match logging_facility /cron/       skipwhite contained
synt match logging_facility /daemon/     skipwhite contained
synt match logging_facility /kern/       skipwhite contained
synt match logging_facility /local0/     skipwhite contained
synt match logging_facility /local1/     skipwhite contained
synt match logging_facility /local2/     skipwhite contained
synt match logging_facility /local3/     skipwhite contained
synt match logging_facility /local4/     skipwhite contained
synt match logging_facility /local5/     skipwhite contained
synt match logging_facility /local6/     skipwhite contained
synt match logging_facility /local7/     skipwhite contained
synt match logging_facility /lpr/        skipwhite contained
synt match logging_facility /mail/       skipwhite contained
synt match logging_facility /news/       skipwhite contained
synt match logging_facility /sys10/      skipwhite contained
synt match logging_facility /sys11/      skipwhite contained
synt match logging_facility /sys12/      skipwhite contained
synt match logging_facility /sys13/      skipwhite contained
synt match logging_facility /sys14/      skipwhite contained
synt match logging_facility /sys9/       skipwhite contained
synt match logging_facility /syslog/     skipwhite contained
synt match logging_facility /user/       skipwhite contained
synt match logging_facility /uucp/       skipwhite contained
exe s:h . "logging_facility" . s:parameter3 
" }}}2

"logging_filter {{{2
synt match logging_filter /bootflash:/    skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /flash:/        skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /fpd:/          skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /ftp:/          skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /http:/         skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /https:/        skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /nvram:/        skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /obfl:/         skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /rcp:/          skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /scp:/          skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /stby\-nvram:/  skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /stby\-rcsf:/   skipwhite contained nextgroup=logging_filter_args
synt match logging_filter /tftp:/         skipwhite contained nextgroup=logging_filter_args
exe s:h . "logging_filter" . s:keyword3 
" }}}2

" logging_filter_args {{{2
synt match logging_filter_args /1/       skipwhite contained
synt match logging_filter_args /args/    skipwhite contained
exe s:h . "logging_filter_args" . s:parameter3 
" }}}2

synt match logging_event_type /[^ ]\+/ skipwhite contained
exe s:h . "logging_event_type" . s:parameter1 . s:italic

" logging_mc {{{2
synt match logging_mc /debug/    skipwhite contained
synt match logging_mc /log/      skipwhite contained
synt match logging_mc /syslog/   skipwhite contained
exe s:h . "logging_mc" . s:keyword3
" }}}2

synt region logging_global_region start=/logging/ end=/$/ transparent excludenl keepend contains=logging
"syn region interface_logging_region start=/logging event/ end=/$/ transparent excludenl keepend contains=logging

" }}}
"
" colorize big numbers {{{
" This is the *wrong* way to do it, but was a field expediant addition

" mini theme for bits per second.
let s:bitssec  = s:fglightblue
let s:kbitssec = s:fggreen
let s:mbitssec = s:fgorange
let s:gbitssec = s:fgyellow
let s:tbitssec = s:fgmagenta
let s:pbitssec = s:fgcyan

"" Bandwidth {{{ 1
syn region mbitsec_reg start=/\(BW\|bandwidth is\) [0-9]\{4} / end=/Kbit/ oneline keepend contains=mbitsec1b,mbitsec2b
syn match mbitsec2b excludenl  /[0-9]\{3}/ contained
exe s:h . " mbitsec2b " . s:bold . s:mbitssec
syn match mbitsec1b excludenl  /[0-9]\{1}/ contained nextgroup=mbitsec2b
exe s:h . " mbitsec1b " . s:bold . s:gbitssec

syn region mbitsec_reg1 start=/\(BW\|bandwidth is\) [0-9]\{5} / end=/Kbit/ oneline keepend contains=mbitsec3b,mbitsec4b
syn match mbitsec3b excludenl  /[0-9]\{3}/ contained
exe s:h . " mbitsec3b " . s:bold . s:mbitssec
syn match mbitsec4b excludenl  /[0-9]\{2}/ contained nextgroup=mbitsec3b
exe s:h . " mbitsec4b " . s:bold . s:gbitssec

syn region mbitsec_reg2 start=/\(BW\|bandwidth is\) [0-9]\{6} / end=/Kbit/ oneline keepend contains=mbitsec5b,mbitsec6b
syn match mbitsec6b excludenl  /[0-9]\{3}/ contained
exe s:h . " mbitsec6b " . s:bold . s:mbitssec
syn match mbitsec5b excludenl  /[0-9]\{3}/ contained nextgroup=mbitsec6b
exe s:h . " mbitsec5b " . s:bold . s:gbitssec


syn region gbitsec_reg start=/\(BW\|bandwidth is\) [0-9]\{7} / end=/Kbit/ oneline keepend contains=gbitsec2b,gbitsec3b,gbitsec4b
syn match gbitsec4b excludenl  /[0-9]\{3}/ contained 
exe s:h . " gbitsec4b " . s:bold . s:mbitssec
syn match gbitsec3b excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec4b
exe s:h . " gbitsec3b " . s:bold . s:gbitssec
syn match gbitsec2b excludenl  /[0-9]\{1}/ contained nextgroup=gbitsec3b
exe s:h . " gbitsec2b " . s:bold . s:tbitssec

syn region gbitsec_reg2 start=/\(BW\|bandwidth is\) [0-9]\{8} / end=/Kbit/ oneline keepend contains=gbitsec5b,gbitsec6b,gbitsec7b
syn match gbitsec7b excludenl  /[0-9]\{3}/ contained 
exe s:h . " gbitsec7b " . s:bold . s:mbitssec
syn match gbitsec6b excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec7b
exe s:h . " gbitsec6b " . s:bold . s:gbitssec
syn match gbitsec5b excludenl  /[0-9]\{2}/ contained nextgroup=gbitsec6b
exe s:h . " gbitsec5b " . s:bold . s:tbitssec

syn region gbitsec_reg3 start=/\(BW\|bandwidth is\) [0-9]\{9} / end=/Kbit/ oneline keepend contains=gbitsec8b,gbitsec9b,gbitsec10b
syn match gbitsec10b excludenl  /[0-9]\{3}/ contained 
exe s:h . " gbitsec10b " . s:bold . s:mbitssec
syn match gbitsec9b excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec10b
exe s:h . " gbitsec9b " . s:bold . s:gbitssec
syn match gbitsec8b excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec9b
exe s:h . " gbitsec8b " . s:bold . s:tbitssec


syn region tbitsec_reg start=/\(BW\|bandwidth is\) [0-9]\{10} / end=/Kbit/ oneline keepend contains=tbitsec2b,tbitsec3b,tbitsec4b,tbitsec5b
syn match tbitsec5b excludenl /[0-9]\{3}/ contained 
exe s:h . " tbitsec5b " . s:bold . s:mbitssec
syn match tbitsec4b excludenl /[0-9]\{3}/ contained nextgroup=tbitsec5b
exe s:h . " tbitsec4b " . s:bold . s:gbitssec
syn match tbitsec3b excludenl /[0-9]\{3}/ contained nextgroup=tbitsec4b
exe s:h . " tbitsec3b " . s:bold . s:tbitssec
syn match tbitsec2b excludenl /[0-9]\{1}/ contained nextgroup=tbitsec3b
exe s:h . " tbitsec2b " . s:bold . s:pbitssec
"}}} 1
"
"" counters {{{ 1
"syn region mbytes_reg start=/[0-9]\{4} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=mbytes1b,mbytes2b
"syn match mbytes2b excludenl  /[0-9]\{3}/ contained
"exe s:h . " mbytes2b " . s:bold . s:kbitssec
"syn match mbytes1b excludenl  /[0-9]\{1}/ contained nextgroup=mbytes2b
"exe s:h . " mbytes1b " . s:bold . s:mbitssec
"
"syn region mbytes_reg1 start=/[0-9]\{5} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=mbytes3b,mbytes4b
"syn match mbytes3b excludenl  /[0-9]\{3}/ contained
"exe s:h . " mbytes3b " . s:bold . s:kbitssec
"syn match mbytes4b excludenl  /[0-9]\{2}/ contained nextgroup=mbytes3b
"exe s:h . " mbytes4b " . s:bold . s:mbitssec
"
"syn region mbytes_reg2 start=/[0-9]\{6} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=mbytes5b,mbytes6b
"syn match mbytes6b excludenl  /[0-9]\{3}/ contained
"exe s:h . " mbytes6b " . s:bold . s:kbitssec
"syn match mbytes5b excludenl  /[0-9]\{3}/ contained nextgroup=mbytes6b
"exe s:h . " mbytes5b " . s:bold . s:mbitssec
"
"
"syn region gbytes_reg start=/[0-9]\{7} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=gbytes2b,gbytes3b,gbytes4b
"syn match gbytes4b excludenl  /[0-9]\{3}/ contained 
"exe s:h . " gbytes4b " . s:bold . s:kbitssec
"syn match gbytes3b excludenl  /[0-9]\{3}/ contained nextgroup=gbytes4b
"exe s:h . " gbytes3b " . s:bold . s:mbitssec
"syn match gbytes2b excludenl  /[0-9]\{1}/ contained nextgroup=gbytes3b
"exe s:h . " gbytes2b " . s:bold . s:gbitssec
"
"syn region gbytes_reg2 start=/[0-9]\{8} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=gbytes5b,gbytes6b,gbytes7b
"syn match gbytes7b excludenl  /[0-9]\{3}/ contained 
"exe s:h . " gbytes7b " . s:bold . s:kbitssec
"syn match gbytes6b excludenl  /[0-9]\{3}/ contained nextgroup=gbytes7b
"exe s:h . " gbytes6b " . s:bold . s:mbitssec
"syn match gbytes5b excludenl  /[0-9]\{2}/ contained nextgroup=gbytes6b
"exe s:h . " gbytes5b " . s:bold . s:gbitssec
"
"syn region gbytes_reg3 start=/[0-9]\{9} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=gbytes8b,gbytes9b,gbytes10b
"syn match gbytes10b excludenl  /[0-9]\{3}/ contained 
"exe s:h . " gbytes10b " . s:bold . s:kbitssec
"syn match gbytes9b excludenl  /[0-9]\{3}/ contained nextgroup=gbytes10b
"exe s:h . " gbytes9b " . s:bold . s:mbitssec
"syn match gbytes8b excludenl  /[0-9]\{3}/ contained nextgroup=gbytes9b
"exe s:h . " gbytes8b " . s:bold . s:gbitssec
"
"
"syn region tbytes_reg start=/[0-9]\{10} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=tbytes2b,tbytes3b,tbytes4b,tbytes5b
"syn match tbytes5b excludenl /[0-9]\{3}/ contained 
"exe s:h . " tbytes5b " . s:bold . s:kbitssec
"syn match tbytes4b excludenl /[0-9]\{3}/ contained nextgroup=tbytes5b
"exe s:h . " tbytes4b " . s:bold . s:mbitssec
"syn match tbytes3b excludenl /[0-9]\{3}/ contained nextgroup=tbytes4b
"exe s:h . " tbytes3b " . s:bold . s:gbitssec
"syn match tbytes2b excludenl /[0-9]\{1}/ contained nextgroup=tbytes3b
"exe s:h . " tbytes2b " . s:bold . s:tbitssec
"
"
"syn region tbytes_reg2 start=/[0-9]\{11} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=tbytes6b,tbytes7b,tbytes8b,tbytes9b
"syn match tbytes9b excludenl /[0-9]\{3}/ contained 
"exe s:h . " tbytes9b " . s:bold . s:kbitssec
"syn match tbytes8b excludenl /[0-9]\{3}/ contained nextgroup=tbytes9b
"exe s:h . " tbytes8b " . s:bold . s:mbitssec
"syn match tbytes7b excludenl /[0-9]\{3}/ contained nextgroup=tbytes8b
"exe s:h . " tbytes7b " . s:bold . s:gbitssec
"syn match tbytes6b excludenl /[0-9]\{2}/ contained nextgroup=tbytes7b
"exe s:h . " tbytes6b " . s:bold . s:tbitssec
"
"syn region tbytes_reg3 start=/[0-9]\{12} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=tbytes10b,tbytes11b,tbytes12b,tbytes13b,tbytes14b
"syn match tbytes13b excludenl /[0-9]\{3}/ contained 
"exe s:h . " tbytes13b " . s:bold . s:kbitssec
"syn match tbytes12b excludenl /[0-9]\{3}/ contained nextgroup=tbytes13b
"exe s:h . " tbytes12b " . s:bold . s:mbitssec
"syn match tbytes11b excludenl /[0-9]\{3}/ contained nextgroup=tbytes12b
"exe s:h . " tbytes11b " . s:bold . s:gbitssec
"syn match tbytes10b excludenl /[0-9]\{3}/ contained nextgroup=tbytes11b
"exe s:h . " tbytes10b " . s:bold . s:tbitssec
"
"syn region pbytes_reg start=/[0-9]\{13} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=pbytes1b,pbytes2b,pbytes3b,pbytes4b,pbytes5b
"syn match pbytes5b excludenl /[0-9]\{3}/ contained 
"exe s:h . " pbytes5b " . s:bold . s:kbitssec
"syn match pbytes4b excludenl /[0-9]\{3}/ contained nextgroup=pbytes5b
"exe s:h . " pbytes4b " . s:bold . s:mbitssec
"syn match pbytes3b excludenl /[0-9]\{3}/ contained nextgroup=pbytes4b
"exe s:h . " pbytes3b " . s:bold . s:gbitssec
"syn match pbytes2b excludenl /[0-9]\{3}/ contained nextgroup=pbytes3b
"exe s:h . " pbytes2b " . s:bold . s:tbitssec
"syn match pbytes1b excludenl /[0-9]\{1}/ contained nextgroup=pbytes2b
"exe s:h . " pbytes1b " . s:bold . s:pbitssec
"
"syn region pbytes_reg2 start=/[0-9]\{14} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=pbytes6b,pbytes7b,pbytes8b,pbytes9b,pbytes10b
"syn match pbytes10b excludenl /[0-9]\{3}/ contained 
"exe s:h . " pbytes10b " . s:bold . s:kbitssec
"syn match pbytes9b excludenl /[0-9]\{3}/ contained nextgroup=pbytes10b
"exe s:h . " pbytes9b " . s:bold . s:mbitssec
"syn match pbytes8b excludenl /[0-9]\{3}/ contained nextgroup=pbytes9b
"exe s:h . " pbytes8b " . s:bold . s:gbitssec
"syn match pbytes7b excludenl /[0-9]\{3}/ contained nextgroup=pbytes8b
"exe s:h . " pbytes7b " . s:bold . s:tbitssec
"syn match pbytes6b excludenl /[0-9]\{2}/ contained nextgroup=pbytes7b
"exe s:h . " pbytes6b " . s:bold . s:pbitssec
"
"syn region pbytes_reg3 start=/[0-9]\{15} \(bytes\|packets\)/ end=/,\| \|$/ oneline keepend contains=pbytes11b,pbytes12b,pbytes13b,pbytes14b,pbytes15b
"syn match pbytes15b excludenl /[0-9]\{3}/ contained 
"exe s:h . " pbytes15b " . s:bold . s:kbitssec
"syn match pbytes14b excludenl /[0-9]\{3}/ contained nextgroup=pbytes15b
"exe s:h . " pbytes14b " . s:bold . s:mbitssec
"syn match pbytes13b excludenl /[0-9]\{3}/ contained nextgroup=pbytes14b
"exe s:h . " pbytes13b " . s:bold . s:gbitssec
"syn match pbytes12b excludenl /[0-9]\{3}/ contained nextgroup=pbytes13b
"exe s:h . " pbytes12b " . s:bold . s:tbitssec
"syn match pbytes11b excludenl /[0-9]\{3}/ contained nextgroup=pbytes12b
"exe s:h . " pbytes11b " . s:bold . s:pbitssec
"
"
""}}} 1

" input/output bits per second {{{ 1
"syn region bitsec_reg start=/ \(rate\|is\) [0-9]\{2,3} / end=/bit\/sec/ oneline keepend contains=bitsec
"syn match bitsec excludenl /[0-9]\{1,3}/ contained 
"exe s:h . " bitsec " . s:bold . s:bitssec
"
"syn region kbitsec_reg start=/\(is\|rate\) [0-9]\{4} / end=/bit/  oneline keepend contains=kbitsec1,kbitsec2
"syn match kbitsec2 excludenl /[0-9]\{3}/ contained 
"exe s:h . " kbitsec2 " . s:bold . s:bitssec
"syn match kbitsec1 excludenl  /[0-9]\{1}/ contained nextgroup=kbitsec2
"exe s:h . " kbitsec1 " . s:bold . s:kbitssec
"
"syn region kbitsec_reg2 start=/\(is\|rate\) [0-9]\{5} / end=/bit/  oneline keepend contains=kbitsec3,kbitsec4 
"syn match kbitsec4 excludenl /[0-9]\{3}/ contained 
"exe s:h . " kbitsec4 " . s:bold . s:bitssec
"syn match kbitsec3 excludenl  / [0-9]\{2}/ contained nextgroup=kbitsec4
"exe s:h . " kbitsec3 " . s:bold . s:kbitssec
"
"syn region kbitsec_reg3 start=/\(is\|rate\) [0-9]\{6} / end=/bit/  oneline keepend contains=kbitsec5,kbitsec6
"syn match kbitsec6 excludenl /[0-9]\{3}/ contained 
"exe s:h . " kbitsec6 " . s:bold . s:bitssec
"syn match kbitsec5 excludenl  / [0-9]\{3}/ contained nextgroup=kbitsec6
"exe s:h . " kbitsec5 " . s:bold . s:kbitssec
"
"
"
"syn region mbitsec_reg start=/\(is\|rate\) [0-9]\{7} / end=/bit/ oneline keepend contains=mbitsec1,mbitsec2,mbitsec3
"syn match mbitsec3 excludenl  /[0-9]\{3}/ contained 
"exe s:h . " mbitsec3 " . s:bold . s:bitssec
"syn match mbitsec2 excludenl  /[0-9]\{3}/ contained nextgroup=mbitsec3
"exe s:h . " mbitsec2 " . s:bold . s:kbitssec
"syn match mbitsec1 excludenl  /[0-9]\{1}/ contained nextgroup=mbitsec2
"exe s:h . " mbitsec1 " . s:bold . s:mbitssec
"
"syn region mbitsec_reg2 start=/\(is\|rate\) [0-9]\{8} / end=/bit/ oneline keepend contains=mbitsec4,mbitsec5,mbitsec6
"syn match mbitsec6 excludenl  /[0-9]\{3}/ contained 
"exe s:h . " mbitsec6 " . s:bold . s:bitssec
"syn match mbitsec5 excludenl  /[0-9]\{3}/ contained nextgroup=mbitsec6
"exe s:h . " mbitsec5 " . s:bold . s:kbitssec
"syn match mbitsec4 excludenl  /[0-9]\{2}/ contained nextgroup=mbitsec5
"exe s:h . " mbitsec4 " . s:bold . s:mbitssec
"
"syn region mbitsec_reg3 start=/\(is\|rate\) [0-9]\{9} / end=/bit/ oneline keepend contains=mbitsec9,mbitsec8,mbitsec7
"syn match mbitsec7 excludenl  /[0-9]\{3}/ contained 
"exe s:h . " mbitsec7 " . s:bold . s:bitssec
"syn match mbitsec8 excludenl  /[0-9]\{3}/ contained nextgroup=mbitsec7
"exe s:h . " mbitsec8 " . s:bold . s:kbitssec
"syn match mbitsec9 excludenl  /[0-9]\{3}/ contained nextgroup=mbitsec8
"exe s:h . " mbitsec9 " . s:bold . s:mbitssec
"
"
"
"syn region gbitsec_reg start=/\(is\|rate\) [0-9]\{10} / end=/bit/ oneline keepend contains=gbitsec1,gbitsec2,gbitsec3,gbitsec4
"syn match gbitsec4 excludenl  /[0-9]\{3}/ contained 
"exe s:h . " gbitsec4 " . s:bold . s:bitssec
"syn match gbitsec3 excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec4
"exe s:h . " gbitsec3 " . s:bold . s:kbitssec
"syn match gbitsec2 excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec3
"exe s:h . " gbitsec2 " . s:bold . s:mbitssec
"syn match gbitsec1 excludenl  /[0-9]\{1}/ contained nextgroup=gbitsec2
"exe s:h . " gbitsec1 " . s:bold . s:gbitssec
"
"syn region gbitsec_reg2 start=/\(is\|rate\) [0-9]\{11} / end=/bit/ oneline keepend contains=gbitsec5,gbitsec6,gbitsec7,gbitsec8
"syn match gbitsec8 excludenl  /[0-9]\{3}/ contained 
"exe s:h . " gbitsec8 " . s:bold . s:bitssec
"syn match gbitsec7 excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec8
"exe s:h . " gbitsec7 " . s:bold . s:kbitssec
"syn match gbitsec6 excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec7
"exe s:h . " gbitsec6 " . s:bold . s:mbitssec
"syn match gbitsec5 excludenl  /[0-9]\{2}/ contained nextgroup=gbitsec6
"exe s:h . " gbitsec5 " . s:bold . s:gbitssec
"
"syn region gbitsec_reg3 start=/\(is\|rate\) [0-9]\{12} / end=/bit/ oneline keepend contains=gbitsec9,gbitsec10,gbitsec11,gbitsec12
"syn match gbitsec12 excludenl  /[0-9]\{3}/ contained 
"exe s:h . " gbitsec12 " . s:bold . s:bitssec
"syn match gbitsec11 excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec12
"exe s:h . " gbitsec11 " . s:bold . s:kbitssec
"syn match gbitsec10 excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec11
"exe s:h . " gbitsec10 " . s:bold . s:mbitssec
"syn match gbitsec9 excludenl  /[0-9]\{3}/ contained nextgroup=gbitsec10
"exe s:h . " gbitsec9 " . s:bold . s:gbitssec
"
"
"syn region tbitsec_reg start=/\(is\|rate\) [0-9]\{13} / end=/bit/ oneline keepend contains=tbitsec1,tbitsec2,tbitsec3,tbitsec4,tbitsec5
"syn match tbitsec5 excludenl /[0-9]\{3}/ contained 
"exe s:h . " tbitsec5 " . s:bold . s:bitssec
"syn match tbitsec4 excludenl /[0-9]\{3}/ contained nextgroup=tbitsec5
"exe s:h . " tbitsec4 " . s:bold . s:kbitssec
"syn match tbitsec3 excludenl /[0-9]\{3}/ contained nextgroup=tbitsec4
"exe s:h . " tbitsec3 " . s:bold . s:mbitssec
"syn match tbitsec2 excludenl /[0-9]\{3}/ contained nextgroup=tbitsec3
"exe s:h . " tbitsec2 " . s:bold . s:gbitssec
"syn match tbitsec1 excludenl /[0-9]\{1}/ contained nextgroup=tbitsec2
"exe s:h . " tbitsec1 " . s:bold . s:tbitssec
""}}} 1

" big numbers {{{ 1
"syn region mbytes_reg start=/ [0-9]\{4}/ end=/,\| \|$/re=e-1 oneline keepend contains=mbytes1b,mbytes2b
"syn match mbytes2b excludenl  /[0-9]\{3}/ contained
"exe s:h . " mbytes2b " . s:bold . s:kbitssec
"syn match mbytes1b excludenl  /[0-9]\{1}/ contained nextgroup=mbytes2b
"exe s:h . " mbytes1b " . s:bold . s:mbitssec

synt region mbytes_reg1 start=/ [0-9]\{5}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=mbytes3b,mbytes4b
synt match mbytes3b excludenl /[0-9]\{3}/ contained
exe s:h . " mbytes3b " . s:bold . s:kbitssec
synt match mbytes4b excludenl  /[0-9]\{2}/ contained nextgroup=mbytes3b
exe s:h . " mbytes4b " . s:bold . s:mbitssec

synt region mbytes_reg2 start=/ [0-9]\{6}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=mbytes5b,mbytes6b
synt match mbytes6b excludenl  /[0-9]\{3}/ contained
exe s:h . " mbytes6b " . s:bold . s:kbitssec
synt match mbytes5b excludenl  /[0-9]\{3}/ contained nextgroup=mbytes6b
exe s:h . " mbytes5b " . s:bold . s:mbitssec


synt region gbytes_reg start=/ [0-9]\{7}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=gbytes2b,gbytes3b,gbytes4b
synt match gbytes4b excludenl  /[0-9]\{3}/ contained 
exe s:h . " gbytes4b " . s:bold . s:kbitssec
synt match gbytes3b excludenl  /[0-9]\{3}/ contained nextgroup=gbytes4b
exe s:h . " gbytes3b " . s:bold . s:mbitssec
synt match gbytes2b excludenl  /[0-9]\{1}/ contained nextgroup=gbytes3b
exe s:h . " gbytes2b " . s:bold . s:gbitssec

synt region gbytes_reg2 start=/ [0-9]\{8}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=gbytes5b,gbytes6b,gbytes7b
synt match gbytes7b excludenl  /[0-9]\{3}/ contained 
exe s:h . " gbytes7b " . s:bold . s:kbitssec
synt match gbytes6b excludenl  /[0-9]\{3}/ contained nextgroup=gbytes7b
exe s:h . " gbytes6b " . s:bold . s:mbitssec
synt match gbytes5b excludenl  /[0-9]\{2}/ contained nextgroup=gbytes6b
exe s:h . " gbytes5b " . s:bold . s:gbitssec

synt region gbytes_reg3 start=/ [0-9]\{9}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=gbytes8b,gbytes9b,gbytes10b
synt match gbytes10b excludenl  /[0-9]\{3}/ contained 
exe s:h . " gbytes10b " . s:bold . s:kbitssec
synt match gbytes9b excludenl  /[0-9]\{3}/ contained nextgroup=gbytes10b
exe s:h . " gbytes9b " . s:bold . s:mbitssec
synt match gbytes8b excludenl  /[0-9]\{3}/ contained nextgroup=gbytes9b
exe s:h . " gbytes8b " . s:bold . s:gbitssec


synt region tbytes_reg start=/ [0-9]\{10}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=tbytes2b,tbytes3b,tbytes4b,tbytes5b
synt match tbytes5b excludenl /[0-9]\{3}/ contained 
exe s:h . " tbytes5b " . s:bold . s:kbitssec
synt match tbytes4b excludenl /[0-9]\{3}/ contained nextgroup=tbytes5b
exe s:h . " tbytes4b " . s:bold . s:mbitssec
synt match tbytes3b excludenl /[0-9]\{3}/ contained nextgroup=tbytes4b
exe s:h . " tbytes3b " . s:bold . s:gbitssec
synt match tbytes2b excludenl /[0-9]\{1}/ contained nextgroup=tbytes3b
exe s:h . " tbytes2b " . s:bold . s:tbitssec


synt region tbytes_reg2 start=/ [0-9]\{11}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=tbytes6b,tbytes7b,tbytes8b,tbytes9b
synt match tbytes9b excludenl /[0-9]\{3}/ contained 
exe s:h . " tbytes9b " . s:bold . s:kbitssec
synt match tbytes8b excludenl /[0-9]\{3}/ contained nextgroup=tbytes9b
exe s:h . " tbytes8b " . s:bold . s:mbitssec
synt match tbytes7b excludenl /[0-9]\{3}/ contained nextgroup=tbytes8b
exe s:h . " tbytes7b " . s:bold . s:gbitssec
synt match tbytes6b excludenl /[0-9]\{2}/ contained nextgroup=tbytes7b
exe s:h . " tbytes6b " . s:bold . s:tbitssec

synt region tbytes_reg3 start=/ [0-9]\{12}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=tbytes10b,tbytes11b,tbytes12b,tbytes13b,tbytes14b
synt match tbytes13b excludenl /[0-9]\{3}/ contained 
exe s:h . " tbytes13b " . s:bold . s:kbitssec
synt match tbytes12b excludenl /[0-9]\{3}/ contained nextgroup=tbytes13b
exe s:h . " tbytes12b " . s:bold . s:mbitssec
synt match tbytes11b excludenl /[0-9]\{3}/ contained nextgroup=tbytes12b
exe s:h . " tbytes11b " . s:bold . s:gbitssec
synt match tbytes10b excludenl /[0-9]\{3}/ contained nextgroup=tbytes11b
exe s:h . " tbytes10b " . s:bold . s:tbitssec

synt region pbytes_reg start=/ [0-9]\{13}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=pbytes1b,pbytes2b,pbytes3b,pbytes4b,pbytes5b
synt match pbytes5b excludenl /[0-9]\{3}/ contained 
exe s:h . " pbytes5b " . s:bold . s:kbitssec
synt match pbytes4b excludenl /[0-9]\{3}/ contained nextgroup=pbytes5b
exe s:h . " pbytes4b " . s:bold . s:mbitssec
synt match pbytes3b excludenl /[0-9]\{3}/ contained nextgroup=pbytes4b
exe s:h . " pbytes3b " . s:bold . s:gbitssec
synt match pbytes2b excludenl /[0-9]\{3}/ contained nextgroup=pbytes3b
exe s:h . " pbytes2b " . s:bold . s:tbitssec
synt match pbytes1b excludenl /[0-9]\{1}/ contained nextgroup=pbytes2b
exe s:h . " pbytes1b " . s:bold . s:pbitssec

synt region pbytes_reg2 start=/ [0-9]\{14}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=pbytes6b,pbytes7b,pbytes8b,pbytes9b,pbytes10b
synt match pbytes10b excludenl /[0-9]\{3}/ contained 
exe s:h . " pbytes10b " . s:bold . s:kbitssec
synt match pbytes9b excludenl /[0-9]\{3}/ contained nextgroup=pbytes10b
exe s:h . " pbytes9b " . s:bold . s:mbitssec
synt match pbytes8b excludenl /[0-9]\{3}/ contained nextgroup=pbytes9b
exe s:h . " pbytes8b " . s:bold . s:gbitssec
synt match pbytes7b excludenl /[0-9]\{3}/ contained nextgroup=pbytes8b
exe s:h . " pbytes7b " . s:bold . s:tbitssec
synt match pbytes6b excludenl /[0-9]\{2}/ contained nextgroup=pbytes7b
exe s:h . " pbytes6b " . s:bold . s:pbitssec

synt region pbytes_reg3 start=/ [0-9]\{15}/ end=/,\| \|$/re=e-1,me=e-1 oneline keepend contains=pbytes11b,pbytes12b,pbytes13b,pbytes14b,pbytes15b
synt match pbytes15b excludenl /[0-9]\{3}/ contained 
exe s:h . " pbytes15b " . s:bold . s:kbitssec
synt match pbytes14b excludenl /[0-9]\{3}/ contained nextgroup=pbytes15b
exe s:h . " pbytes14b " . s:bold . s:mbitssec
synt match pbytes13b excludenl /[0-9]\{3}/ contained nextgroup=pbytes14b
exe s:h . " pbytes13b " . s:bold . s:gbitssec
synt match pbytes12b excludenl /[0-9]\{3}/ contained nextgroup=pbytes13b
exe s:h . " pbytes12b " . s:bold . s:tbitssec
synt match pbytes11b excludenl /[0-9]\{3}/ contained nextgroup=pbytes12b
exe s:h . " pbytes11b " . s:bold . s:pbitssec


"}}} 1


"}}}

" show interface error conditions {{{
synt match int_errors / [1-9][0-9]* collision[s]\{0,1}/hs=s+1 
synt match int_errors / [1-9][0-9]* runts/hs=s+1 
synt match int_errors / [1-9][0-9]* giants/hs=s+1 
synt match int_errors / [1-9][0-9]* throttles/hs=s+1 
synt match int_errors / [1-9][0-9]* input errors/hs=s+1 
synt match int_errors / [1-9][0-9]* CRC/hs=s+1 
synt match int_errors / [1-9][0-9]* frame/hs=s+1 
synt match int_errors / [1-9][0-9]* overrun/hs=s+1 
synt match int_errors / [1-9][0-9]* ignored/hs=s+1 
synt match int_errors / [1-9][0-9]* watchdog/hs=s+1 
synt match int_errors / [1-9][0-9]* input packets with dribble condition detected/hs=s+1 
synt match int_errors / [1-9][0-9]* input discard/hs=s+1
synt match int_errors / [1-9][0-9]* output discard/hs=s+1
synt match int_errors / [1-9][0-9]* output error[s]\{0,1}/hs=s+1
synt match int_errors / [1-9][0-9]* unknown protocol drops/hs=s+1 
synt match int_errors / [1-9][0-9]* babble[s]\{0,1}/hs=s+1 
synt match int_errors / [1-9][0-9]* late collision/hs=s+1 
synt match int_errors / [1-9][0-9]* deferred/hs=s+1 
synt match int_errors / [1-9][0-9]* lost carrier/hs=s+1 
synt match int_errors / [1-9][0-9]* no carrier/hs=s+1 
synt match int_errors / [1-9][0-9]* no buffer/hs=s+1 
synt match int_errors / [1-9][0-9]* input errors*/hs=s+1 
synt match int_errors / [1-9][0-9]* short frame/hs=s+1 
synt match int_errors / [1-9][0-9]* bad etype drop/hs=s+1 
synt match int_errors / [1-9][0-9]* bad proto drop/hs=s+1 
synt match int_errors / [1-9][0-9]* if down drop/hs=s+1 
synt match int_errors / [1-9][0-9]* input with dribble/hs=s+1 
synt match int_errors / [1-9][0-9]* output buffer failures/hs=s+1 
synt match int_errors / [1-9][0-9]* underrun/hs=s+1 
synt match int_errors / [1-9][0-9]* ignored/hs=s+1 
synt match int_errors / [1-9][0-9]* storm suppression/hs=s+1 
synt match int_errors / [1-9][0-9]* abort/hs=s+1 
synt match int_errors / [eE]rr[Dd]isable[d ]/hs=s+1 
synt match int_errors /Pkts discarded on ingress *: [1-9][0-9]*/hs=s+1 
exe s:h . "int_errors" . s:error

"}}}
" log messages {{{

syntax match timestamp excludenl / \d\d:\d\d:\d\d[ .]/ skipwhite nextgroup=subseconds
exe s:h . "timestamp" . s:parameter2

syntax match subseconds excludenl /\.\d\+/ contained skipwhite 
exe s:h . "subseconds" . s:italic . s:fggray

synt match month / [A-Z][a-z][a-z]/ contained skipwhite nextgroup=day
exe s:h . "month" . s:italic . s:keyword2

synt match day / [0-9][0-9]/ contained
exe s:h . "day" . s:italic . s:keyword3

synt match year /[0-9]\{4}/ contained skipwhite containedin=logtimestamp
exe s:h . "year" . s:italic . s:keyword1

syntax region logtimestamp excludenl start=/\v^[0-9]{4} [A-Z][a-z]{2} [0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}/ end=/ /re=e-9,he=e-1 transparent excludenl contains=timestamp,subseconds,month,year

syntax match ciscoerror excludenl /%[^ ]\{-}:/ skipwhite excludenl
exe s:h . "ciscoerror" . s:bold . s:fgred

"syntax region message excludenl start=/\s \d\d/ end=/.\$/ contains=devicedaystamp,ciscoerror
"exe s:h . "region" . s:fgorange

"syntax match logtimestamp excludenl /\v\d\d:\d\d:\d\d\.+/ contained nextgroup=ciscodevice,subseconds skipwhite
"exe s:h . "match" . s:fgbluegreen

"syntax match logdaystamp /^\u\w\+\s\+\d\+\s/ nextgroup=logtimestamp skipwhite
"exe s:h . "match" . s:fgorange

"syntax match devicetimestamp /\d\d:\d\d:\d\d/ contained keepend
"exe s:h . "match" . s:fgbluegreen

"syntax match devicedaystamp / \u\w\+\s\+\d\+\s / nextgroup=devicetimestamp skipwhite keepend 
"exe s:h . "match" . s:fgorange

"}}}
" Prompts {{{
"syn match config_prompt /^[^ ]\{-1,63}([a-zA-Z\-]*)#/ contained
"exe s:h . "config_prompt" . s:fgwhite . s:bgbrown
"hi config_prompt ctermfg=white ctermbg=darkred guibg=firebrick guifg=white

synt match config_prompt_hostname excludenl  /^[^ ]\{-1,63}(/ contained nextgroup=config_word
exe s:h . "config_prompt_hostname" . s:fgwhite . s:bgbluegreen
"hi config_prompt_hostname ctermfg=white ctermbg=darkred guibg=firebrick guifg=white

synt match config_word excludenl /config/ contained 
exe s:h . "config_word" . s:bold . s:fgblack . s:bgorange
"hi config_word ctermbg=red ctermfg=white guibg=red guifg=white

synt match config_mode excludenl /-[^ )]\{1,32}/ contained 
exe s:h . "config_mode" . s:bold . s:fgblack . s:bgred
"hi config_mode ctermbg=darkyellow ctermfg=white guibg=darkorange guifg=white

synt match config_prompt_end excludenl /)#/me=e-1 contained 
exe s:h . "config_prompt_end" . s:fgwhite . s:bgbluegreen
"hi config_prompt_end ctermfg=white ctermbg=darkred guibg=firebrick guifg=white

synt match hash_prompt excludenl  /^[^ ]\{-1,63}\#/ excludenl
exe s:h . "hash_prompt" . s:fgwhite . s:bgbluegreen
"hi hash_prompt cterm=none ctermfg=white ctermbg=darkblue gui=bold guifg=white guibg=brown
"
synt region config_prompt_reg keepend start=/^[a-zA-Z0-9]\{-1,63}([a-zA-Z\-]\+)/re=e end=/#/me=e-1 transparent contains=config_prompt_hostname,config_word,config_mode,config_prompt_end


"}}}

let b:current_syntax = "cisco"

