
let s:Promise = vital#elinbs#import('Async.Promise')
let s:Cache = vital#elinbs#import('System.Cache')
let s:cache = s:Cache.new('file', { 'cache_dir': elinbs#debug ? './.dev/cache' : '~/.cache/elinbs' })
let s:pc = function('g:elinbs#util#promise_catcher')

call g:elinbs#options#load()

function! s:get_executable() abort
  if executable(g:elinbs#options#get('elinks'))
    return g:elinbs#options#get('elinks')
  endif
  if executable('elinks') | return 'elinks' | endif
  return 0
endfunction

function! elinbs#runner#html(url) abort
  let url = g:elinbs#util#normalize_URL(a:url)
  let cmd = s:get_executable()
  let cmds = [cmd]
        \ + g:elinbs#options#get('before')
        \ + ['-source', url]
        \ + g:elinbs#options#get('after')
  if s:cache.has(url)
    return s:Promise.resolve(s:cache.get(url))
          \.catch(s:pc)
  endif
  return g:elinbs#runner#collect(cmds)
        \.then({data -> [s:cache.set(url, data), data][-1]})
        \.catch(s:pc)
endfunction

function! elinbs#runner#dump(raw_html) abort
  let cmd = s:get_executable()
  let cmds = [cmd]
        \ + g:elinbs#options#get('before')
        \ + ['-dump', '-dump-color-mode', '1', raw_html]
        \ + g:elinbs#options#get('after')
  if g:elinbs#cache#cached(url)
    return g:elinbs#cache#cache_get(url)
  endif
  return g:elinbs#runner#collect(cmds)
endfunction

function! elinbs#runner#collect(cmds) abort
  let o = {}
  function! o.ret(resolve, reject) abort closure
    let opt = {}
    let data = []
    let err = []
    function! opt.out_cb(datum) abort closure
      call add(data, a:datum)
    endfunction
    function! opt.err_cb(datum) abort closure
      call add(err, a:datum)
    endfunction
    function! opt.exit_cb(status) abort closure
      if status
        call reject([err, status])
      else
        call resolve(data)
      endif
    endfunction
    let opt.err_cb = opt.out_cb

    let job = s:J.job_start(a:cmds, opt)
  endfunction

  return s:Promise.new(o.ret)
endfunction

