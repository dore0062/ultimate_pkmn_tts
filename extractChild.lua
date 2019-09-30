function extractChild(element, children) -- Credit to dzikakulka. Extracts children/components easily. Modified by Skeeveo
  for _, name in ipairs(children) do
    if element.getChild(name) == nil then
      log("Child does not exist: " .. name)
      log("Available children:")
      for x, _ in pairs(element.getChildren()) do
        log(x)
      end
    end
    element = element.getChild(name)
  end
  return element
end
