local Map = {}
Map.__index = Map

function Map:load(world, map)
    sti = require("libraries.sti")
    CollisionComponent = require("src.components.CollisionComponent")

    local self = setmetatable({}, Map)

    self.x = 0
    self.y = 0

    self.world = world
    self.map = sti(map)

    self.map_scale = 4

    self.width = self.map.width * self.map.tilewidth * self.map_scale
    self.height = self.map.height * self.map.tileheight * self.map_scale

    self.collision = CollisionComponent:load(self.world, self.map.layers["Collision"], self.map_scale)
    self.collision:create_collisions()

    return self
end

function Map:draw()
    love.graphics.push()
    love.graphics.scale(self.map_scale, self.map_scale)

    for _, layer in ipairs(self.map.layers) do
        if layer.visible and layer.name ~= "Collision" then
            self.map:drawLayer(layer)
        end
    end

    love.graphics.pop()
end

return Map