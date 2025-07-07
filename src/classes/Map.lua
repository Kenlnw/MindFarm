local Map = {}
Map.__index = Map

function Map:load(world, map, player, camera)
    sti = require("libraries.sti")
    CollisionAreaComponent = require("src.components.CollisionAreaComponent")
    PlantableAreaComponent = require("src.components.PlantableAreaComponent")
    require("src.utils")

    local self = setmetatable({}, Map)

    self.x = 0
    self.y = 0

    self.world = world
    self.map = sti(map)

    self.map_scale = TILE_SCALE

    self.width = self.map.width * self.map.tilewidth * self.map_scale
    self.height = self.map.height * self.map.tileheight * self.map_scale

    self.drawable_layers = {}
    self.collision_component = CollisionAreaComponent:new()
    self.plantable_area_component = PlantableAreaComponent:new()

    self.player = player
    self.camera = camera

    self:load_map_layers()


    return self
end

function Map:load_map_layers()
    for _, layer in ipairs(self.map.layers) do
        if layer.class == "CollisionArea" then
            self.collision_component:load(self.world, layer)
        else
            if layer.class == "PlantableArea" then
                self.plantable_area_component:load(self.world, layer, self.map, self.player, self.camera)
            end
            self.drawable_layers[#self.drawable_layers + 1] = layer 
        end
    end
end

function Map:update(dt)
    self.plantable_area_component:update(dt)
end

function Map:draw()
    love.graphics.push()
    love.graphics.scale(self.map_scale, self.map_scale)

    for _, layer in ipairs(self.drawable_layers) do
        self.map:drawLayer(layer)
    end

    love.graphics.pop()

    self.plantable_area_component:draw()
end

return Map