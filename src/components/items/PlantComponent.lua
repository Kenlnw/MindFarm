local PlantComponent = {}
PlantComponent.__index = PlantComponent

function PlantComponent:load(crop)
    local self = setmetatable({}, PlantComponent)
    self.is_watered = false
    self.days_to_grow = 6
    self.started_day = DAYS
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
    if DAYS - self.started_day < self.days_to_grow then
        if self.is_watered and day_changed then
            self.growing_state = DAYS - self.started_day + 1
        end
    end
end

function PlantComponent:harvest(x, y, flip_x, flip_y)
    if self.can_harvest then
        return self.crop:load(x, y, flip_x, flip_y)
    end
end

return PlantComponent