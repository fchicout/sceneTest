local Player = {}

function Player:new(o)
  o=o or {
    x = 64, y = 250,
    vx = 400, vy = 0,
    jump_height = -300,
    gravity = l,
    image = love.graphics.newImage("assets/images/p1_stand.png")
  }
  setmetatable(o, self)
  self.__index=self
  return o
end

function Player:load(world, map)
  map:addCustomLayer("Player_Layer", 2)
  self.layer = map.layers["Player_Layer"]

  self.body = love.physics.newBody(world, self.x+self.image:getWidth()/2, self.y+self.image:getHeight()/2, "dynamic")
  self.shape = love.physics.newRectangleShape(self.image:getWidth(), self.image:getHeight())
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.body:setFixedRotation(true)

  -- playerLayer.sprite.ground = playerLayer.sprite.y -- Problematic line. Ground doesnot takes y as value. Don't know why!!
  self.ground = self.body:getY()
  self.y = self.body:getY()
  -- playerLayer.sprite.body:setLinearDamping(10)
end

function Player:draw()
  -- local gx, gy, gx1, gy1, gx2, gy2, gx3, gy3 = self.sprite.body:getWorldPoints(self.sprite.shape:getPoints())
  local gx = self.body:getX()-self.image:getWidth()/2
  local gy = self.body:getY()-self.image:getHeight()/2

  love.graphics.draw(self.image, gx, gy, self.body:getAngle())
  -- love.graphics.print(gx .. " " .. gy)
  love.graphics.print(self.x .. " " .. self.y .. "\n" .. self.body:getX() .. " " .. self.body:getY())
  love.graphics.setColor(255, 0, 0, 255)
  map:box2d_draw()
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
  love.graphics.setColor(255, 255, 255, 255)
end

function Player:update(dt)
  self.ground = self.body:getY()
  self.y = self.body:getY()
  if love.keyboard.isDown("right") then
    self.body:setX(self.body:getX() + self.vx * dt)
    self.x = self.body:getX()
    self:setVX(self.vx)
  end
  if love.keyboard.isDown("left") then
    self.body:setX(self.body:getX() - self.vx * dt)
    self.x = self.body:getX()
    self:setVX(-self.vx)
  end
  if love.keyboard.isDown("space") then
    if self.vy == 0 then
      self.body:setX(self.body:getY())
      self.vy = self.jump_height
      self:setVY(self.vy)
    end
  end

  if self.vy ~= 0 then
    local gvx, gvy = world:getGravity()
    self.body:setY(self.body:getY() + self.vy * dt)
    self.x = self.body:getX()
    self.y = self.body:getY()
    self.vy = self.vy + gvy * dt
    self:setVY(self.vy)
  end

  if self.y > self.ground then
    self.vy = 0
    self.body:setY(self.ground)
    self.body:setX(self.x)
    self.y = self.body:getY()
    self:setVY(self.vy)
  end
  self.body:setX(self.x)
end
function Player:setVX(vx)
  local b_vx, b_vy = self.body:getLinearVelocity()
  b_vx = vx
  self.body:setLinearVelocity(b_vx, b_vy)
end

function Player:setVY(vy)
  local b_vx, b_vy = self.body:getLinearVelocity()
  b_vy = vy
  self.body:setLinearVelocity(b_vx, b_vy)
end

return Player
