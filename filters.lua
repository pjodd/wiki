
function has (items, item)
  for _,v in pairs(items) do
    if v == item then
      return true
    end
  end
  return false
end

return {
  {
    -- open external links in new tab/window
    Link = function (el)
      if has(el.classes, "uri") then
        el.attr.attributes.target = "_blank"
        el.attr.attributes.rel = "noopener"
      end
      return el
    end,
  }
}
