local PlantableAreaComponent = {}
PlantableAreaComponent.__index = PlantableAreaComponent

function PlantableAreaComponent:load(world, layer, map, map_scale)
    local self = setmetatable({}, PlantableAreaComponent)

    self.map = map
    self.world = world
    self.layer = layer
    self.map_scale = map_scale

    self.area_tiles = self:create_triggers(self.layer)

    return self
end

function PlantableAreaComponent:create_triggers(layer)
    local area_tiles = {}

    for y = 1, layer.height do
        for x = 1, layer.width do
            local tile = layer.data[y][x]
            if tile then
                if tile.gid > 0 then 
                    local tile_x = (x - 1) * self.map.tilewidth * self.map_scale
                    local tile_y = (y - 1) * self.map.tileheight * self.map_scale
                    
                    local area_tile = self.world:newRectangleCollider(tile_x, tile_y, self.map.tilewidth * self.map_scale, self.map.tileheight * self.map_scale)
                    area_tile:setCollisionClass(layer.class)
                    area_tile:setSensor(true)

                    table.insert(area_tiles, area_tile)
                end
            end
        end
    end

    return area_tiles
end

return PlantableAreaComponent