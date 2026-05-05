local BedTransition = {}
BedTransition.__index = BedTransition

local TransitionComponent = require("src.components.ui.TransitionComponent")
local TextBox = require("src.components.ui.TextboxComponent")
setmetatable(BedTransition, { __index = TransitionComponent })

function BedTransition:load()
    local self = TransitionComponent.load(self, {
        fade_in_duration = 0.5,
        hold_duration = 1.5,
        fade_out_duration = 1.0,
    })
    setmetatable(self, BedTransition)
    self.day_text = TextBox:load("", 0, 0, love.graphics.getWidth(), love.graphics.getHeight(), 200)
    return self
end

function BedTransition:start(on_hold)
    self.day_text:change_text("Day " .. DAYS + 1)
    TransitionComponent.start(self, on_hold)
end

function BedTransition:update(dt)
    TransitionComponent.update(self, dt)

    if self.phase == "fade_out" then
        day_changed = false
    end
end

function BedTransition:draw()
    if not self.active then return end

    TransitionComponent.draw(self)

    if self.phase == "hold" then
        self.day_text:draw(0, 0, 0, 255, 255, 255, 0, 1)
    end
end

return BedTransition