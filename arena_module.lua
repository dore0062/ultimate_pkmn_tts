function onLoad()
  -- self.interactable = false
  arena_pos = self.getPosition()
  arena_pos["y"] = arena_pos["y"] + 1.4
  ui_module = getObjectFromGUID("7e9f75")
  db_module = getObjectFromGUID("28b051")
  loading_screen = getObjectFromGUID("56e737")
  camera = getObjectFromGUID("5c8f8c")
end

function onChat()

  database = db_module.getTable("database")
  local db = database

  local params = {actor1 = "charmander",
    color1 = "White",
    color2 = "Blue",
    database = db
  }

  fart()
  -- Do nothing

  Wait.time(|| ui_module.call("generateAttackUI", params),2)
end

function fart()
  loading_screen.AssetBundle.playLoopingEffect(1)

  Wait.time(|| camera.call("camera_rotate"), 4)
  Wait.time(function() spawn_pokemon(1) end, 2)
  Wait.time(function() spawn_pokemon(0) end, 2)
end

function spawn_pokemon(side)
  local pos = arena_pos
  if side == 1 then
    pos["z"] = pos["z"] - 20
    rot = {0, 0, 0}
  else
    pos["z"] = pos["z"] + 40 -- I honestly have no idea.
    rot = {0, 180, 0}
  end

  pos["y"] = pos["y"] + 0.12

  spawnParams = {
    type = "custom_assetbundle",
    position = pos,
    rotation = rot,
    sound = false,
    callback_function = function(obj) spawn_callback(obj, "Hey", "white") end
  }

  spawnObject(spawnParams)
end

function spawn_callback(object_spawned, name, color)
  Wait.time(|| loading_screen.AssetBundle.playLoopingEffect(2),3)
  Wait.time(|| loading_screen.AssetBundle.playLoopingEffect(0),5)

  obj_params = {
    assetbundle = tostring(database["charmander"]["assetbundle"]),
    type = 1
  }

  object_spawned.setCustomObject(obj_params)
  object_spawned.reload()
end
