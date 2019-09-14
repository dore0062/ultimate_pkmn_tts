function extractChild(element, children) -- Credit to dzikakulka. Extracts children/components easily
  for _, name in ipairs(children) do
    element = element.getChild(name)
  end
  return element
end

function setImage(index)
  local sheet = extractChild(self, {'playerpanel Variant(Clone)', 'panels', 'Left', 'balls', '1', 'Panel', 'Image'}).getComponent("RectTransform")
  pos = sheet.get("localPosition")

  pos["y"] = 4.5

  for i = 1, index, 1 do
    pos.x = pos.x - 4.3925
    if pos.x < -267 then
      pos.y = pos.y + 5
      pos.x = -3.958000
    end
  end

  sheet.set("localPosition", pos)
end
