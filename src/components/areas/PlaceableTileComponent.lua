local PlaceableTileComponent = {}
PlaceableTileComponent.__index = PlaceableTileComponent

function PlaceableTileComponent:load(world, x, y, width, height)
    local self = setmetatable({}, PlaceableTileComponent)
    current_world = world
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.is_active = false
    self.entity = nil

    self.area = {}
    self:set_area()

    return self
end

function PlaceableTileComponent:set_area()
    self.area.id = "placeable_area"
    self.area.body = love.physics.newBody(current_world, self.x, self.y, "static")
    self.area.shape = love.physics.newRectangleShape(self.width / 2, self.height / 2, self.width, self.height)
    self.area.fixture = love.physics.newFixture(self.area.body, self.area.shape)
    self.area.body:setFixedRotation(true)
    self.area.fixture:setSensor(true)
    self.area.fixture:setUserData(self.area)
end

function PlaceableTileComponent:update(dt)
    if self.entity then
        self.entity:update(dt)
    end
end

return PlaceableTileComponent
