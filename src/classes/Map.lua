local Map = {}
Map.__index = Map

function Map:load(world, map)
    sti = require("libraries.sti")
    CollisionComponent = require("src.components.CollisionComponent")
    PlantableAreaComponent = require("src.components.PlantableAreaComponent")

    local self = setmetatable({}, Map)

    self.x = 0
    self.y = 0

    self.world = world
    self.map = sti(map)

    self.map_scale = 4

    self.width = self.map.width * self.map.tilewidth * self.map_scale
    self.height = self.map.height * self.map.tileheight * self.map_scale

    self:load_map_layers()


    return self
end

function Map:load_map_layers()
    self.drawable_layers = {}

    for _, layer in ipairs(self.map.layers) do
        if layer.class == "Collision" then
            self.collision_component = CollisionComponent:load(self.world, layer, self.map_scale)
        else
            if layer.class == "PlantableArea" then
                self.trigger_component = PlantableAreaComponent:load(self.world, layer, self.map, self.map_scale)
            end
            self.drawable_layers[#self.drawable_layers + 1] = layer 
        end
    end
end

function Map:draw()
    love.graphics.push()
    love.graphics.scale(self.map_scale, self.map_scale)

    for _, layer in ipairs(self.drawable_layers) do
        self.map:drawLayer(layer)
    end

    love.graphics.pop()
end

return Map