function onLoad(saved_data)
    if saved_data ~= nil then
      slots = JSON.decode(saved_data)
    end
end

function onSave()
  local saved_data = JSON.encode(slots)
  return saved_data
end

function onChat(message, player) -- Use this to initalize holder(s) on a new save.
  if player.host == true then
    if message == "holder_spawn_zones" then
      slots = {} -- Resets zones (make sure no zones already exist.)
      spawn_holder_zones({0, 2, 0}, 1) -- Middle center
      spawn_holder_zones({0, 0.75, - 2.9, 2}) --Front
      spawn_holder_zones({3.5, 0.75, - 1.5, 3}) -- L1
      spawn_holder_zones({ - 3.5, 0.75, - 1.5, 4}) -- R1
      spawn_holder_zones({4.75, 0.75, 1.85, 5}) -- L2
      spawn_holder_zones({ - 5, 0.75, 1.85, 6}) -- R2
    end
  end
end


function spawn_holder_zones(spawn_pos, id) -- Emergency ID in case of failstate during function.
local function spawn_callback(obj)
  table.insert(slots, {obj.getGUID(), id}) -- Insert into master table. Have to convert to GUID to save.
end

local position = self.getPosition()
position["x"] = position["x"] + spawn_pos[1]
position["y"] = position["y"] + spawn_pos[2]
position["z"] = position["z"] + spawn_pos[3]

spawnParams = {
  type = "ScriptingTrigger",
  position = position,
  rotation = rot,
  scale = {x = 2, y = 2, z = 2}, -- something
  sound = false,
  callback_function = function(obj) spawn_callback(obj) end
}

spawnObject(spawnParams)
end
