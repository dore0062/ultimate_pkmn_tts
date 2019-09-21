--------------------------------------------------------------------------
--------------------------------------------------------------------------
---                                 .::.                               ---
---                               .;:**'            AMC                ---
---                               `                  0                 ---
---   .:XHHHHk.              db.   .;;.     dH  MX   0                 ---
--- oMMMMMMMMMMM       ~MM  dMMP :MMMMMR   MMM  MR      ~MRMN          ---
--- QMMMMMb  "MMX       MMMMMMP !MX' :M~   MMM MMM  .oo. XMMM 'MMM     ---
---   `MMMM.  )M> :X!Hk. MMMM   XMM.o"  .  MMMMMMM X?XMMM MMM>!MMP     ---
---    'MMMb.dM! XM M'?M MMMMMX.`MMMMMMMM~ MM MMM XM `" MX MMXXMM      ---
---     ~MMMMM~ XMM. .XM XM`"MMMb.~*?**~ .MMX M t MMbooMM XMMMMMP      ---
---      ?MMM>  YMMMMMM! MM   `?MMRb.    `"""   !L"MMMMM XM IMMM       ---
---       MMMX   "MMMM"  MM       ~%:           !Mh.""" dMI IMMP       ---
---       'MMM.                                             IMX        ---
---        ~M!M                                             IMP        ---
---                        MASTER TRAINER GALAXY                       ---
---                         BATTLE ARENA MODULE                        ---
--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- Log only on function calling
-- Originally created by Skeeveo


function onLoad()
  p1_assetbundles = {
    slot1 = {door = getObjectFromGUID("873913"), zone = getObjectFromGUID("9eba00")},
    slot2 = {door = getObjectFromGUID("d7718d"), zone = getObjectFromGUID("4a24d7")},
    control_panel = getObjectFromGUID("398c62")
  }

  p2_assetbundles = {
    slot1 = {door = getObjectFromGUID("c4f4f4"), zone = getObjectFromGUID("faf184")},
    slot2 = {door = getObjectFromGUID("db389d"), zone = getObjectFromGUID("baccac")},
    control_panel = getObjectFromGUID("adcca1")
  }
  db_module = getObjectFromGUID("28b051")
  control_panel = getObjectFromGUID("eb763b")

  -- Uninteractables
  self.interactable = false
  for x, b in pairs(p1_assetbundles) do
    if type(b) == "table" then
      b.door.interactable = false
    end
  end
  for x, b in pairs(p2_assetbundles) do
    if type(b) == "table" then
      b.door.interactable = false
    end
  end


  -- Debug instastart (delete)
  readyUp(_, _, "p1")
  readyUp(_, _, "p2")
  start()
end

-------------------------------
---------- OPTIONS
-------------------------------
options = {
  party_size = 2 -- Total party size. Must be equal to the total number of valid slots
}

-------------------------------
---------- GLOBAL VARIABLES
-------------------------------
CURRENT_STATE = "IDLE" -- Current state of the arena for onLoad/onSave
PLAYER1_READY = false
PLAYER2_READY = false
p1_SWAP_SELECT = false
p2_SWAP_SELECT = false
p1_SWAP_ID = 1
p2_SWAP_ID = 1

-------------------------------
---------- UTILITY
-------------------------------
function extractChild(element, children) -- Credit to dzikakulka. Extracts children/components easily
  for _, name in ipairs(children) do
    element = element.getChild(name)
  end
  return element
end

-------------------------------
---------- START/READYUP
-------------------------------
function slotDetection(p, slot_num) -- Detects Pokeball in the selected slot.
  -- P = player
  --!--
  assert(type(p) == "string", "Arena slotDetection: variable 'p' is not a string")
  assert(type(slot_num) == "number", "Arena slotDetection: variable 'slot_num' is not a number")
  if slot_num > options.party_size or slot_num < 1 then error ("Arena slotDetection: variable 'slot_num' must not be greater then ".. options.party_size .." or less than or equal to 0") end
  --!--
  pokeball_found = false
  --.--

  -- Find Pokeball
  local slot = _G[p .. "_assetbundles"]["slot" .. slot_num]
  local zone_objs = slot.zone.getObjects()

  local door = slot.door

  for x, y in pairs(zone_objs) do
    if y.getName() == "Pokeball" then
      pokeball_found = true
      pokeball = y
    else
      return nil
    end
  end

  if pokeball_found == false then return nil end

  -- Play animations
  pokeball.interactable = false
  pokeball.addForce({5, 5, 5}, 1) -- Adds force to activate physics.
  Wait.time(|| pokeball.setLock(true), 1)
  Wait.time(|| pokeball.setPosition({0, 0, 0}), 1)
  door.AssetBundle.playLoopingEffect(1)
  Wait.time(function() door.AssetBundle.playLoopingEffect(2) end, 1)
  return pokeball
end


function readyUp(_, _, p) -- Ready up for player
  --!--
  assert(type(p) == "string", "Arena readyUp: variable 'p' is not a string. You may need to set XML ID's.")
  --!--
  local pokemon = {}
  --.--

  local p_ready = _G["PLAYER".. string.match(p, "%d+") .."_READY"]
  local player_control_panel = _G[p .."_assetbundles"]["control_panel"]

  if p_ready == false then
    for i = 1, options.party_size, 1 do -- Do all slot detections
      table.insert(pokemon, slotDetection(p, i))
    end

    if pokemon[1] then
      _G[p.."_pokemon"] = pokemon -- Add to loaded Pokemon

      for x, d in ipairs(pokemon) do
        local params = {d, x}
        Wait.time(|| player_control_panel.call("setImage", params), 0.5)
      end

      log("arena." .. self.getGUID() .. " control_panel setReady")
      _G["PLAYER".. string.match(p, "%d+") .."_READY"] = true

      control_panel.call("setReady", p)
    end
  else
    log("arena." .. self.getGUID() .. " control_panel unReady")
    _G["PLAYER".. string.match(p, "%d+") .."_READY"] = false
    control_panel.call("unReady", p)
    player_control_panel.call("reset")
    for x, d in ipairs(_G[p.."_pokemon"]) do
      _G[p .."_assetbundles"]["slot".. x]["door"].AssetBundle.playLoopingEffect(0)
      d.interactable = true
      Wait.time(|| d.setPosition(_G[p .."_assetbundles"]["slot".. x]["zone"].getPosition()), 1.0001)
      Wait.time(|| d.setLock(false), 1.0001)

    end
  end
end

function start() -- Starts the game if both players are ready
  if PLAYER1_READY == true and PLAYER2_READY == true then
    CURRENT_STATE = "SETUP"
    database = db_module.getTable("database")

    for i = 1, 2, 1 do -- Main loop
      local control = _G["p"..i.."_assetbundles"]["control_panel"]
      local panel = extractChild(control, {'playerpanel(Clone)', 'panels', 'Left'})
      local p = _G["p".. i .."_pokemon"][1]

      local CHP_sheets = extractChild(panel, {'statsPanel', 'CHP'})

      local MHP_sheets = extractChild(panel, {'statsPanel', 'MHP'})
      local MHP = p.getTable("data").hp

      control.AssetBundle.playLoopingEffect(1) -- Turn on options panel
      setHP(CHP_sheets, 3, p.getTable("data").hp, true)
      setHP(MHP_sheets, 3, p.getTable("data").hp)
      setStats(panel, i)
      setAttacks(panel, i)
    end
  end
end

function setHP(array, num, tohp, right_align) -- Set HP of any number fontsheet
  local hp = {}
  for digit in string.gmatch(tostring(tohp), "%d") do table.insert(hp, digit) end
  local align = 0

  for i = num, 1, - 1 do
    local sheet = extractChild(array, {tostring(i + align), "1"}).getComponent("RectTransform")
    repeat -- ghetto continue

      if not hp[i] then
        if right_align == true then
          align = align + 1
        else
          sheet.set("localPosition", {1000, 1000, 0})
        end -- Removes any numbers not present
        break
      end

      local pos = sheet.get("localPosition")
      local pos2 = number_fontsheet[tonumber(hp[i] + 1)] -- 0 is valid

      pos["x"] = pos["x"] + pos2[1]
      pos["y"] = pos["y"] + pos2[2]
      sheet.set("localPosition", pos)

      break
    until true
  end

  for i = 1, align, 1 do -- Removes any characters that were aligned
    local sheet = extractChild(array, {tostring(i), "1"}).getComponent("RectTransform")
    sheet.set("localPosition", {1000, 1000, 0})
  end
end

function setStats(panel, player)
  local type_image = extractChild(panel, {'statsPanel', 'typeImage', 'Image'}).getComponent("RectTransform")
  local pname = _G["p" .. player .. "_pokemon"][1].getTable("data").name
  local type = database[pname]["type"]

  type_image.set("localPosition", type_imagesheet[type])

  for i = 1, 3, 1 do -- Should never be more then 3 in this version.
    local type_image2 = extractChild(panel, {'statsPanel', 'weakness', tostring(i), 'Image'}).getComponent("RectTransform")

    if weakto[type][i] then
      type_image2.set("localPosition", type_imagesheet[weakto[type][i]])
    else
      type_image2.set("localPosition", {100, 100, 100})
    end
  end
end

function setAttacks(panel, player)
  local pname = _G["p" .. player .. "_pokemon"][1].getTable("data").name
  local b = 0
  for i, x in pairs(database[pname]["attacks"]) do
    b = b + 1
    local tpanel = extractChild(panel, {'attacksPanel', tostring(b)}).getComponent("RectTransform")
    local pos = tpanel.get("localPosition")
    pos["x"] = -0.00505
    tpanel.set("localPosition",pos)
  end
end

-------------------------------
---------- POKEMON SWAP
-------------------------------
function swapStart(_, _, id)
  local player = string.match(id, "p%d")
  if _G[player.."_SWAP_SELECT"] == false then
    _G[player.."_SWAP_SELECT"] = true
    control_panel.AssetBundle.playTriggerEffect(5)
  else
    _G[player.."_SWAP_SELECT"] = false
    control_panel.AssetBundle.playTriggerEffect(0)
    local c = _G[player .."_assetbundles"]["control_panel"]
    local selector = extractChild(c, {'playerpanel(Clone)', 'panels', 'Left', 'balls', 'selector'}).getComponent("RectTransform")
    local pos = selector.get("localPosition")
    pos["x"] = swap_positions[_G[player.."_SWAP_ID"]]
    selector.set("localPosition", pos)
  end
end

function swapHover(_, _, id)
  local player = string.match(id, "p%d")
  if _G[player.."_SWAP_SELECT"] == true then
    local localPos = tonumber(string.match(id, "%d.%d%d%d"))

    assert(type(player) == "string", "swapHover incorrectly initalized.")

    local c = _G[player .."_assetbundles"]["control_panel"]
    local selector = extractChild(c, {'playerpanel(Clone)', 'panels', 'Left', 'balls', 'selector'}).getComponent("RectTransform")
    local pos = selector.get("localPosition")
    pos["x"] = localPos
    selector.set("localPosition", pos)
    control_panel.AssetBundle.playTriggerEffect(4)
  end
end

function swapSelect(_, _, id)
  local player = string.match(id, "p%d")
  if _G[player.."_SWAP_SELECT"] == true then
    if _G[string.match(id, "p%d").. "_pokemon"][_G[player.."_SWAP_ID"] + 1] then
      _G[player.."_SWAP_ID"] = tonumber(string.match(id, "%d$"))
      _G[player.."_SWAP_SELECT"] = false
      control_panel.AssetBundle.playTriggerEffect(5)
    end
  end
end
-------------------------------
---------- UI FUNCTIONS
-------------------------------
function optionsPanel()
  control_panel.UI.setAttribute("default", "active", false)
  Wait.time(|| control_panel.UI.setAttribute("options", "active", true), 1)
  control_panel.AssetBundle.playLoopingEffect(3)
  control_panel.AssetBundle.playTriggerEffect(7)
end

function back()
  Wait.time(||control_panel.UI.setAttribute("default", "active", true), 0.75)
  control_panel.UI.setAttribute("options", "active", false)
  control_panel.AssetBundle.playLoopingEffect(4)
  control_panel.AssetBundle.playTriggerEffect(7)
end

function estop()
  Wait.time(||control_panel.UI.setAttribute("default", "active", true), 0.75)
  control_panel.UI.setAttribute("options", "active", false)
  control_panel.AssetBundle.playLoopingEffect(4)
  control_panel.AssetBundle.playTriggerEffect(0)
end

function ready(_, _, player)
  p1_assetbundles.control_panel.UI.setAttribute("p1", "interactable", false)
  slotDetection()
  player1_ready = true
end

function readyCheck()
  if player1_ready == true then
    p1_assetbundles.control_panel.UI.setAttribute("p1", "interactable", true)
  end
end

-------------------------------
---------- SHEETS & DATA
-------------------------------
number_fontsheet = {
  {0, 2.730}, -- 0
  {0, 1}, -- 1
  {0, 2.730}, -- 2
  { - 2.335, 2.730}, -- 3
  { - 2.335, 5.46}, -- 4
  {0, 1}, -- 5
  {0, 0}, -- 6
  {0, 1}, -- 7
  { - 2.335, 0}, -- 8
  {0, 1}, -- 9
  {100, 100, 100} -- nil
}

type_imagesheet = {
  normal = {3.62, - 10.59, 0},
  fire = {3.62, - 3.6, 0},
  electric = {3.62, 3.47, 0},
  water = {3.62, 10.63, 0},
  grass = { - 3.53, - 3.49, 0},
  fighting = { - 3.53, 3.56, 0}
}

swap_positions = { -- Localpositions for the swap icon
  2.136, -- 1
  3.341, -- 2
  4.541, -- 3
  5.802, -- 4
  7.013 -- 5
}

mu = { -- Multipliers
  resist = 0.50,
  crit = 1.75
}

attacking_table = { -- Attack VS Defence
  normal = {fighting = mu.resist},
  fire = {fire = mu.resist, grass = mu.crit, water = mu.resist, fighting = mu.resist},
  grass = {grass = mu.resist, water = mu.crit, fighting = mu.crit},
  water = {water = mu.resist, fire = mu.crit, grass = mu.resist, fighting = mu.crit},
  fighting = {normal = mu.crit},
  psychic = {grass = mu.resist, fighting = mu.crit},
  electric = {grass = mu.resist, water = mu.crit, electric = mu.resist}
}

weakto = { -- If this particular type is weak to an element
  normal = {"fighting"},
  fire = {"water"},
  grass = {"fire"},
  water = {"grass", "electric"},
  fighting = {"grass", "water", "psychic"},
  psychic = {},
  electric = {"water"}
}
