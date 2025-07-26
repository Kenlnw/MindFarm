local BedEntity = {}
BedEntity.__index = BedEntity

function BedEntity:load(world, x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")

    local self = setmetatable({}, BedEntity)
    current_map = world or nil

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Bed.png", 1, 2, 1, "rows")
    self.sprite:set_size(self.sprite.sprites:get_size())
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    if current_map  then
        self.area = self:set_area()
    end

    return self
end

function BedEntity:set_area()
    local area = {}
    area.body = love.physics.newBody(current_map, self.sprite.x, self.sprite.y, "static")
    area.shape = love.physics.newRectangleShape(self.sprite.width / 2, self.sprite.height / 2, self.sprite.width, self.sprite.height)
    area.fixture = love.physics.newFixture(area.body, area.shape)
    area.body:setFixedRotation(true)
    area.fixture:setSensor(false)

    return area
end

function BedEntity:update(dt)

end

function BedEntity:draw()
    self.sprite:draw(self.sprite.sprites)
end

return BedEntity
