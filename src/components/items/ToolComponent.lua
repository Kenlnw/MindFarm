local ToolComponent = {}
ToolComponent.__index = ToolComponent

function ToolComponent:load()
    local self = setmetatable({}, ToolComponent)
    self.is_using = false

    return self
end

return ToolComponent