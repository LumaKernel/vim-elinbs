" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_elinbs#Options#Object#import() abort', printf("return map({'unset': '', 'format': '', 'set': '', 'is_available': '', 'get': '', 'name': ''}, \"vital#_elinbs#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___

function! s:unset(options, scope, name) abort
  let scope_dicts = {'g': g:, 't': t:, 'w': w:, 'b': b:}
  let scope_dicts[a:scope][a:options.namespace] = get(scope_dicts[a:scope], a:options.namespace, {})
  silent! unlet scope_dicts[a:scope][a:options.namespace][a:name]
endfunction

function! s:set(options, scope, name, value) abort
  let scope_dicts = {'g': g:, 't': t:, 'w': w:, 'b': b:}
  let scope_dicts[a:scope][a:options.namespace] = get(scope_dicts[a:scope], a:options.namespace, {})
  let scope_dicts[a:scope][a:options.namespace][a:name] = a:value
endfunction

function! s:get(options, scope, name) abort
  let scope_dicts = {'g': g:, 't': t:, 'w': w:, 'b': b:}
  let scope_dicts[a:scope][a:options.namespace] = get(scope_dicts[a:scope], a:options.namespace, {})
  return scope_dicts[a:scope][a:options.namespace][a:name]
endfunction

function! s:is_available(options, scope, name) abort
  let scope_dicts = {'g': g:, 't': t:, 'w': w:, 'b': b:}
  if !has_key(scope_dicts[a:scope], a:options.namespace) | return 0 | endif
  if !has_key(scope_dicts[a:scope][a:options.namespace], a:name) | return 0 | endif
  return 1
endfunction

function! s:name(options, name) abort
  return a:options.namespace . '.' . a:name
endfunction

function! s:format(options, scopes, name) abort
  let scope_dicts = {'g': g:, 't': t:, 'w': w:, 'b': b:}
  if len(a:scopes) == 1
    return a:scopes[0] . ':' . a:options.namespace . '.' . a:name
  else
    return '[' . join(a:scopes, ',') . ']:' . a:options.namespace . '.' . a:name
  endif
endfunction

