function onLoad()
  -- self.interactable = false
end

function extractChild(element, children) -- Credit to dzikakulka. Extracts children/components easily
  for _, name in ipairs(children) do
    element = element.getChild(name)
  end
  return element
end

function setReady(player)
  local p = string.match(player, "%d+")

  sheet = extractChild(self, {'control_panel Variant 2(Clone)', 'control_panel', 'Panel', 'bottom_bar', 'Check' .. p, "1"}).getComponent("RectTransform")
  local pos = sheet.get("localPosition")
  pos["x"] = pos["x"] - 10.5
  sheet.set("localPosition", pos)
  self.AssetBundle.playTriggerEffect(3)
end

function unReady(player)
  local p = string.match(player, "%d+")

  sheet = extractChild(self, {'control_panel Variant 2(Clone)', 'control_panel', 'Panel', 'bottom_bar', 'Check' .. p, "1"}).getComponent("RectTransform")
  local pos = sheet.get("localPosition")
  pos["x"] = pos["x"] + 10.5
  sheet.set("localPosition", pos)
  self.AssetBundle.playTriggerEffect(0)
end
