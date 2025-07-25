local PlaceableAreaComponent = {}
PlaceableAreaComponent.__index = PlaceableAreaComponent

function PlaceableAreaComponent:load(world, layer, map, player, camera)
    PlaceableTileComponent = require("src.components.areas.PlaceableTileComponent")

    local self = setmetatable({}, PlaceableAreaComponent)
    self.map = map
    self.world = world
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
                    self.world,
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
        local entity = { x = -1, y = -1, width = -1, height = -1 }
        -- if self.player.current_item and self.player.current_item.properties.type == "placeable_item" then
        --     entity.x = mouse_x
        --     entity.y = mouse_y - self.player.current_item.properties.entity.sprite.sprites.frame_height / 2 * TILE_SCALE
        --     entity.width = self.player.current_item.properties.entity.sprite.sprites.frame_width * TILE_SCALE
        --     entity.height = self.player.current_item.properties.entity.sprite.sprites.frame_height * TILE_SCALE
        -- end

        for _, area in ipairs(self.placeable_areas) do
            if is_inside(mouse_x, mouse_y, area) then
                area.is_active = true
                if is_mouse_down(1) then
                    if self.player.current_item and self.player.current_item.properties.type == "placeable_item" and not area.entity then
                        area.entity = self.player.current_item:place(area.x, area.y)
                    end
                    mouse_clear_state(1)
                end
            else
                area.is_active = false
            end

            area:update()
        end

        -- if is_mouse_down(2) then
        --     self:interact_right_click()
        -- end

    end
end

function PlaceableAreaComponent:interact_left_click()
    for _, area in ipairs(self.placeable_areas) do
         if self.player.current_item and self.player.current_item.properties.type == "placeable_item" and area.is_active then
            area.is_placed = true
            area.entity = self.player.current_item:place(area.x, area.y)
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
                        self.player.current_item:show_object(area.x, area.y)
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