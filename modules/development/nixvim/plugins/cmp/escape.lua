cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.abort()
  else
    fallback()
  end
end, { "i" })
