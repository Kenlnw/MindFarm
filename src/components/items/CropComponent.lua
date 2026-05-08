local CropComponent = {}
CropComponent.__index = CropComponent

function CropComponent:load(sell_price)
    local self = setmetatable({}, CropComponent)
    self.type = "crop"
    self.is_eatable = false
    self.is_used = false

    self.sell_price = sell_price

    return self
end

function CropComponent:update(dt)
    -- if not self.is_eatable and not is_mouse_down(2) then
    --     self.is_eatable = true
    -- end
end

function CropComponent:eat()
    self.is_used = true
end

return CropComponent