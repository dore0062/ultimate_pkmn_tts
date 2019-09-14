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

  control_panel = getObjectFromGUID("eb763b")

  -- Uninteractables
  self.interactable = false
end

function onChat(message, player)
 setPokemon_pp(152,"p1")
end


---------- OPTIONS
options = {
  party_size = 2 -- Total party size. Must be equal to the total number of valid slots
}

---------- GLOBAL VARIABLES
CURRENT_STATE = "IDLE" -- Current state of the arena for onLoad/onSave
PLAYER1_READY = false
PLAYER2_READY = false

---------- UTILITY
function extractChild(element, children) -- Credit to dzikakulka. Extracts children/components easily
  for _, name in ipairs(children) do
    element = element.getChild(name)
  end
  return element
end

---------- FUNCTIONS
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
  Wait.time(|| pokeball.setLock(true), 2)
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

  for i = 1, options.party_size, 1 do -- Do all slot detections
    table.insert(pokemon, slotDetection(p, i))
  end

  for b, a in pairs(pokemon) do
    print(a)
  end

  _G[p.."_pokemon"] = pokemon

  local p_ready = _G["PLAYER".. string.match(p,"%d+") .."_READY"]

  if p_ready == false then
    log("arena." .. self.getGUID() .. " control_panel setReady")
    _G["PLAYER".. string.match(p,"%d+") .."_READY"] = true
    control_panel.call("setReady", p)
  else
    log("arena." .. self.getGUID() .. " control_panel unReady")
    _G["PLAYER".. string.match(p,"%d+") .."_READY"] = false
    control_panel.call("unReady", p)
  end

end

function setPokemon_pp(index, p)
  local a = _G[p .."_assetbundles"]["control_panel"]
  a.call("setImage",index)
end

---------- UI FUNCTIONS
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
