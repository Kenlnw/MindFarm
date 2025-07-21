local PlantableAreaComponent = {}
PlantableAreaComponent.__index = PlantableAreaComponent

PlantableAreaComponent.id = "plantable_area"

function PlantableAreaComponent:load(world, layer, map, player, camera)
    PlantableTileComponent = require("src.components.areas.PlantableTileComponent")

    local self = setmetatable({}, PlantableAreaComponent)
    self.map = map
    self.world = world
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
                    self.world,
                    (x - 1) * self.map.tilewidth * self.map_scale,
                    (y - 1) * self.map.tileheight * self.map_scale,
                    self.map.tilewidth * self.map_scale,
                    self.map.tileheight * self.map_scale
                )
                table.insert(plantable_areas, plantable_tile)
            end
        end
    end

    return plantable_areas
end

function PlantableAreaComponent:update(dt)
    if self.plantable_areas then
        local mouse_x, mouse_y = self.camera:mousePosition()
        local mouse_distance = distance_between(mouse_x, mouse_y, self.player.sensor_point.x, self.player.sensor_point.y)

        for _, area in ipairs(self.plantable_areas) do
            if area.plant then
                area.plant:update(dt)
            end

            if is_inside(mouse_x, mouse_y, area) and mouse_distance <= area.width * 2 then
                area.is_active = true
                self.current_area = area
            else
                area.is_active = false
            end

            area:update()
        end

        if is_mouse_down(1) then
            self:interact_left_click()
            -- mouse_clear_state(1)
        end
        if is_mouse_down(2) then
            self:interact_right_click()
            -- mouse_clear_state(2)
        end

    end
end

function PlantableAreaComponent:interact_left_click()
    for _, area in ipairs(self.plantable_areas) do
        if area.is_active == false then
            goto continue
        end

        if self.player.current_item then
            if self.player.current_item.id == "water_can" then
                self.player.current_item:water(area)
            end
            if self.player.current_item.properties.is_plantable then
                area:plant_crop(self.player.current_item)
                break
            end
        end

        ::continue::
    end
end

function PlantableAreaComponent:interact_right_click()
    for _, area in ipairs(self.plantable_areas) do

        if area.is_active and area.plant and area.plant.properties.can_harvest then
            for _, slot in ipairs(self.player.slot_bar.slots) do
                local crop = area.plant.properties:harvest(slot.x, slot.y)
                if not slot.item or (slot.item_amount < slot.capacity and slot.item.id == crop.id) then
                    -- crop.sprite.x, crop.sprite.y = slot.x, slot.y
                    slot:store_item(crop, 1)
                    break
                end
            end
            area:reset_area()
            break
        end

    end
end

function PlantableAreaComponent:draw()
    if self.plantable_areas  then
        for _, area in ipairs(self.plantable_areas) do
            if area == self.current_area and area.is_active then
                set_color(0, 0, 0)
                love.graphics.rectangle("line", area.x, area.y, area.width, area.height)
                reset_color()
            end

            if area.is_watered then
                set_color(67, 148, 176, 0.5)
                love.graphics.rectangle("fill", area.x, area.y, area.width, area.height)
                reset_color()
            end
            if area.is_planted and area.plant then
                area.plant:draw()
            end

        end
    end
end

return PlantableAreaComponent
