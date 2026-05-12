local PlantComponent = {}
PlantComponent.__index = PlantComponent

function PlantComponent:load(crop, days_to_grow)
    local self = setmetatable({}, PlantComponent)
    self.type = "plant"
    self.is_watered = false
    self.days_to_grow = days_to_grow or 1
    self.last_grown_days = DAYS
    self.growing_state = 1

    self.can_harvest = false

    self.is_regrowable = false
    self.regrow_activate = false
    self.days_to_regrow = 0
    self.regrowing_state = 0
    self.harvest_state = nil
    self.ongoing_state = nil

    self.crop = crop or nil

    return self
end

function PlantComponent:set_regrow(days_to_regrow, harvast_state, ongoing_state)
    self.is_regrowable = true
    self.days_to_regrow = days_to_regrow
    self.harvest_state = harvast_state
    self.ongoing_state = ongoing_state
end

function PlantComponent:update()
    if self.growing_state >= self.days_to_grow then
        if self.regrow_activate then
            if self.regrowing_state >= self.days_to_regrow then
                self.can_harvest = true
            end
        else
            self.can_harvest = true
        end
    end

    self:grow()
end

function PlantComponent:grow()
    if not self.is_watered or self.last_grown_days >= DAYS then return end

    if not self.regrow_activate and self.growing_state <= self.days_to_grow then
        self.growing_state = clamp(self.growing_state + 1, 1, self.days_to_grow)
    elseif self.regrow_activate and self.regrowing_state <= self.days_to_regrow then
        self.regrowing_state = clamp(self.regrowing_state + 1, 1, self.days_to_regrow)
    end
    self.last_grown_days = DAYS
end

function PlantComponent:harvest(x, y, flip_x, flip_y)
    if not self.can_harvest then return end

    if self.is_regrowable then
        self.regrow_activate = true
        self.regrowing_state = 1
    end

    self.can_harvest = false

    return self.crop:load(x, y, flip_x, flip_y)
end

return PlantComponent