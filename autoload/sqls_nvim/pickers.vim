function! sqls_nvim#pickers#fzf(choices, callback) abort
    if !exists('g:loaded_fzf') | echoerr 'The fzf.vim plugin must be installed' | return | endif

    call fzf#run(fzf#wrap('sqls', {
                \ 'source': a:choices,
                \ 'sink': a:callback,
                \ 'options': ['--prompt=sqls.nvim>'],
                \ }))
endfunction
