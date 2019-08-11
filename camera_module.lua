function cameraRotate()
local y = self.getRotation()
 self.setRotationSmooth({0,y[2] + 5, 0})
Wait.frames(cameraRotate, 30)

local x = self.getPosition()
Wait.frames(|| z = orbit.getPosition(), 2)


local angle = 5
local rotatedX = Math.cos(angle) * (z[1] - x[1]) - Math.sin(angle) * (z[2] - x[2]) + x[2];
local rotatedY = Math.sin(angle) * (z[1] - x[1]) + Math.cos(angle) * (z[2] - x[2]) + y[2];



Wait.frames(|| orbit.setPosition({rotatedX, x[2], rotatedY}), 2)
 end
