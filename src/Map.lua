local Map = {}
Map.__index = Map

function Map:load(map, player, camera)
    sti = require("libraries.sti")
    CollisionAreaComponent = require("src.components.areas.CollisionAreaComponent")
    PlantableAreaComponent = require("src.components.areas.PlantableAreaComponent")
    PlaceableAreaComponent = require("src.components.areas.PlaceableAreaComponent")
    UseableObjComponent = require("src.components.areas.UseableObjComponent")

    local self = setmetatable({}, Map)
    self.x = 0
    self.y = 0

    self.map = sti(map)

    self.map_scale = TILE_SCALE

    self.width = self.map.width * self.map.tilewidth * self.map_scale
    self.height = self.map.height * self.map.tileheight * self.map_scale

    self.drawable_layers = {}
    self.collision_component = {}
    self.plantable_area_component = {}
    self.placeable_area_component = {}
    self.useable_obj_component = {}

    self.player = player
    self.camera = camera

    self:load_map_layers()

    return self
end

function Map:load_map_layers()
    for _, layer in ipairs(self.map.layers) do
        if layer.class == "CollisionArea" then
            self.collision_component = CollisionAreaComponent:load(layer)
        elseif layer.class == "UseableObj" then
            self.useable_obj_component = UseableObjComponent:load(layer, self.player)
        else
            if layer.properties.is_plantable then
                self.plantable_area_component = PlantableAreaComponent:load(layer, self.map, self.player, self.camera)
            elseif layer.properties.is_placeable then
                self.placeable_area_component = PlaceableAreaComponent:load(layer, self.map, self.player, self.camera)
            end
            self.drawable_layers[#self.drawable_layers + 1] = layer
        end
    end
end

function Map:update(dt)
    self.plantable_area_component:update(dt)
    self.placeable_area_component:update(dt)
end

function Map:draw()
    love.graphics.push()
    love.graphics.scale(self.map_scale, self.map_scale)

    for _, layer in ipairs(self.drawable_layers) do
        self.map:drawLayer(layer)
    end

    love.graphics.pop()

    self.plantable_area_component:draw()
    self.placeable_area_component:draw()
    self.useable_obj_component:draw()
end

return Map