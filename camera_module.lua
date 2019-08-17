-- Hey
#include tween

local dt = 1 -- Delta time

function onload()
  intro_camera = getObjectFromGUID("ee47c3")
end

function camera_rotate()
  fart = true
  subject = {x = 0}
  t3 = tween.new(10000, subject, {x = 360})

  function print_thing()
    if subject["x"] == 360 then fart = false end
    t3:update(1)
    camera_rotation(subject["x"])
  end
end


function onUpdate() -- 1 = 1 frame
  if fart == true then
    print_thing()
  end
end

function camera_rotation(i)
  Player["White"].lookAt({
    position = {x = 0, y = 0, z = 0},
    pitch = 25,
    yaw = i,
    distance = 50,
  })
end
