local PlaceableAreaComponent = {}
PlaceableAreaComponent.__index = PlaceableAreaComponent

function PlaceableAreaComponent:load(layer, map, player, camera)
    PlaceableTileComponent = require("src.components.areas.PlaceableTileComponent")

    local self = setmetatable({}, PlaceableAreaComponent)
    self.map = map
    self.layer = layer
    self.map_scale = TILE_SCALE
    self.player = player
    self.camera = camera

    self.placeable_areas = self:create_triggers()
    self.current_area = nil

    return self
end

function PlaceableAreaComponent:create_triggers()
    local placeable_areas = {}

    for y = 1, self.layer.height do
        for x = 1, self.layer.width do
            if self.layer.data[y][x] and self.layer.data[y][x].gid > 0 then
                local placeable_tile = PlaceableTileComponent:load(
                    current_map,
                    (x - 1) * self.map.tilewidth * self.map_scale,
                    (y - 1) * self.map.tileheight * self.map_scale,
                    self.map.tilewidth * self.map_scale,
                    self.map.tileheight * self.map_scale
                )
                table.insert(placeable_areas, placeable_tile)
            end
        end
    end

    return placeable_areas
end

function PlaceableAreaComponent:update(dt)
    local mouse_x, mouse_y = self.camera:mousePosition()

    if self.placeable_areas then
        for _, area in ipairs(self.placeable_areas) do
            if is_inside(mouse_x, mouse_y, area) then
                area.is_active = true
                if self.player.current_item and self.player.current_item.properties.type == "placeable_item" and not area.entity then
                    if is_mouse_down(1) then
                        area.entity = self.player.current_item:place(current_map, area.x, area.y)
                        mouse_clear_state(1)
                    else
                        self.player.current_item:show_object(area.x, area.y)
                    end
                end

            else
                area.is_active = false
            end

            area:update()
        end
    end
end

function PlaceableAreaComponent:draw()
    if self.placeable_areas  then
        for _, area in ipairs(self.placeable_areas) do
            if area.entity then
                area.entity:draw()
            else
                if area.is_active then
                    if self.player.current_item and self.player.current_item.properties.type == "placeable_item" then
                        self.player.current_item.properties.entity:draw()
                        love.graphics.rectangle("line", area.x, area.y, area.width, area.height)
                        reset_color()
                    end
                end
            end


        end
    end
end

return PlaceableAreaComponent