local vars = {}

-- function get_vars(meta)
--   for k, v in pairs(meta) do
--     val = v
--     if type(val) ~= "string" then
--       val = table.unpack(val).text
--     end
--     vars["{{" .. k .. "}}"] = val
--   end
-- end

function replace(el)
  if el.title == "wikilink" then
     el.target = string.lower(el.target) .. ".html"
     el.title = ""
  end
  return el
end

function Inline(el)
  el = replace(el)
  return pandoc.walk_inline(el)
end

-- function Block(el)
--   el = replace(el)
--   return pandoc.walk_block(el)
-- end

return {
  {Meta = get_vars},
  {Inline = Inline}
}
