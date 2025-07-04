local Map = {}
Map.__index = Map

function Map:load()
    sti = require("libraries.sti")

    local self = setmetatable({}, Map)

    self.x = 0
    self.y = 0

    self.map = sti("maps/prototype_town.lua")

    self.map_scale = 4

    self.width = self.map.width * self.map.tilewidth * self.map_scale
    self.height = self.map.height * self.map.tileheight * self.map_scale

    return self
end

function Map:draw()
    love.graphics.push()
    love.graphics.scale(self.map_scale, self.map_scale)

    for _, layer in ipairs(self.map.layers) do
        if layer.visible then
            self.map:drawLayer(layer)
        end
    end

    love.graphics.pop()
end

return Map