-- Init
--------------------------------------------------------
function onLoad()
  self.interactable = false
  arena_pos = self.getPosition()
  arena_pos["y"] = arena_pos["y"] + 1.4

  ---- Modules
  ui_module = getObjectFromGUID("7e9f75")
  db_module = getObjectFromGUID("28b051")
  loading_screen = getObjectFromGUID("56e737")
  camera = getObjectFromGUID("5c8f8c")

  ---- Holders (not possible to dynamically load because i am lazy atm)
  Red_holder = getObjectFromGUID("395f64")
end

function onChat() -- TEMP REMOVE ON COMPLETION
  print(battleStart("Red", "NPC"))
end

--------------------------------------------------------
-- Options (use setvar("") to change options.)
--------------------------------------------------------
arenaOptions = {
  music = true, -- If music will be loaded for battles. Disable for more then one arena.
  startAnim = true, -- If a custom loading screen will be used to spawn objects. Disable for more then one arena.
  camera_transitions = true, -- If camera transitions will be used during the battle. Disable for more then one arena.
  debug = true, -- Debug options such as health editing.
  battle_in_progress = false -- If a battle on this object is already in progress. Do not modify.
}

--------------------------------------------------------
-- Functions
--------------------------------------------------------
-- battleStart
-- Starts the battle by preparing variables and getting Pokemon in the players party.
-- Returns true if battle did not start successfully.
function battleStart(color1, color2)


  -- Error handling messages
  ---------------------------------------------
  local function error_handler(message) -- Hard crash. Will stop script and break everything.
    log("Game crashed. Please reload.")
    error = ("function 'battleStart': " .. message:lower() .. " - revert with time controls or reload save.")
    return error
  end

  local function player_error(message) -- Player error. Does not stop script.
    print("[FF5733]" .. message)
    -- Can't put return true here because it'll just return this particular function...
  end


  -- Validity checks
  ---------------------------------------------
  -- Check if a battle is already in progress
  if arenaOptions.battle_in_progress == true then
    player_error("Battle already in progress!")
    return true
  end

  -- Variable check
  if color1 == nil or color2 == nil or color1 == "" or color2 == "" then
    error(error_handler("Missing arguments"))
  end
  assert(type(color1) == "string", "Argument 1 is not a string")
  assert(type(color2) == "string", "Argument 2 is not a string")

  -- Check if player is connected/are not the same color. Remove connected in certain releases.
  if arenaOptions.debug == false then
    local colors = {} -- Color exists check
    local playerList = Player.getPlayers()
    for a, player in ipairs(playerList) do
      table.insert(colors, player.color)
    end

    for _, i in pairs(colors) do -- Check against existing players
      if color1:lower() == i:lower() then
        color1v = true
      end
      if color2:lower() == i:lower() then
        color2v = true
      end
    end

    if color2 == "NPC" then colorv2 = true end -- If color2 is an NPC then succeed

    if color2v == true and color1v == true then
      -- Nothing, continue
    else
      player_error("One or more players not currently ingame")
      return true
    end

    if color1:lower() == color2:lower() then
      player_error("Cannot start when both players are the same color")
      return true
    end
  end


  -- Pokemon Check
  ---------------------------------------------
  local fp_holder = _G[color1 .. "_holder"]
  local sp_holder = _G[color2 .. "_holder"]

  local player1 = {
    slotZones = fp_holder.getTable("slots"),
    pokemon = {}
  }

  local player2 = {
    -- slotZones = sp_holder.getTable("slots"), -- Stopping a crash temporarily
    pokemon = nil
  }

  -- Counts Pokemon and adds to current party
  for _, b in ipairs(player1.slotZones) do -- Adds all currently slotted Pokemon into the zone
    local obj = getObjectFromGUID(b[1])
    for _, d in ipairs(obj.getObjects()) do
      if d.getName() == "Pokeball" then
        table.insert(player1.pokemon, d)
      end
    end
  end

  -- Error handler
  if arenaOptions.debug == false then
    if player1.pokemon == nil or player2.pokemon == nil then
      player_error("Unable to start battle, one or more players do not have a Pokemon!")
      if color2 == "NPC" then
        error(error_handler("npc has no pokemon"))
      end
      return true
    end
    if #player1.pokemon > 6 or #player2.pokemon > 6 then
      player_error("Too many Pokemon. Make sure each player has only 6 Pokemon slotted.")
      return true
    end
  end


  -- Setup
  ---------------------------------------------
  arenaOptions.battle_in_progress = true -- Prevents another battle from happening on the same arena.
  log("PKMN Arena Module.".. self.getGUID() .." - Battle started")
end





























-- function onChat()
--   database = db_module.getTable("database")
--   local db = database
--
--   local params = {actor1 = "charmander",
--     color1 = "White",
--     color2 = "Blue",
--     database = db
--   }
--
--   fart()
--   -- Do nothing
--
--   Wait.time(|| ui_module.call("generateAttackUI", params), 2)
-- end
--
-- function fart()
--   loading_screen.AssetBundle.playLoopingEffect(1)
--
--   Wait.time(|| camera.call("camera_rotate"), 4)
--   Wait.time(function() spawn_pokemon(1) end, 2)
--   Wait.time(function() spawn_pokemon(0) end, 2)
-- end
--
-- function spawn_pokemon(side)
--   local pos = arena_pos
--   if side == 1 then
--     pos["z"] = pos["z"] - 20
--     rot = {0, 0, 0}
--   else
--     pos["z"] = pos["z"] + 40 -- I honestly have no idea.
--     rot = {0, 180, 0}
--   end
--
--   pos["y"] = pos["y"] + 0.12
--
--   spawnParams = {
--     type = "custom_assetbundle",
--     position = pos,
--     rotation = rot,
--     sound = false,
--     callback_function = function(obj) spawn_callback(obj, "Hey", "white") end
--   }
--
--   spawnObject(spawnParams)
-- end
--
-- function spawn_callback(object_spawned, name, color)
--   Wait.time(|| loading_screen.AssetBundle.playLoopingEffect(2), 3)
--   Wait.time(|| loading_screen.AssetBundle.playLoopingEffect(0), 5)
--
--   obj_params = {
--     assetbundle = tostring(database["charmander"]["assetbundle"]),
--     type = 1
--   }
--
--   object_spawned.setCustomObject(obj_params)
--   object_spawned.reload()
-- end
