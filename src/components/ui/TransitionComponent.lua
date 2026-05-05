local TransitionComponent = {}
TransitionComponent.__index = TransitionComponent

function TransitionComponent:load(config)
    local self = setmetatable({}, TransitionComponent)
    self.active = false
    self.alpha = 0
    self.timer = 0
    self.phase = nil
    self.fade_in_duration = config.fade_in_duration or 1.5
    self.fade_out_duration = config.fade_out_duration or 1.5
    self.hold_duration = config.hold_duration or 1.0
    self.on_hold = nil
    return self
end

function TransitionComponent:start(on_hold)
    self.active = true
    self.alpha = 0
    self.timer = 0
    self.phase = "fade_in"
    self.on_hold = on_hold
end

function TransitionComponent:update(dt)
    if not self.active then return end

    self.timer = self.timer + dt

    if self.phase == "fade_in" then
        self.alpha = math.min(self.timer / self.fade_in_duration, 1)
        if self.timer >= self.fade_in_duration then
            self.timer = 0
            self.phase = "hold"
            if self.on_hold then self.on_hold() end
        end

    elseif self.phase == "hold" then
        self.alpha = 1
        if self.timer >= self.hold_duration then
            self.timer = 0
            self.phase = "fade_out"
        end

    elseif self.phase == "fade_out" then
        self.alpha = math.max(1 - self.timer / self.fade_out_duration, 0)
        if self.timer >= self.fade_out_duration then
            self.active = false
            self.phase = nil
        end
    end
end

function TransitionComponent:draw()
    local width, height = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor(1, 1, 1, 1)
end

return TransitionComponent