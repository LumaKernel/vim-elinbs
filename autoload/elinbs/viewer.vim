let s:ANSI = vital#elinbs#import('Vim.Buffer.ANSI')

let s:viewer = {}

function! elinbs#viewer#new(session) abort
  let self = deepcopy(s:viewer)
  let self.session = a:session
  return self
endfunction

function! s:viewer.view(content) abort
  if !g:elinbs#buffer#exists(self.session.id)
    return
  endif
  normal! m`
  let content = g:elinbs#content#new(a:ontent)
  call setbufline(self.bufnr, 1, content.body)

  let save_hidden = &hidden
  exe self.bufnr . 'buffer'
  call ANSI.define_syntax()
  
  " TODO : search IDs

  exe "normal! ``"
  let &hidden = save_hidden
endfunction


function! elinbs#viewer#transform(raw_html) abort
  let html = s:HTML.parse(a:raw_html)

  let els_having_id = obj.findAll({el -> has_key(el.attr, 'id')})

  for el in els_having_id
    let el.child = ['#<' .. el.id .. '>#'] + id.child
  endfor

  return html.to_string()
endfunction

