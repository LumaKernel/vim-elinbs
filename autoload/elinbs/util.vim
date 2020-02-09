let s:URI = vital#elinbs#import('Web.URI')

function! elinbs#util#normalize_URL(url) abort
  let url = a:url
  let url = substitute(url, '^\_s\+', '', 'g')
  let url = substitute(url, '\_s\+$', '', 'g')

  let url = s:URI.new(url)
  let query = url.query()
  let queries = split(query, '&')
  " TODO
  " let queries = sort(queries)
  return url.to_string()
endfunction

function! elinbs#util#promise_catcher(ex) abort
  echom ex
  if has_key(ex, 'throwpoint')
    let pat = '\C^\(.*\), \(line \d\+\)$'
    let throwpoint = ex.throwpoint
    let line = v:null
    if throwpoint ==# pat
      let groups = matchlist(ex.throwpoint, pat)
      let throwpoint = groups[1]
      let line = groups[2]
    endif
    call execute("echom 'Error detected while processing ' . throwpoint", '')
    if line isnot v:null
      echom line
    endif
  endif
  if has_key(ex, 'exception')
    call execute('echom "<Promise> " . ex.exception', '')
  endif
endfunction

