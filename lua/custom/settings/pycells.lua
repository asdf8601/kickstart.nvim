vim.g.custom_fold_enabled = false

function FoldExpression()
    local line = vim.fn.getline(vim.v.lnum)
    -- Delimitamos el comienzo de un pliegue en `# %%` o cualquier línea con una explicación
    if vim.v.lnum == 1 then
      return '0'
    elseif line:match('^# %%') then
        return ">1"
    else
        return "="
    end
end


function ToggleCustomFolding()
    if vim.g.custom_fold_enabled then
        -- Restauramos el plegado original (modalidad estándar)
        vim.wo.foldmethod = 'manual'
        vim.wo.foldexpr = ''
    else
        -- Activamos el plegado personalizado
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.FoldExpression()'
    end
    vim.g.custom_fold_enabled = not vim.g.custom_fold_enabled
end

-- Crea un comando de Neovim
vim.api.nvim_command('command! ToggleFolding lua ToggleCustomFolding()')

return {}
