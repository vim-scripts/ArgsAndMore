" ArgsAndMore.vim: Apply commands to multiple buffers and manage the argument list.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ArgsAndMore.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.10.005	09-Sep-2012	Add g:ArgsAndMore_AfterCommand hook before
"				buffer switching and use this by default to add
"				a small delay, which allows for aborting an
"				interactive :s///c substitution by pressing
"				CTRL-C twice within the delay. Cp.
"				http://stackoverflow.com/questions/12328007/in-vim-how-to-cancel-argdo
"				Add :Bufdo command for completeness and to get
"				the hook functionality.
"   1.01.004	27-Aug-2012	Do not use <f-args> because of its unescaping
"				behavior.
"   1.00.003	30-Jul-2012	ENH: Implement :CListToArgs et al.
"				ENH: Add :ArgdoErrors and :ArgdoDeleteSuccessful
"				to further analyse and filter the processed
"				arguments.
"	002	29-Jul-2012	Add :ArgsFilter, :ArgsList, :ArgsToQuickfix
"				commands.
"	001	29-Jul-2012	file creation from ingocommands.vim

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_ArgsAndMore') || (v:version < 700)
    finish
endif
let g:loaded_ArgsAndMore = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:ArgsAndMore_AfterCommand')
    let g:ArgsAndMore_AfterCommand = 'sleep 100m'
endif


"- commands --------------------------------------------------------------------

" Note: No -bar for the :...do commands; they can take a sequence of Vim
" commands.

command! -nargs=1 -complete=command Bufdo    call ArgsAndMore#Bufdo(<q-args>)
command! -nargs=1 -complete=command Windo    call ArgsAndMore#Windo(<q-args>)
command! -nargs=1 -complete=command Winbufdo call ArgsAndMore#Winbufdo(<q-args>)
command! -nargs=1 -complete=command Tabdo    call ArgsAndMore#Tabdo(<q-args>)
command! -nargs=1 -complete=command Tabwindo call ArgsAndMore#Tabwindo(<q-args>)


" Note: No -bar; can take a sequence of Vim commands.
" Note: Cannot use -range and <line1>, <line2>, because in them, identifiers
" like ".+1" and "$" are translated into buffer line numbers, and we need
" argument indices! Instead, use -count=0 as a marker, and extract the original
" range from the command history. (This means that we can only use the command
" interactively, not in a script.)
command! -count=0 -nargs=1 -complete=command Argdo call ArgsAndMore#ArgdoWrapper(<count>, <q-args>)
command! -bar ArgdoErrors call ArgsAndMore#ArgdoErrors()
command! -bar ArgdoDeleteSuccessful call ArgsAndMore#ArgdoDeleteSuccessful()


command! -nargs=1 -complete=expression ArgsFilter call ArgsAndMore#ArgsFilter(<q-args>)

command! -bang -nargs=+ -complete=file ArgsNegated call ArgsAndMore#ArgsNegated('<bang>', <q-args>)

" Note: Must use * instead of ?; otherwise (due to -complete=file), Vim
" complains about globs with "E77: Too many file names".
command! -bar -bang -nargs=* -complete=file ArgsList call ArgsAndMore#ArgsList(<bang>0, <q-args>)

command! -bar ArgsToQuickfix call ArgsAndMore#ArgsToQuickfix()

command! -bar -bang  CListToArgs    call ArgsAndMore#QuickfixToArgs(getqflist(), 0, 0, '<bang>')
command! -bar -count CListToArgsAdd call ArgsAndMore#QuickfixToArgs(getqflist(), 1, <count>, '')
command! -bar -bang  LListToArgs    call ArgsAndMore#QuickfixToArgs(getloclist(0), 0, 0, '<bang>')
command! -bar -count LListToArgsAdd call ArgsAndMore#QuickfixToArgs(getloclist(0), 1, <count>, '')

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
