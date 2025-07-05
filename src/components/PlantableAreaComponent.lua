local PlantableAreaComponent = {}
PlantableAreaComponent.__index = PlantableAreaComponent

function PlantableAreaComponent:new()
    local self = setmetatable({}, PlantableAreaComponent)

    self.plantable_areas = nil

    return self
end

function PlantableAreaComponent:load(world, layer, map, map_scale, player)
    self.map = map
    self.world = world
    self.layer = layer
    self.map_scale = map_scale
    self.player = player

    self.plantable_areas = self:create_triggers(self.layer)
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
                    plantable_area.top_x = plantable_area.x - plantable_area.width
                    plantable_area.top_y = plantable_area.y - plantable_area.height
                    
                    plantable_area.body = love.physics.newBody(self.world, plantable_area.x, plantable_area.y, "static")
                    plantable_area.shape = love.physics.newRectangleShape(plantable_area.width/2, plantable_area.height/2, plantable_area.width, plantable_area.height)
                    plantable_area.fixture = love.physics.newFixture(plantable_area.body, plantable_area.shape)
                    plantable_area.body:setFixedRotation(true)
                    plantable_area.fixture:setSensor(true)
                    plantable_area.is_active = false
                    plantable_area.is_planted = false
                    
                    function plantable_area:toggle_plant_seed()
                        if not self.is_planted then
                            self.is_planted = true
                            debug_text = "planted"
                        else
                            self.is_planted = false
                            debug_text = "remove planted"
                        end
                    end

                    plantable_area.fixture:setUserData(plantable_area)

                    table.insert(plantable_areas, plantable_area)
                end
            end
        end
    end

    return plantable_areas
end

function PlantableAreaComponent:update(dt)
    if self.plantable_areas and self.player then
        for i = 2, 2 do
            local area = self.plantable_areas[i]
            local area_closest_x = math.max(area.x, math.min(self.player.sensor_point.x, area.x + area.width))
            local area_closest_y = math.max(area.y, math.min(self.player.sensor_point.y, area.y + area.height))
            local distance = distance_between(self.player.sensor_point.x, self.player.sensor_point.y, area_closest_x, area_closest_y)
            if distance < self.player.sensor_point.radius or distance == 0 then
                -- self:interact()
                -- debug_text = "collided" .." ".. distance
                debug_text = "collided" .." ".. self.player.sensor_point.x .." ".. self.player.sensor_point.y .." ".. area_closest_x .." ".. area_closest_y
                break
            else
                -- debug_text = "not collided" .." ".. distance
                debug_text = "not collided" .." ".. self.player.sensor_point.x .." ".. self.player.sensor_point.y .." ".. area_closest_x .." ".. area_closest_y
            end
        end
    else
        debug_text = "not found player"
    end
end

function PlantableAreaComponent:interact()
    self.space_pressed = self.space_pressed or false

    if love.keyboard.isDown("space") then
        if not self.space_pressed then
            for _, area in ipairs(self.plantable_areas) do
                if area.is_active then
                    area:toggle_plant_seed()
                end
            end
            self.space_pressed = true
        end
    else
        self.space_pressed = false
    end
end

function PlantableAreaComponent:draw()
    -- if self.plantable_areas then 
    --     for _, area in ipairs(self.plantable_areas) do
    --         if area.is_planted == true then
    --             love.graphics.rectangle("fill", area.x ,area.y, area.width, area.height)
    --         end
    --     end
    -- end
end

return PlantableAreaComponent