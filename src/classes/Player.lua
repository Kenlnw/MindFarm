local Player = {}
Player.__index = Player

function Player:load(world, x, y, interface)
    AnimComponent = require("src.components.AnimComponent")
    anim8 = require("libraries.anim8")
    require("src.utils")

    local self = setmetatable({}, Player)

    self.world = world
    self.x = x
    self.y = y
    self.speed = 10000
    self.acc = 0
    self.acc_max = 20000

    self.anim_duration = 0.1
    self.sprite_scale = TILE_SCALE
    self.sprite_offset = 7

    self.sprites = {}
    self.sprites.idle = AnimComponent:load("sprites/player_idle.png", 4, 3, 0.2, "rows")
    self.sprites.walk = AnimComponent:load("sprites/player_walk.png", 6, 3, 0.1, "rows")

    self.facing_index = 1
    self.flip_x = 1
    self.flip_y = 1
    self.offset_x = self.sprites.idle.frame_width / 2
    self.offset_y = self.sprites.idle.frame_height / 2

    self.states = {}
    self.states.moving = false

    self.collider = {}
    self:set_collider()

    self.sensor_point = {}
    self:set_sensor_point()

    self.slot_bar = interface.slot_bar

    return self
end

function Player:set_collider()
    self.collider.id = "player"
    self.collider.width = self.sprites.idle.frame_width / 3 * self.sprite_scale
    self.collider.height = self.sprites.idle.frame_height / 3 * self.sprite_scale
    self.collider.x = self.x
    self.collider.y = self.y

    self.collider.body = love.physics.newBody(self.world, self.collider.x, self.collider.y, "dynamic")
    self.collider.shape = love.physics.newRectangleShape(0, self.collider.height / 2, self.collider.width,
        self.collider.height)
    self.collider.fixture = love.physics.newFixture(self.collider.body, self.collider.shape)
    self.collider.body:setFixedRotation(true)
end

function Player:set_sensor_point()
    self.sensor_point.x = self.x
    self.sensor_point.y = self.y + (self.sprites.idle.frame_height / 2 - self.sprite_offset) * self.sprite_scale
end

function Player:update(dt)
    local dx, dy = 0, 0

    self.states.moving = false
    self.flip_x = 1

    if love.keyboard.isDown("s") then
        dy = 1

        self.sprites.walk.current_anim = self.sprites.walk.anims[1]
        self.facing_index = 1
        self.states.moving = true
    end
    if love.keyboard.isDown("w") then
        dy = -1

        self.sprites.walk.current_anim = self.sprites.walk.anims[2]
        self.facing_index = 2
        self.states.moving = true
    end
    if love.keyboard.isDown("d") then
        dx = 1

        self.sprites.walk.current_anim = self.sprites.walk.anims[3]
        self.facing_index = 3
        self.states.moving = true
    end
    if love.keyboard.isDown("a") then
        dx = -1

        self.sprites.walk.current_anim = self.sprites.walk.anims[3]
        self.facing_index = 4
        self.states.moving = true
        self.flip_x = -1
    end

    if love.keyboard.isDown("lshift") then
        if self.acc >= self.acc_max then
            self.acc = self.acc_max
        else
            self.acc = self.acc + 1000
        end
        self.speed = 10000 + self.acc
    else
        self.speed = 10000
        self.acc = 0
    end

    self:normalized_move(dx, dy, dt)

    if self.states.moving == false then
        if self.facing_index == 4 then
            self.sprites.idle.current_anim = self.sprites.idle.anims[3]
            self.flip_x = -1
        else
            self.sprites.idle.current_anim = self.sprites.idle.anims[self.facing_index]
        end

         self.sprites.idle.current_anim:update(dt)
    else
        self.sprites.walk.current_anim:update(dt)
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

    self.x, self.y = self.collider.body:getPosition()

    self.sensor_point.x = self.x
    self.sensor_point.y = self.y + (self.sprites.idle.frame_height / 2 - self.sprite_offset) * self.sprite_scale
end

function Player:draw()

    if self.states.moving == true then
        self.sprites.walk:draw_anim(self)
    else
        self.sprites.idle:draw_anim(self)
    end
    -- love.graphics.circle("fill", self.sensor_point.x, self.sensor_point.y, 10)
end

return Player
