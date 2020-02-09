
let s:O = vital#elinbs#import('Options').new('elinbs', {'provider': '#'})

func! elinbs#options#set(...)
  call call(s:O.user_set, a:000)
endfunc
func! elinbs#options#get(...)
  return call(s:O.user_get, a:000)
endfunc

call s:O.define('elinks', {
      \   'default': 'elinks',
      \   'type': 'string',
      \   'doc': [ 'Executable path or command to elinks.' ],
      \ })
call s:O.define('before', {
      \   'default': [],
      \   'type': 'list',
      \   'doc': [ 'Options to be added right after the command.' ],
      \ })
call s:O.define('after', {
      \   'default': [],
      \   'type': 'list',
      \   'doc': [ 'Options to be added after the default command options.' ],
      \ })

function! elinbs#options#load()
endfunction

