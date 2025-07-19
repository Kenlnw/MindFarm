local ToolComponent = {}
ToolComponent.__index = ToolComponent

function ToolComponent:load()
    local self = setmetatable({}, ToolComponent)
    self.is_reuseable = true
    self.is_used = false

    return self
end

return ToolComponent