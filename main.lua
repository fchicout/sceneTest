local sti = require "sti"
local playerClass = require "player"


function love.load()
  -- Load map file
  map = sti.new("assets/test.lua", { "box2d" })
  love.physics.setMeter(70)
  player = playerClass:new()
  world = love.physics.newWorld(0, 250*9.81, true)
  player:load(world, map)
  map:box2d_init(world)
end

function love.draw()
    map:draw()
    player:draw()
end

function love.update(dt)
    world:update(dt)
    player:update(dt)
    map:update(dt)
end
