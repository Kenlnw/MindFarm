local PlantableAreaComponent = {}
PlantableAreaComponent.__index = PlantableAreaComponent

function PlantableAreaComponent:new()
    require("src.data.itemsList")
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

end

function PlantableAreaComponent:create_triggers(layer)
    local plantable_areas = {}

    for y = 1, layer.height do
        for x = 1, layer.width do
            local data = layer.data[y][x]
            if data then
                if data.gid > 0 then
                    local plantable_area = {}
                    plantable_area.crop_flip_x = 1
                    plantable_area.crop_flip_y = 1

                    if data.gid == 105 or data.gid == 117 or data.gid == 141 then
                        plantable_area.crop_flip_x = -1
                    end
                    if data.gid == 141 or data.gid == 142 or data.gid == 144 then
                        plantable_area.crop_flip_y = -1
                    end

                    plantable_area.id = "plantable_area"
                    plantable_area.x = (x - 1) * self.map.tilewidth * self.map_scale
                    plantable_area.y = (y - 1) * self.map.tileheight * self.map_scale
                    plantable_area.width = self.map.tilewidth * self.map_scale
                    plantable_area.height = self.map.tileheight * self.map_scale

                    plantable_area.body = love.physics.newBody(self.world, plantable_area.x, plantable_area.y, "static")
                    plantable_area.shape = love.physics.newRectangleShape(plantable_area.width / 2,
                        plantable_area.height / 2, plantable_area.width, plantable_area.height)
                    plantable_area.fixture = love.physics.newFixture(plantable_area.body, plantable_area.shape)
                    plantable_area.body:setFixedRotation(true)
                    plantable_area.fixture:setSensor(true)
                    plantable_area.is_active = false
                    plantable_area.is_planted = false
                    plantable_area.is_watered = false
                    plantable_area.crop = nil

                    function plantable_area:plant_crop(crops_id)
                        if not self.is_planted then
                            self.is_planted = true
                            local crop = crops[crops_id]
                            if crop then
                                self.crop = crop:load(self.x, self.y, 1, self.crop_flip_x, self.crop_flip_y)
                            end
                        end
                    end

                    function plantable_area:reset_area()
                        self.is_planted = false
                        self.is_watered = false
                        self.crop = nil
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
        self.crops_id = nil
        for _, slot in pairs(self.player.slot_bar.slots) do
            if slot.item and slot.is_selected then
                if slot.item.is_plantable and slot.item.frame == 8 then
                    self.crops_id = slot.item.id
                end
                break
            end
        end

        local mouse_x, mouse_y = self.camera:mousePosition()
        local mouse_distance =
            distance_between(mouse_x, mouse_y, self.player.sensor_point.x, self.player.sensor_point.y)

        for _, area in ipairs(self.plantable_areas) do
            if is_inside(mouse_x, mouse_y, area) and mouse_distance <= area.width * 2 then
                area.is_active = true
                self.current_area = area
                break
            else
                area.is_active = false
                self.current_area = nil
                debug_text = ""
            end

            if area.crop then
                area.crop:update(dt)
            end

            if area.is_watered then
                debug_text = "watered"
            end
        end

    end
end

function PlantableAreaComponent:interactLC()
    for _, area in ipairs(self.plantable_areas) do
        if area.is_active == false then
            goto continue
        end

        if self.player.current_item == "water_can" and area.crop then
            area.is_watered = true
            area.crop.is_watered = true
        end
        if self.crops_id then
            area:plant_crop(self.crops_id)
            break
        end
        ::continue::
    end
end

function PlantableAreaComponent:interactRC()
    for _, area in ipairs(self.plantable_areas) do
        if area.is_active == false then
            goto continue
        end

        if area.crop and area.crop.can_harvest then
            for _, slot in ipairs(self.player.slot_bar.slots) do
                if slot.item then
                    goto continue
                end
                local crop = crops[area.crop.id]
                if crop then
                    local fruit = crop:load(slot.x, slot.y, 9)
                    slot.item = fruit
                    break
                end

                ::continue::
            end
            area:reset_area()
            break
        end
        ::continue::
    end
end

function PlantableAreaComponent:draw()
    if self.plantable_areas then
        for _, area in ipairs(self.plantable_areas) do
            if area == self.current_area then
                set_color(0, 0, 0)
                love.graphics.rectangle("line", area.x, area.y, area.width, area.height)
                reset_color()
            end

            if area.is_watered then
                love.graphics.rectangle("fill", area.x, area.y, area.width, area.height)
            end
            if area.is_planted and area.crop then
                area.crop:draw()
            end

        end
    end
end

return PlantableAreaComponent
