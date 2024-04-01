-- this is wrapper to convert dot graph to ascii art using pipx and a gist
-- https://gist.githubusercontent.com/mmngreco/2d3bc321405b1991277fd6001060df0d/raw/dot2ascii.py
local function dot2ascii(opts)
    local range = ''
    if opts.range ~= 0 then
        range = string.format("%s,%s", opts.line1, opts.line2)
    end
    vim.cmd(string.format(":%s!pipx run https://gist.githubusercontent.com/mmngreco/2d3bc321405b1991277fd6001060df0d/raw/dot2ascii.py", range))
end
vim.api.nvim_create_user_command('Dot2Ascii', dot2ascii, { range = true, nargs = 0 })

return {}
