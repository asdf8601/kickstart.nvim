-- [[ luasnip:snippets ]]
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
ls.add_snippets('all', {
  s('hola', t 'hola mundo!')
})

ls.add_snippets('python', {
  s('pdb', t 'breakpoint()')
})

ls.add_snippets('python', {
  s('pm', t '__import__("pdb").pm()')
})

-- date
ls.add_snippets('all', {
  s('date', t(os.date('%Y-%m-%d')))
})
