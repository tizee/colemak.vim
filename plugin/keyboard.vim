scriptencoding utf-8

if exists('loaded_keyboard_vim')
  finish
endif
let g:loaded_keyboard_vim = 1

" options
let g:keyboard_default_layout=get(g:,'keyboard_default_layout','')
let g:keyboard_current_layout=g:keyboard_default_layout
let g:keyboard_layout_paths=get(g:,'keyboard_layout_paths',{})
let g:keyboard_layouts=sort(keys(g:keyboard_layout_paths))
if !empty(g:keyboard_layouts)
  let g:keyboard_current_layout_keymappings=get(g:keyboard_layout_paths,g:keyboard_current_layout,'')
endif
let g:keyboard_autoresource=get(g:,'keyboard_autoresource',1)

function! s:SourceKeyMappings(filepath)
  if empty(a:filepath) || !filereadable(a:filepath)
    return
  endif
  if index(values(g:keyboard_layout_paths),a:filepath) >= 0 && g:keyboard_current_layout_keymappings == a:filepath
    echom 're-source '  . a:filepath
    let l:cmd = 'source ' . a:filepath
    execute(l:cmd)
  endif
endfunction

" auto-source keymappings when changed
augroup keyboard
  autocmd!
  if g:keyboard_autoresource == 1
    autocmd BufWritePost *.vim call s:SourceKeyMappings(expand('<amatch>:p'))
  endif
augroup END

nnoremap <unique> <expr> <Plug>KeyboardSwitch keyboard#prompt_swtich()

function! s:names(...)
  return sort(keys(g:keyboard_layout_paths))
endfunction

" commands
if !exists(":Keyboard")
  command! -nargs=0 -bang KeyboardSwitch call keyboard#prompt_swtich()
  command! -nargs=* -bang -complete=customlist,s:names Keyboard call keyboard#actions(<f-args>)
endif 

call keyboard#init()
