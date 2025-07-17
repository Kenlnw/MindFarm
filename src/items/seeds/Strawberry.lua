local Strawberry = {}
Strawberry.__index = Strawberry

Strawberry.id = "strawberry"
Strawberry.is_plantable = true

function Strawberry:load(x, y, frame, flip_x, flip_y, state)
    AnimComponent = require("src.components.AnimComponent")
    local self = setmetatable({}, Strawberry)
    self.x = x or 0
    self.y = y or 0
    self.sprite_scale = TILE_SCALE
    self.state = state

    self.sprites = AnimComponent:load("sprites/Strawberry.png",6, 3, 1, "rows")

    if self.state == "seed" then
        self.sprites.current_anim = self.sprites.anims[1]
        self.sprites.current_anim:gotoFrame(1)
    elseif self.state == "crop" then
        self.sprites.current_anim = self.sprites.anims[2]
    elseif self.state == "fruit" then
        self.sprites.current_anim = self.sprites.anims[3]
        self.sprites.current_anim:gotoFrame(1)
    end

    self.frame = frame or 8
    self.flip_x =  flip_x or 1
    self.flip_y = flip_y or 1
    self.offset_x = 0
    self.offset_y = 0

    self.is_watered = false
    self.days_to_grow = 6
    self.started_day = DAYS
    self.growing_state = 0

    self.can_harvest = false

    return self
end

function Strawberry:update(dt)
    if self.state == "crop" then
        if self.frame == self.days_to_grow then
            self.can_harvest = true
        end
        if self.is_watered then
            self:grow()
        end
        self.sprites.current_anim:gotoFrame(self.frame)
    end
    -- self.sprites.current_anim:update(dt)
end

function Strawberry:grow()
    if DAYS - self.started_day < self.days_to_grow  then
        self.frame = DAYS - self.started_day + 1
    end
end

function Strawberry:draw()
    if self.flip_x == -1 then
        self.offset_x = self.sprites.frame_width
    end
    if self.flip_y == -1 then
        self.offset_y = self.sprites.frame_height
    end

    if self.can_harvest then
        set_color(255, 0, 0)
        love.graphics.rectangle("line", self.x, self.y, self.sprites.frame_width * self.sprite_scale, self.sprites.frame_height * self.sprite_scale)
        reset_color()
    end

    self.sprites:draw_anim(self)
end

return Strawberry