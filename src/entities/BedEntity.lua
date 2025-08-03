local BedEntity = {}
BedEntity.__index = BedEntity

function BedEntity:load(world, x, y, flip_x, flip_y)
    SpriteComponent = require("src.components.SpriteComponent")
    AnimComponent = require("src.components.AnimComponent")

    local self = setmetatable({}, BedEntity)
    current_world = world or nil

    self.sprite = SpriteComponent:load(x, y, flip_x, flip_y)
    self.sprite.sprites = AnimComponent:load("sprites/items/Bed.png", 1, 2, 1, "rows")
    self.sprite:set_size(self.sprite.sprites:get_size())
    self.sprite.sprites.current_anim = self.sprite.sprites.anims[1]
    self.sprite.sprites.current_anim:gotoFrame(1)

    self.area = nil

    if current_world  then
        self.area = self:set_collider()
    end

    self.properties = {}
    self.properties.is_cannot_place = false
    self.properties.is_placed = false
    self.properties.is_activated = false

    return self
end

function BedEntity:set_collider()
    local area = {}
    area.id = nil
    area.body = love.physics.newBody(current_world, self.sprite.x, self.sprite.y, "kinematic")
    area.shape = love.physics.newRectangleShape(self.sprite.width / 2, self.sprite.height / 2, self.sprite.width, self.sprite.height)
    area.body:setFixedRotation(true)
    area.fixture = nil

    return area
end

function BedEntity:updateColliderPosition(sensor_state)
    if self.area and not self.area.fixture then
        self.area.fixture = love.physics.newFixture(self.area.body, self.area.shape)
        self.area.fixture:setSensor(sensor_state)

        if not sensor_state then
            self.area.id = "bed"
            entities[self.area.id] = true
        end
        self.area.fixture:setUserData(self.area)

    end
end

function BedEntity:update(dt)
    if self.area.fixture then
      print("Locked in")
      self.area.body:setPosition(self.sprite.x, self.sprite.y)

      local tl = { x = self.sprite.x, y = self.sprite.y }
      local br = { x = self.sprite.x + self.sprite.width, y = self.sprite.y + self.sprite.height }

      self.properties.is_cannot_place = false
      self.properties.is_activated = false

      current_world:queryBoundingBox(tl.x, tl.y, br.x, br.y, function(fixture)
        if entities[fixture:getUserData().id] then
            self.properties.is_cannot_place = true
            if self.properties.is_placed and fixture:getUserData().id == "player" then
                print("Well done")
                self.properties.is_activated = true
                self:use()
            end
            return false
        end
        return true
      end)
    end
end

function BedEntity:use()
    if is_mouse_down(2) then
        day_changed = true
        mouse_clear_state(2)
    end
end

function BedEntity:draw()
    if not self.properties.is_placed then
        if self.properties.is_cannot_place then
            set_color(255, 0, 0, 0.7)
        else
            set_color(255, 255, 255, 0.7)
        end
    end

    self.sprite:draw(self.sprite.sprites)
    reset_color()

    if self.properties.is_activated then
        love.graphics.circle("fill", self.sprite.x + self.sprite.width / 2, self.sprite.y + self.sprite.height / 2, 10)
    end

end

return BedEntity
