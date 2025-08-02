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
    self.properties.is_used = false
    -- self.properties.is_showed = false
    self.properties.entity = BedEntity:load(current_world)

    return self
end

function Bed:show_object(x, y)
    -- self.properties.is_showed = true
    self.properties.entity.sprite:update_position(x, y)
    self.properties.entity:updateColliderPosition(true)
end

function Bed:place(world, x, y)
    if self.properties.entity.properties.is_cannot_place then
        return nil
    end

    self.properties.is_used = true
    local bed_entity = BedEntity:load(world, x, y)
    bed_entity:updateColliderPosition(false)
    return bed_entity
end


function Bed:update(dt)
    -- self.properties.is_showed = false
    if self.properties.entity.area.fixture then
        -- print("have tgood")
    end
    self.properties.entity:update(dt)

    -- if not self.properties.is_showed then
    --     self.properties.entity:deleteCollider()
    -- end
end

function Bed:draw()
    self.sprite:draw(self.sprite.sprites)
end

return Bed