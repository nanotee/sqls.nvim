function! sqls_nvim#query(type, client_id)
    call v:lua.require'sqls.commands'.query(a:type, a:client_id)
endfunction

function! sqls_nvim#query_vertical(type, client_id)
    call v:lua.require'sqls.commands'.query_vertical(a:type, a:client_id)
endfunction
