-- Include Simple Tiled Implementation into project
local sti = require "sti"

function love.load()
    -- Load map file

    map = sti.new("assets/test.lua", { "box2d" })
    -- map = sti.new("assets/ortho.lua", { "box2d" })


    map:addCustomLayer("Player Layer", 2)
    playerLayer = map.layers["Player Layer"]

    playerLayer.sprite = {x = 64, y = 250,
                          vx = 400, vy = 0,
                          jump_height = -300,
                          gravity = 250,
                          image = love.graphics.newImage("assets/images/p1_stand.png")
                        }


    love.physics.setMeter(70)
    world = love.physics.newWorld(0, playerLayer.sprite.gravity*9.81, true)

    playerLayer.sprite.body = love.physics.newBody(world, playerLayer.sprite.x+playerLayer.sprite.image:getWidth()/2, playerLayer.sprite.y+playerLayer.sprite.image:getHeight()/2, "dynamic")
	  playerLayer.sprite.shape = love.physics.newRectangleShape(playerLayer.sprite.image:getWidth(), playerLayer.sprite.image:getHeight())
	  playerLayer.sprite.fixture = love.physics.newFixture(playerLayer.sprite.body, playerLayer.sprite.shape)
    playerLayer.sprite.body:setFixedRotation(true)

    -- playerLayer.sprite.ground = playerLayer.sprite.y -- Problematic line. Ground doesnot takes y as value. Don't know why!!
    playerLayer.sprite.ground = playerLayer.sprite.body:getY()
    playerLayer.sprite.y = playerLayer.sprite.body:getY()
    -- playerLayer.sprite.body:setLinearDamping(10)

    map:box2d_init(world)

    function playerLayer:draw()
      -- local gx, gy, gx1, gy1, gx2, gy2, gx3, gy3 = self.sprite.body:getWorldPoints(self.sprite.shape:getPoints())
      local gx = self.sprite.body:getX()-self.sprite.image:getWidth()/2
      local gy = self.sprite.body:getY()-self.sprite.image:getHeight()/2

      love.graphics.draw(self.sprite.image, gx, gy, self.sprite.body:getAngle())
      -- love.graphics.print(gx .. " " .. gy)
      love.graphics.print(self.sprite.x .. " " .. self.sprite.y .. "\n" .. self.sprite.body:getX() .. " " .. self.sprite.body:getY())
    end

    function playerLayer:update(dt)
      self.sprite.ground = playerLayer.sprite.body:getY()
      self.sprite.y = playerLayer.sprite.body:getY()
      if love.keyboard.isDown("right") then
        self.sprite.body:setX(playerLayer.sprite.body:getX() + self.sprite.vx * dt)
        self.sprite.x = playerLayer.sprite.body:getX()
        self:setVX(self.sprite.vx)
      end
      if love.keyboard.isDown("left") then
        self.sprite.body:setX(playerLayer.sprite.body:getX() - self.sprite.vx * dt)
        self.sprite.x = playerLayer.sprite.body:getX()
        self:setVX(-self.sprite.vx)
      end
      if love.keyboard.isDown("space") then
        if self.sprite.vy == 0 then
          self.sprite.body:setX(playerLayer.sprite.body:getY())
          self.sprite.vy = self.sprite.jump_height
          self:setVY(self.sprite.vy)
        end
      end

      if self.sprite.vy ~= 0 then
        local gvx, gvy = world:getGravity()
        self.sprite.body:setY(playerLayer.sprite.body:getY() + self.sprite.vy * dt)
        self.sprite.x = playerLayer.sprite.body:getX()
        self.sprite.y = playerLayer.sprite.body:getY()
		    self.sprite.vy = self.sprite.vy + gvy * dt
        self:setVY(self.sprite.vy)
      end

      if self.sprite.y > self.sprite.ground then
		    self.sprite.vy = 0
        self.sprite.body:setY(self.sprite.ground)
        self.sprite.body:setX(self.sprite.x)
        self.sprite.y = self.sprite.body:getY()
        self:setVY(self.sprite.vy)
      end
      self.sprite.body:setX(self.sprite.x)
    end

    function playerLayer:setVX(vx)
      local b_vx, b_vy = self.sprite.body:getLinearVelocity()
      b_vx = vx
      self.sprite.body:setLinearVelocity(b_vx, b_vy)
    end

    function playerLayer:setVY(vy)
      local b_vx, b_vy = self.sprite.body:getLinearVelocity()
      b_vy = vy
      self.sprite.body:setLinearVelocity(b_vx, b_vy)
    end
end

function love.draw()

    map:draw()

    love.graphics.setColor(255, 0, 0, 255)
    map:box2d_draw()
    love.graphics.polygon("line", playerLayer.sprite.body:getWorldPoints(playerLayer.sprite.shape:getPoints()))
    love.graphics.setColor(255, 255, 255, 255)
end

function love.update(dt)
    world:update(dt)
    map:update(dt)
end
