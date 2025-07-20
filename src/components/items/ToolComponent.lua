local ToolComponent = {}
ToolComponent.__index = ToolComponent

function ToolComponent:load(target_id)
    local self = setmetatable({}, ToolComponent)
    self.is_reuseable = true
    self.is_used = false
    self.target_id = target_id

    return self
end

return ToolComponent