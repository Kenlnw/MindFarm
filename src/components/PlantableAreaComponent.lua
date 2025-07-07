local PlantableAreaComponent = {}
PlantableAreaComponent.__index = PlantableAreaComponent

function PlantableAreaComponent:new()
    require("src.data.plantableItems")
    require("src.utils")
    local self = setmetatable({}, PlantableAreaComponent)

    self.plantable_areas = nil

    return self
end

function PlantableAreaComponent:load(world, layer, map, player, camera)
    self.map = map
    self.world = world
    self.layer = layer
    self.map_scale = TILE_SCALE
    self.player = player
    self.camera = camera

    self.plantable_areas = self:create_triggers(self.layer)

    self.current_area = nil

    self.seed = nil
end

function PlantableAreaComponent:create_triggers(layer)
    local plantable_areas = {}

    for y = 1, layer.height do
        for x = 1, layer.width do
            if layer.data[y][x] then
                if layer.data[y][x].gid > 0 then 
                    local plantable_area = {}
                    plantable_area.id = "plantable_area" 
                    plantable_area.x = (x - 1) * self.map.tilewidth * self.map_scale
                    plantable_area.y = (y - 1) * self.map.tileheight * self.map_scale
                    plantable_area.width = self.map.tilewidth * self.map_scale
                    plantable_area.height = self.map.tileheight * self.map_scale
                    
                    plantable_area.body = love.physics.newBody(self.world, plantable_area.x, plantable_area.y, "static")
                    plantable_area.shape = love.physics.newRectangleShape(plantable_area.width/2, plantable_area.height/2, plantable_area.width, plantable_area.height)
                    plantable_area.fixture = love.physics.newFixture(plantable_area.body, plantable_area.shape)
                    plantable_area.body:setFixedRotation(true)
                    plantable_area.fixture:setSensor(true)
                    plantable_area.is_active = false
                    plantable_area.is_planted = false
                    plantable_area.seed = nil

                    function plantable_area:plant_seed(seed_id)
                        if not self.is_planted then
                            self.is_planted = true
                            for id, item in pairs(plantable_items) do
                                if id == seed_id then
                                    self.seed = item:load(self.x + self.width/2, self.y, 1)
                                end
                            end
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
        self.plant_seed_id = nil
        for _, slot in pairs(self.player.slot_bar.slots) do
            if slot.item and slot.is_selected then
                self.plant_seed_id = slot.item.id
                debug_text = self.plant_seed_id
                break
            else
                debug_text = ""
            end
        end

        local mouse_x, mouse_y = self.camera:mousePosition()
        local mouse_distance = distance_between(mouse_x, mouse_y, self.player.sensor_point.x, self.player.sensor_point.y)
        debug_text = mouse_x .." ".. mouse_y .." ".. mouse_distance

        -- if  then
            
            for _, area in ipairs(self.plantable_areas) do
    
                if is_inside(mouse_x, mouse_y, area) and mouse_distance <= area.width*2 then
                    area.is_active = true
                    self.current_area = area
                    break
                else
                    area.is_active = false
                    self.current_area = nil
                end
    
                if area.seed then
                    area.seed:update(dt)
                end
            end
        -- end

    end
end

function PlantableAreaComponent:interact()
    for _, area in ipairs(self.plantable_areas) do
        if self.plant_seed_id and area.is_active then
            area:plant_seed(self.plant_seed_id)
            break
        end
    end
end

function PlantableAreaComponent:draw()
    if self.plantable_areas then 
        for _, area in ipairs(self.plantable_areas) do
            if area == self.current_area then
                set_color(0, 0, 0)
                love.graphics.rectangle("line", area.x ,area.y, area.width, area.height)
                reset_color()
            end

            if area.is_planted then
                -- love.graphics.rectangle("fill", area.x ,area.y, area.width, area.height)
                area.seed:draw()
            end
        end
    end
end

return PlantableAreaComponent