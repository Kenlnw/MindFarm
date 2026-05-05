local PlantComponent = {}
PlantComponent.__index = PlantComponent

function PlantComponent:load(crop)
    local self = setmetatable({}, PlantComponent)
    self.type = "plant"
    self.is_watered = false
    self.days_to_grow = 6
    self.last_grown_days = DAYS
    self.growing_state = 1

    self.can_harvest = false

    self.crop = crop or nil

    return self
end

function PlantComponent:update()
    if self.growing_state == self.days_to_grow then
        self.can_harvest = true
    end

    self:grow()
end

function PlantComponent:grow()
    if self.growing_state <= self.days_to_grow and self.is_watered and self.last_grown_days < DAYS then
        self.growing_state = clamp(self.growing_state + 1, 1, self.days_to_grow)
        self.last_grown_days = DAYS
    end
end

function PlantComponent:harvest(x, y, flip_x, flip_y)
    if self.can_harvest then
        return self.crop:load(x, y, flip_x, flip_y)
    end
end

return PlantComponent