local Player = {}
Player.__index = Player

function Player:load(world, x, y)
    AnimComponent = require("src.components.AnimComponent")
    anim8 = require("libraries.anim8")

    local self = setmetatable({}, Player)

    self.world = world
    self.x = x
    self.y = y
    self.speed = 10000
    
    self.anim_duration = 0.1
    self.sprite_scale = 4
    self.sprite_offset = 7

    self.sprites = {idle, walk}

    self.sprites.idle = {
        sprite_sheet = love.graphics.newImage("sprites/player_idle.png"),
        columns = 4,
        rows = 3,
        duration = 0.2

    }
    self.sprites.idle.anim = AnimComponent:load(self.sprites.idle)
    self.sprites.idle.anim:create_frames("rows")

    self.sprites.walk = {
        sprite_sheet = love.graphics.newImage("sprites/player_walk.png"),
        columns = 6,
        rows = 3,
        duration = 0.1
    }
    self.sprites.walk.anim = AnimComponent:load(self.sprites.walk)
    self.sprites.walk.anim:create_frames("rows")

    self.current_anim = self.sprites.idle.anim.anims[1]

    self.facing_index = 1
    self.flip_x = 1

    self.states = {}
    self.states.moving = false

    self.collider = {}
    self.collider.tag = "player"
    self.collider.width = self.sprites.idle.anim.frame_width/2 * self.sprite_scale
    self.collider.height = self.sprite_offset * self.sprite_scale
    self.collider.x = self.x
    self.collider.y = self.y

    self.collider.body = love.physics.newBody(self.world, self.collider.x, self.collider.y, "dynamic")
    self.collider.shape = love.physics.newRectangleShape(
        self.collider.width/2 - self.sprite_offset * self.sprite_scale, 
        self.collider.height, 
        self.collider.width, 
        self.collider.height
    )
    self.collider.fixture = love.physics.newFixture(self.collider.body, self.collider.shape)
    self.collider.body:setFixedRotation(true)
    self.collider.fixture:setUserData(self.collider)

    self.sensor_point = {}
    self.sensor_point.x = self.x
    self.sensor_point.y = self.y + (self.sprites.idle.anim.frame_height/2 - self.sprite_offset) * self.sprite_scale
    
    return self
end

function Player:update(dt)
    local dx, dy = 0, 0

    self.states.moving = false
    self.flip_x = 1

    if love.keyboard.isDown("s") then
        dy = 1

        self.current_anim = self.sprites.walk.anim.anims[1]
        self.facing_index = 1
        self.states.moving = true
    end
    if love.keyboard.isDown("w") then
        dy = -1

        self.current_anim = self.sprites.walk.anim.anims[2]
        self.facing_index = 2
        self.states.moving = true
    end
    if love.keyboard.isDown("d") then
        dx = 1

        self.current_anim = self.sprites.walk.anim.anims[3]
        self.facing_index = 3
        self.states.moving = true  
    end
    if love.keyboard.isDown("a") then
        dx = -1

        self.current_anim = self.sprites.walk.anim.anims[3]
        self.facing_index = 4
        self.states.moving = true
        self.flip_x = -1
    end

    self:normalized_move(dx, dy, dt)

    if self.states.moving == false then
        if self.facing_index == 4 then
            self.current_anim = self.sprites.idle.anim.anims[3]
            self.flip_x = -1
        else
            self.current_anim = self.sprites.idle.anim.anims[self.facing_index]
        end
    end

    self.current_anim:update(dt)

end

function Player:normalized_move(dx, dy, dt)
    local vector_size = math.sqrt(dx*dx + dy*dy)
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
    self.sensor_point.y = self.y + (self.sprites.idle.anim.frame_height/2 - self.sprite_offset) * self.sprite_scale
end

function Player:draw_anim(sprite_sheet)
    self.current_anim:draw(
            sprite_sheet, 
            self.x, 
            self.y, 
            nil, 
            self.sprite_scale * self.flip_x, 
            self.sprite_scale, 
            self.sprites.walk.anim.frame_width/2,
            self.sprites.walk.anim.frame_height/2
        )
end

function Player:draw()

    if self.states.moving == true then
        self:draw_anim(self.sprites.walk.sprite_sheet)
    else
        self:draw_anim(self.sprites.idle.sprite_sheet)
    end

    -- love.graphics.circle("fill", self.sensor_point.x, self.sensor_point.y, 10)
end

return Player