local Player = {}
Player.__index = Player

function Player:load(x, y, interface)
    AnimComponent = require("src.components.AnimComponent")
    SpriteComponent = require("src.components.SpriteComponent")
    anim8 = require("libraries.anim8")

    local self = setmetatable({}, Player)
    self.sprite = SpriteComponent:load(x, y)
    self.sprite.sprites.idle = AnimComponent:load("sprites/player/player_idle.png", 10, 3, 0.1, "rows")
    self.sprite.sprites.walk = AnimComponent:load("sprites/player/player_walk.png", 10, 3, 0.1, "rows")
    self.sprite.offset.x = self.sprite.sprites.idle.frame_width / 2
    self.sprite.offset.y = self.sprite.sprites.idle.frame_height / 2

    self.speed = height_scale(5000)
    self.acc = 0
    self.acc_max = height_scale(10000)

    self.facing_index = 1

    self.states = {}
    self.states.moving = false

    self.collider = self:set_collider()

    self.sensor_point = self:set_sensor_point()

    self.interface = interface

    self.slot_bar = interface.slot_bar

    self.current_item = self:set_current_item()

    self.map = nil

    return self
end

function Player:set_current_item()
    if self.slot_bar then
        for _, slot in ipairs(self.slot_bar.slots) do
            if slot.is_selected then
                return slot.item
            end
        end
    end
end

function Player:set_map(map)
    self.map = map or nil
end

function Player:set_collider()
    local collider = {}
    collider.id = "player"
    collider.width = (self.sprite.sprites.idle.frame_width - 7) * self.sprite.sprite_scale
    collider.height = (self.sprite.sprites.idle.frame_height/2 - 7) * self.sprite.sprite_scale
    collider.x = self.sprite.x
    collider.y = self.sprite.y

    collider.body = love.physics.newBody(current_world, collider.x, collider.y, "dynamic")
    collider.shape = love.physics.newRectangleShape(0, (collider.height + 9), collider.width, collider.height)
    collider.fixture = love.physics.newFixture(collider.body, collider.shape)
    collider.body:setFixedRotation(true)
    collider.fixture:setUserData(collider)

    entities[collider.id] = true

    return collider
end

function Player:set_sensor_point()
    local sensor_point = {}
    sensor_point.x = self.sprite.x
    sensor_point.y = self.sprite.y + (self.sprite.sprites.idle.frame_height / 2 + self.sprite.sprite_scale) * self.sprite.sprite_scale

    return sensor_point
end

function Player:update(dt)
    local dx, dy = 0, 0

    self.states.moving = false
    self.sprite.flip.x = 1

    if is_key_down("s") then
        dy = 1

        self.sprite.sprites.walk.current_anim = self.sprite.sprites.walk.anims[1]
        self.facing_index = 1
        self.states.moving = true
    end
    if is_key_down("w") then
        dy = -1

        self.sprite.sprites.walk.current_anim = self.sprite.sprites.walk.anims[2]
        self.facing_index = 2
        self.states.moving = true
    end
    if is_key_down("d") then
        dx = 1

        self.sprite.sprites.walk.current_anim = self.sprite.sprites.walk.anims[3]
        self.facing_index = 3
        self.states.moving = true
    end
    if is_key_down("a") then
        dx = -1

        self.sprite.sprites.walk.current_anim = self.sprite.sprites.walk.anims[3]
        self.facing_index = 4
        self.states.moving = true
        self.sprite.flip.x = -1
    end

    if is_key_down("lshift") or is_key_down("rshift") then
        self.acc = math.min(self.acc + 100000 * dt, self.acc_max)
        self.speed = 10000 + self.acc
    else
        self.speed = 10000
        self.acc = 0
    end

    self:normalized_move(dx, dy, dt)

    if self.states.moving == false then
        if self.facing_index == 4 then
            self.sprite.sprites.idle.current_anim = self.sprite.sprites.idle.anims[3]
            self.sprite.flip.x = -1
        else
            self.sprite.sprites.idle.current_anim = self.sprite.sprites.idle.anims[self.facing_index]
        end

         self.sprite.sprites.idle.current_anim:update(dt)
    else
        self.sprite.sprites.walk.current_anim:update(dt)
    end

    self.current_item = self:set_current_item()
end

function Player:update_between_day(dt)
    self.states.moving = false

    if self.facing_index == 4 then
            self.sprite.sprites.idle.current_anim = self.sprite.sprites.idle.anims[3]
            self.sprite.flip.x = -1
        else
            self.sprite.sprites.idle.current_anim = self.sprite.sprites.idle.anims[self.facing_index]
        end
end

function Player:normalized_move(dx, dy, dt)
    local vector_size = math.sqrt(dx * dx + dy * dy)
    if vector_size > 0 then
        dx = dx / vector_size
        dy = dy / vector_size
    end

    local vx = dx * self.speed * dt
    local vy = dy * self.speed * dt

    self.collider.body:setLinearVelocity(vx, vy)
    self.collider.body:setFixedRotation(true)

    if self.map then
        local x, y = self.collider.body:getPosition()
        local player_width = self.collider.width
        local player_height = self.collider.height + 9*self.sprite.sprite_scale

        x = clamp(x, self.map.x + player_width, self.map.x + self.map.width  - player_width)
        y = clamp(y, self.map.y + player_height, self.map.y + self.map.height - player_height)
        self.collider.body:setPosition(x, y)
    end

    self.sprite.x, self.sprite.y = self.collider.body:getPosition()

    self.sensor_point.x = self.sprite.x
    self.sensor_point.y = self.sprite.y + (self.sprite.sprites.idle.frame_height / 2 + self.sprite.sprite_scale) * self.sprite.sprite_scale
end

function Player:draw()
    if self.states.moving == true then
        self.sprite:draw(self.sprite.sprites.walk)
    else
        self.sprite:draw(self.sprite.sprites.idle)
    end
end

return Player
