function! s:IsEmptyLayouts()
  return empty(g:keyboard_layouts)
endfunction

function! s:warn(words)
  echohl WarningMsg | echo a:words | echohl None
endfunction

function! s:SourceLayout(layout_path)
  let l:cmd = 'source ' . a:layout_path
  execute(l:cmd)
endfunction

function! s:UpdateKeyMappings(layout)
  if type(a:layout)!=v:t_string
    return
  endif
  if s:IsEmptyLayouts()
    return
  endif
  if index(g:keyboard_layouts,a:layout) >= 0
    let g:keyboard_current_layout = a:layout
    let g:keyboard_current_layout_keymappings = get(g:keyboard_layout_paths, a:layout, '')
    if strlen(g:keyboard_current_layout_keymappings) == 0
      return
    endif
    "exec "mapclear"
    call s:SourceLayout(g:keyboard_current_layout_keymappings)
    return
  endif
  call s:warn("keymapping not found")
endfunction

function! keyboard#init()
  if get(g:,'loaded_keyboard_vim',0) == 1
    call s:UpdateKeyMappings(g:keyboard_current_layout)
  endif
endfunction

function! keyboard#actions(...) abort
  if a:0 > 0
    if type(a:1) == v:t_string
      call s:set_layout(a:1)
    endif
    return
  endif
  call s:show_current()
endfunction

function! s:set_layout(layout)
  call s:UpdateKeyMappings(a:layout)
endfunction

function! s:show_current()
  echo g:keyboard_current_layout
endfunction

function! keyboard#prompt_swtich()
  if s:IsEmptyLayouts()
    call s:warn("No available Layout")
    return
  endif
  let l:layout=s:PromptForLayoutName()
  call s:UpdateKeyMappings(l:layout)
endfunction

" select between available layouts
" Please Enter the number your choose
function! s:PromptForLayoutName()
  let l:lines=copy(g:keyboard_layouts)
  for i in range(len(g:keyboard_layouts))
    let l:lines[i] = ' ' . (i + 1) . '. ' . l:lines[i]
  endfor
  redraw
  sleep 50 m
  echo "\nCurrent Layout is " . g:keyboard_current_layout . "\nPlease select the layout to use:"
  sleep 50 m
  let l:idx = inputlist([''] + l:lines + [''])
  if l:idx >= 1 && l:idx <= len(g:keyboard_layouts)
    return g:keyboard_layouts[l:idx - 1]
  endif
  return ''
endfunction

" vim:ft=vim foldmethod=marker sw=2
