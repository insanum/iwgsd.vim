" iwgsd.vim - I Will Get Shit Done!
" Eric Davis <https://github.com/insanum>

hi default IWGSD_Todo         ctermfg=225 ctermbg=57 cterm=bold
hi default IWGSD_Tag          ctermfg=45  ctermbg=21 cterm=bold
hi default IWGSD_Location     ctermfg=190
hi default IWGSD_Notification ctermfg=141
hi default IWGSD_Task         ctermfg=240            cterm=bold,italic
hi default IWGSD_TaskDone     ctermfg=124            cterm=bold,italic
hi default IWGSD_TaskDoneText ctermfg=244            cterm=italic

command! -bar IWGSDEnable  call iwgsd#enable()
command! -bar IWGSDDisable call iwgsd#disable()
command! -bar IWGSDToggle  call iwgsd#toggle()

command! -nargs=1 -bang -bar FindTag call iwgsd#find_tag(<bang>0, <f-args>)
command! -bang -bar ListTags call iwgsd#list_tags(<bang>0)

inoremap xxn <C-R>=IWGSDNotifications()<CR>
function! IWGSDNotifications()
    call complete(col('.'),
        \ [
        \   "{+ at <T>}",
        \   "{+ at <T> of <D> day of <M>}",
        \   "{+ at <T> on <WD>}",
        \   "{+ at <T> every weekend}",
        \   "{+ at <T> before <D> day of <M>}",
        \   "{+ at <T> on the first day of the month}",
        \   "{+ at <T> on the last day of the month}",
        \   "{+ at <T> every <N> <P> starting on the <D> day of <M>}",
        \ ])
    return ''
endfunction

command! -bar IWGSDDeleteNotification s/\v\{[-+]?\s+.+}//g
command! -bar IWGSDDeleteTags         s/\v\s@1<=#\w+%(\s|$)//g
command! -bar IWGSDDeleteLocation     s/\v\s@1<=\@\w+%(\s|$)//g
command! -bar IWGSDDeleteTodo         s/\v\s@1<=%(TODO|XXX)%(\s|$)//g

