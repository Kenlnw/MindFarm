local PlantableAreaComponent = {}
PlantableAreaComponent.__index = PlantableAreaComponent

function PlantableAreaComponent:load(world, layer, map, map_scale)
    local self = setmetatable({}, PlantableAreaComponent)

    self.map = map
    self.world = world
    self.layer = layer
    self.map_scale = map_scale

    self.plantable_areas = self:create_triggers(self.layer)

    return self
end

function PlantableAreaComponent:create_triggers(layer)
    local plantable_areas = {}

    for y = 1, layer.height do
        for x = 1, layer.width do
            if layer.data[y][x] then
                if layer.data[y][x].gid > 0 then 
                    local plantable_area = {}
                    plantable_area.tag = "plantable_area" 
                    plantable_area.x = (x - 1) * self.map.tilewidth * self.map_scale
                    plantable_area.y = (y - 1) * self.map.tileheight * self.map_scale
                    plantable_area.width = self.map.tilewidth * self.map_scale
                    plantable_area.height = self.map.tileheight * self.map_scale
                    
                    plantable_area.body = love.physics.newBody(self.world, plantable_area.x, plantable_area.y, "static")
                    plantable_area.shape = love.physics.newRectangleShape(plantable_area.width/2, plantable_area.height/2, plantable_area.width, plantable_area.height)
                    plantable_area.fixture = love.physics.newFixture(plantable_area.body, plantable_area.shape)
                    plantable_area.body:setFixedRotation(true)
                    plantable_area.fixture:setSensor(true)
                    plantable_area.fixture:setUserData(plantable_area)

                    table.insert(plantable_areas, plantable_area)
                end
            end
        end
    end

    return area_tiles
end

function PlantableAreaComponent:draw()
    -- for _, area in ipairs(self.plantable_areas) do
    --     love.graphics.rectangle("line", area.x ,area.y, area.width, area.height)
    -- end
end

return PlantableAreaComponent