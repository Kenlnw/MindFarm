local EntityComponent = {}
EntityComponent.__index = EntityComponent

function EntityComponent:load(sprite)
    local self = setmetatable({}, EntityComponent)

    self.type = "entity"
    self.is_cannot_place = false
    self.is_placed = false
    self.is_activated = false

    self.area = nil
    if current_world then
        self.area = self:set_collider(sprite)
    end

    return self
end

function EntityComponent:set_collider(sprite)
    local area = {}
    area.id = nil
    area.body = love.physics.newBody(current_world, sprite.x, sprite.y, "kinematic")
    area.shape = love.physics.newRectangleShape(sprite.width / 2, sprite.height / 2, sprite.width, sprite.height)
    area.body:setFixedRotation(true)
    area.fixture = nil

    return area
end

function EntityComponent:update_collider_position(sensor_state, area_id)
    if self.area and not self.area.fixture then
        self.area.fixture = love.physics.newFixture(self.area.body, self.area.shape)
        self.area.fixture:setSensor(sensor_state)

        if self.is_placed then
            self.area.id = area_id
            entities[self.area.id] = true
        end
        self.area.fixture:setUserData(self.area)

    end
end

function EntityComponent:update(dt, sprite, func)
    if self.area and self.area.fixture then
        if not self.is_placed then
            self.area.body:setPosition(sprite.x, sprite.y)
        end

        local tl = { x = sprite.x, y = sprite.y }
        local br = { x = sprite.x + sprite.width, y = sprite.y + sprite.height }

        self.is_cannot_place = false
        self.is_activated = false

        current_world:queryBoundingBox(tl.x, tl.y, br.x, br.y, function(fixture)
        if entities[fixture:getUserData().id] then
            self.is_cannot_place = true
            if self.is_placed and fixture:getUserData().id == "player" then
                self.is_activated = true
                func()
            end
            return false
        end
        return true
        end)
    end
end

function EntityComponent:draw(sprite)
    if not self.is_placed then
        if self.is_cannot_place then
            set_color(255, 0, 0, 0.7)
        else
            set_color(255, 255, 255, 0.7)
        end
    end

    if sprite then
        sprite:draw(sprite.sprites)
    end
    reset_color()

    if self.is_activated then
        love.graphics.circle("fill", sprite.x + sprite.width / 2, sprite.y + sprite.height / 2, 10)
    end
end

return EntityComponent