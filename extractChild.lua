function extractChild(element, children) -- Credit to dzikakulka. Extracts children/components easily
  logStyle("error", "Red")
  for _, name in ipairs(children) do
    if element.getChild(name) == nil then
      log("Child does not exist: " .. name, " ", "error")
      log(element.getChildren(), "Children available:", "error")
      log(children, "Children selected:", "error")
      if element.getName() then
        error("Child does not exist in object '".. element.getName() .. "' (".. element.getGUID().. ")")
      else
        error("Child does not exist in given object (".. element.getGUID()..")")
      end
    end
    element = element.getChild(name)
  end
  return element
end
