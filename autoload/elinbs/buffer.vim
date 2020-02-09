
let s:Random = vital#elinbs#import('Random')

let s:scheme = 'elinbs'
let s:valid_pre = ['rightbottom', 'lefttop', 'rightbelow', 'leftabove']
let s:valid_openers = ['edit', 'new', 'vnew', 'tabnew']

function! s:open(opener)
  let opener = a:opener
  let opener = substitute(opener, '\_s\+', ' ', 'g')
  let opener = substitute(opener, '^\_s\+', '', '')
  let opener = substitute(opener, '\_s\+$', '', '')
  if index(s:valid_openers, opener) != -1
    exe opener
    return
  endif

  let opns = split(opener, ' ')
  if len(opns) == 2
        \ && index(s:valid_pre, opns[0]) != -1
        \ && index(s:valid_openers, opns[1]) != -1
    exe opener
    return
  endif
  new
endfunction


function! elinbs#buffer#make(opener, path) abort
  let id = abs(s:Random.next())
  call s:open(a:opener)
  let name = s:scheme .. '://' .. id .. '/'
  exe 'file ' .. name
  return {'bufname': name, 'scheme': s:scheme, 'id': id, 'path': ''}
endfunction


function! elinbs#buffer#exists(id) abort
  return len(elinbs#buffer#get_all(id)) > 0
endfunction


" elinbs#buffer#get_all() : Get all buffers
" elinbs#buffer#get_all(id) : Get all which id is `id`
function! elinbs#buffer#get_all(...) abort
  let buffers = filter(range(1, bufnr('$')), 'bufexists(v:val)')
  let res = []
  for bufnr in buffers
    let pattern = '^' .. s:scheme .. ':\/\/\(\w\+\)\/\(.*\)'
    let name = bufname(bufnr)
    if name =~# pattern
      let groups = matchlist(name, pattern)
      if !a:0 || a:1 ==# a:id:
        call add(res, {'bufname': name, 'scheme': s:scheme, 'id': groups[1], 'path': groups[2]})
      endif
    endif
  endfor
  return res
endfunction

