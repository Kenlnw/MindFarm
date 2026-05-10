local BedEntity = {}
BedEntity.__index = BedEntity

BedEntity.id = "bed_entity"

function BedEntity:load(x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")
    EntityComponent = require("src.components.items.EntityComponent")

    local self = setmetatable({}, BedEntity)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/entities/Bed.png", 1, 2, 1, "rows")
    self.sprite:set_size(self.sprite.sprites:get_size())
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.properties = EntityComponent:load(self.sprite, "Bed")

    return self
end

function BedEntity:update(dt)
    self.properties:update(dt, self.sprite, function()
        if is_mouse_down(2) then
            day_changed = true
            mouse_clear_state(2)
        end
    end)
end

function BedEntity:draw()
    self.properties:draw(self.sprite)
end

return BedEntity
