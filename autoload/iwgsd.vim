" iwgsd.vim - I Will Get Shit Done!
" Eric Davis <https://github.com/insanum>

if exists('g:loaded_iwgsd') || &cp
    finish
endif
let g:loaded_iwgsd = 1

function! s:is_enabled()
    if !exists('w:iwgsd_enabled')
        return 0
    endif
    return w:iwgsd_enabled ? 1 : 0
endfunction

function! iwgsd#enable()
    if s:is_enabled()
        return
    endif

    " match into any kind of markdown list item
    let l:ml = '\v%(^\s*%([-*+]|\d+.)%(\s+[\[ x\]])?\s+.*)@<='

    " match the beginning of a markdown list task item (before brackets)
    let l:mlt = '\v%(^\s*[-*+]\s+'

    " ensure a preceding space
    let l:ms = '\s@1<='

    " match notification string
    let l:nd = '[-+]?' " notify prefix flags
    let l:nt = '.+'    " notify datetime text (based on later.js)

    " match end being a space or eol
    let l:me = '%(\s|$)'

    " note that order matters allowing matches on top of matches...
    let l:matches = [
    \   [ 'IWGSD_Todo',         l:ml.l:ms.'\zs%(TODO|XXX)\ze'.l:me ],
    \   [ 'IWGSD_Tag',          l:ml.l:ms.'\zs#%(\w+)\ze'.l:me ],
    \   [ 'IWGSD_Location',     l:ml.l:ms.'\zs\@%(\w+)\ze'.l:me ],
    \   [ 'IWGSD_Notification', l:ml.l:ms.'\zs\{'.l:nd.'\s+'.l:nt.'}\ze'.l:me ],
    \   [ 'IWGSD_Task',         l:mlt.')\zs\[[ x]\]\ze\s+' ],
    \   [ 'IWGSD_TaskDone',     l:mlt.'\[)\zsx\ze\]\s+' ],
    \   [ 'IWGSD_TaskDoneText', l:mlt.'\[x\]\s+)\zs.+\ze$' ],
    \ ]

    let w:iwgsd_matches = [ ]
    for l:m in l:matches
        call add(w:iwgsd_matches, matchadd(l:m[0], l:m[1]))
    endfor

    let w:iwgsd_enabled = 1
endfunction

function! iwgsd#disable()
    if !s:is_enabled()
        return
    endif

    for l:m_id in w:iwgsd_matches
        call matchdelete(l:m_id)
    endfor
    unlet w:iwgsd_matches

    unlet w:iwgsd_enabled
endfunction

function! iwgsd#toggle()
    if s:is_enabled()
        echo 'bar'
        call iwgsd#disable()
    else
        echo 'foo'
        call iwgsd#enable()
    endif
endfunction

function! s:fzf_exists()
    if !exists('*fzf#complete')
		echohl WarningMsg
        echo 'fzf.vim not installed'
        echohl None
        return 0
    endif
    return 1
endfunction

function! iwgsd#find_tag(bang, tag)
    if !s:fzf_exists()
        return
    endif
    let l:opts = { 'options': '--preview-window=right:0' }
    if a:bang
        " search current buffer for the tag
        call fzf#vim#buffer_lines('\s#'.a:tag.'(\s|$)', l:opts)
    else
        " search all files in current directory for the tag
        call fzf#vim#ag('\s#'.a:tag.'(\s|$)', l:opts)
    endif
endfunction

function! iwgsd#list_tags(bang)
    if !s:fzf_exists()
        return
    endif
    let l:opts = { 'options': '--preview-window=right:0' }
    if a:bang
        " search current buffer for tag names
        call fzf#vim#buffer_lines('\v\s#\w+(\s|$)', l:opts)
    else
        " search all files in current directory for tag names
        call fzf#vim#ag('\s#\w+(\s|$)', l:opts)
    endif
endfunction

