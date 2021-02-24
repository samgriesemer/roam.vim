" A simple wiki plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! wiki#link#word#matcher() abort " {{{1
  return deepcopy(s:matcher)
endfunction

" }}}1
function! wiki#link#word#template(_url, text) abort dict " {{{1
  " This template returns a wiki template for the provided word(s). It does
  " a smart search for likely candidates and if there is no unique match, it
  " asks for target link.

  " Allow map from text -> url (without extension)
  if g:wiki_link_conceal && !empty(g:wiki_map_text_to_link) && exists('*' . g:wiki_map_text_to_link)
    let l:url_target = call(g:wiki_map_text_to_link, [a:text])
  else
    let l:url_target = a:text
  endif

  " Append extension if wanted
  let l:url_root = l:url_target
  if !empty(b:wiki.link_extension)
    let l:url_target .= b:wiki.link_extension
    let l:url_actual = l:url_target
  else
    let l:url_actual = l:url_target . '.' . b:wiki.extension
  endif


  " First try local page
  if filereadable(printf('%s/%s', expand('%:p:h'), l:url_actual))
    return wiki#link#template(l:url_target, a:text)
  endif

  " Next try at wiki root
  if filereadable(printf('%s/%s', b:wiki.root, l:url_actual))
    return wiki#link#template('/' . l:url_target, a:text)
  endif

  " Finally we see if there are completable candidates
  let l:candidates = map(
        \ glob(printf(
        \     '%s/%s*.%s', b:wiki.root, l:url_root, b:wiki.extension), 0, 1),
        \ 'fnamemodify(v:val, '':t:r'')')

  " Solve trivial cases first
  if len(l:candidates) == 0
    return wiki#link#template(
          \ (b:wiki.in_journal ? '/' : '') . l:url_target, a:text)
  elseif len(l:candidates) == 1
    return wiki#link#template('/' . l:candidates[0], '')
  endif

  " Select with menu
  let l:choice = wiki#ui#choose(l:candidates + ['New page at wiki root'])
  redraw!
  return empty(l:choice) ? l:url_target : (
        \ l:choice ==# 'New page at wiki root'
        \   ? wiki#link#template(l:url_target, a:text)
        \   : wiki#link#template('/' . l:choice, ''))
endfunction

" }}}1

let s:matcher = {
      \ 'type' : 'word',
      \ 'toggle' : function('wiki#link#word#template'),
      \ 'rx' : wiki#rx#word,
      \}

function! s:matcher.parse(link) abort dict " {{{1
  let a:link.scheme = ''
  let a:link.text = a:link.full
  let a:link.url = 'N/A'
  return a:link
endfunction

" }}}1
