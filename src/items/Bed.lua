local Bed = {}
Bed.__index = Bed

function Bed:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")
    BedEntity = require("src.entities.BedEntity")

    local self = setmetatable({}, Bed)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Bed.png", 1, 4, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[4]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = {}
    self.properties.type = "placeable_item"
    self.properties.can_show_entity = true
    self.properties.is_showed = false
    self.properties.is_used = false
    self.properties.entity = BedEntity:load()

    return self
end

function Bed:show_object()
    local mouse_x, mouse_y = love.mouse:getPosition()
    local entity_width = self.properties.entity.sprite.sprites.frame_width * TILE_SCALE
    local entity_height = self.properties.entity.sprite.sprites.frame_height * TILE_SCALE

    self.properties.entity.sprite:update_position(mouse_x - entity_width / 2, mouse_y - entity_height / 2)
    self.properties.is_showed = true
end

function Bed:place()
    local entity_width = self.properties.entity.sprite.sprites.frame_width * TILE_SCALE
    local entity_height = self.properties.entity.sprite.sprites.frame_height * TILE_SCALE

    self.properties.is_used = true
    -- self.properties.entity.sprite:update_position(mouse_position.x - entity_width / 2, mouse_position.y - entity_height / 2)
end

function Bed:update(dt)
    -- self:show_object()
end

function Bed:draw()
    self.sprite:draw(self.sprite.sprites)
    if self.properties.is_showed then
        self.properties.entity:draw()
    end
end

return Bed