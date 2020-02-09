
let s:HTML = vital#elinbs#import('Web.HTML')
let s:Promise = vital#elinbs#import('Async.Promise')
let s:J = vital#elinbs#import('JobShims.Vim')
let s:ANSI = vital#elinbs#import('Vim.Buffer.ANSI')
let s:URI = vital#elinbs#import('Web.URI')
let s:HTML = vital#elinbs#import('Web.HTML')
let s:pc = function('g:elinbs#util#promise_catcher')

let elinbs#debug = get(g:, 'elinbs#debug')

function! elinbs#open(url) abort
  let url = elinbs#util#normalize_URL(a:url)
  let id = elinbs#buffer#make('new', url)
  setlocal nowrap
  setlocal buftype=nofile
  call elinbs#runner#html(url)
        \.then(function('g:elinbs#viewer#transform'))
        \.then(function('g:elinbs#runner#dump'))
        \.then(g:elinbs#viewer#new(id).view)
        \.catch(s:pc)
endfunction

