local PlantableAreaComponent = {}
PlantableAreaComponent.__index = PlantableAreaComponent

PlantableAreaComponent.id = "plantable_area"

function PlantableAreaComponent:load(layer, map, player, camera)
    PlantableTileComponent = require("src.components.areas.PlantableTileComponent")

    local self = setmetatable({}, PlantableAreaComponent)
    self.map = map
    self.layer = layer
    self.map_scale = TILE_SCALE
    self.player = player
    self.camera = camera

    self.plantable_areas = self:create_triggers()
    self.current_area = nil

    return self
end

function PlantableAreaComponent:create_triggers()
    local plantable_areas = {}

    for y = 1, self.layer.height do
        for x = 1, self.layer.width do
            if self.layer.data[y][x] and self.layer.data[y][x].gid > 0 then
                local plantable_tile = PlantableTileComponent:load(
                    current_world,
                    (x - 1) * self.map.tilewidth * self.map_scale,
                    (y - 1) * self.map.tileheight * self.map_scale,
                    self.map.tilewidth * self.map_scale,
                    self.map.tileheight * self.map_scale,
                    self.layer.data[y][x].gid
                )
                table.insert(plantable_areas, plantable_tile)
            end
        end
    end

    return plantable_areas
end

function PlantableAreaComponent:update_between_day(dt)
    -- plant update
    if self.plantable_areas then
        for _, area in ipairs(self.plantable_areas) do
            if area.plant then
                area.plant:update(dt)
                if area.is_watered then
                    area.plant.properties.is_watered = false
                end
            end
            area.is_watered = false
        end
    end
end

function PlantableAreaComponent:update(dt)
    local item = self.player.current_item
    if self.plantable_areas then
        local mouse_x, mouse_y = self.camera:mousePosition()
        local mouse_distance = distance_between(mouse_x, mouse_y, self.player.sensor_point.x, self.player.sensor_point.y)

        for _, area in ipairs(self.plantable_areas) do

            if is_inside(mouse_x, mouse_y, area) and mouse_distance <= area.width * 2 then
                area.is_active = true
                self.current_area = area
                if is_mouse_down(1) then
                    if item then
                        if item.properties.type == "tool" then
                            if item.tool_id == "water_can" and self.current_area.is_soiled then
                                item:water(area)
                            end
                            if item.id == "hoe" then
                                item:soil(area)
                            end
                        end
                        if item.properties.type == "seed" and self.current_area.is_soiled then
                            area:plant_crop(item)
                            break
                        end
                    end
                end
                if is_mouse_down(2) then
                    if area.plant and area.plant.properties.can_harvest then
                        local can_havest = false
                        for _, slot in ipairs(self.player.slot_bar.slots) do
                            local crop = area.plant.properties:harvest(slot.x, slot.y)
                            if slot.item and slot.item.id == crop.id  and slot.item_amount < slot.capacity then
                                slot.item_amount = slot.item_amount + 1
                                can_havest = true
                                break
                            end
                        end

                        if not can_havest then
                            for _, slot in ipairs(self.player.slot_bar.slots) do
                                local crop = area.plant.properties:harvest(slot.x, slot.y)
                                if not slot.item then
                                    slot:store_item(crop, 1, SLOT_CAPACITY)
                                    break
                                end
                            end
                        end

                        area:reset_area()
                        break
                    end
                end
            else
                area.is_active = false
            end

            area:update(dt)
        end

    end
end

function PlantableAreaComponent:paint_area(area, red, green, blue, alpha)
    set_color(red, green, blue, alpha)
    local adjust_factor = 0.8
    local x, y, width, height = area.x, area.y, area.width, area.height
    local s_width = width * adjust_factor  -- scaled width
    local s_height = height * adjust_factor  -- scaled height

    if area.gid == 105 then        -- top-left corner
        x = x + (width - s_width)
        y = y + (height - s_height)
        width, height = s_width, s_height
    elseif area.gid == 107 then    -- side top
        y = y + (height - s_height)
        height = s_height
    elseif area.gid == 108 then    -- top-right corner
        y = y + (height - s_height)
        width, height = s_width, s_height
    elseif area.gid == 132 then    -- side right
        width = s_width
    elseif area.gid == 144 then    -- bottom-right corner
        width, height = s_width, s_height
    elseif area.gid == 142 then    -- side bottom
        height = s_height
    elseif area.gid == 141 then    -- bottom-left corner
        x = x + (width - s_width)
        width, height = s_width, s_height
    elseif area.gid == 117 then    -- side left
        x = x + (width - s_width)
        width = s_width
    end

    love.graphics.rectangle("fill", x, y, width, height)
    reset_color()
end

function PlantableAreaComponent:draw()
    local item = self.player.current_item
    if self.plantable_areas  then
        for _, area in ipairs(self.plantable_areas) do
            if area == self.current_area and area.is_active and (item and item.id == "hoe" or area.is_soiled) then
                set_color(73, 59, 47, 0.9)
                love.graphics.setLineWidth(height_scale(TILE_SCALE))
                love.graphics.rectangle("line", area.x, area.y, area.width, area.height)
                reset_color()
            end

            if area.is_watered then
                self:paint_area(area, 73, 59, 47, 0.5)
            end
            if area.is_soiled then
                self:paint_area(area, 73, 59, 47, 0.5)
            end

            if area.is_planted and area.plant then
                area.plant:draw()
            end

        end
    end
end

return PlantableAreaComponent