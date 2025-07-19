local CropComponent = {}
CropComponent.__index = CropComponent

function CropComponent:load()
    local self = setmetatable({}, CropComponent)
    self.is_eatable = true
    self.is_used = false

    return self
end

function CropComponent:eat()
    self.is_used = true
end

return CropComponent