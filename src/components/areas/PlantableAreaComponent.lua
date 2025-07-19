local PlantableAreaComponent = {}
PlantableAreaComponent.__index = PlantableAreaComponent

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
            local data = self.layer.data[y][x]
            if data then
                if data.gid > 0 then
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
    end

    return plantable_areas
end

function PlantableAreaComponent:update(dt)
    if self.plantable_areas then
        local mouse_x, mouse_y = self.camera:mousePosition()
        local mouse_distance =
            distance_between(mouse_x, mouse_y, self.player.sensor_point.x, self.player.sensor_point.y)

        for _, area in ipairs(self.plantable_areas) do
            if area.crop then
                area.crop:update(dt)
            end

            if is_inside(mouse_x, mouse_y, area) and mouse_distance <= area.width * 2 then
                area.is_active = true
                self.current_area = area
            else
                area.is_active = false
            end
        end
    end
end

function PlantableAreaComponent:interact_left_click()
    for _, area in ipairs(self.plantable_areas) do
        if area.is_active == false then
            goto continue
        end

        if self.player.water_can and area.crop then
            area.is_watered = true
            area.crop.properties.is_watered = true
        end
        if self.player.current_item and self.player.current_item.properties.is_plantable then
            area:plant_crop(self.player.current_item)
            break
        end
        ::continue::
    end
end

function PlantableAreaComponent:interact_right_click()
    for _, area in ipairs(self.plantable_areas) do

        if area.is_active and area.crop and area.crop.properties.can_harvest then
            for _, slot in ipairs(self.player.slot_bar.slots) do
                if not slot.item or slot.item_amount < slot.capacity then
                    slot:store_item(area.crop.properties:harvest(slot.x, slot.y), 1)
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
                love.graphics.rectangle("fill", area.x, area.y, area.width, area.height)
            end
            if area.is_planted and area.crop then
                area.crop:draw()
            end

        end
    end
end

return PlantableAreaComponent
