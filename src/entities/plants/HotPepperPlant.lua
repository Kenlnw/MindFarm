local HotPepperPlant = {}
HotPepperPlant.__index = HotPepperPlant

HotPepperPlant.id = "hot_pepper_plant"

function HotPepperPlant:load(x, y, flip_x, flip_y)
    HotPepper = require("src.items.crops.HotPepper")
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    PlantComponent = require("src.components.items.PlantComponent")

    local self = setmetatable({}, HotPepperPlant)

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/crops/HotPepper.png", 7, 3, 1, "rows")
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[2]

    self.properties = PlantComponent:load(HotPepper, 6)

    self.properties:set_regrow(4, 6, 7)

    return self
end

function HotPepperPlant:update(dt)
    if self.properties.regrow_activate then
        if self.properties.can_harvest then
            self.sprite.sprites.current_anim:gotoFrame(self.properties.harvest_state)
        end
    else
        self.sprite.sprites.current_anim:gotoFrame(self.properties.growing_state)
    end

    self.properties:update(dt)
end

function HotPepperPlant:draw()
    self.sprite:draw(self.sprite.sprites)
end

return HotPepperPlant