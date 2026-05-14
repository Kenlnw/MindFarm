local Interface = {}
Interface.__index = Interface

function Interface:load(time)
    SlotBar = require("src.ui.SlotBar")
    TextBox = require("src.components.ui.TextBoxComponent")
    InfoTextComponent = require("src.components.ui.InfoTextComponent")

    local self = setmetatable({}, Interface)

    self.slot_bar = SlotBar:load()

    self.date_label = TextBox:load("Day " .. DAYS, love.graphics.getWidth() - width_scale(200), 0, width_scale(200), height_scale(80), width_scale(40))

    self.time = time
    self.time:set_label(love.graphics.getWidth()* 11/12, self.date_label.height, love.graphics.getWidth()/12, height_scale(50), width_scale(20))
    self.time.label:set_icon("sprites/items/Clock.png", TILE_SCALE/2)

    self.cash_label = TextBox:load(" " .. CASH, 0, 0, love.graphics.getWidth()/10, height_scale(80), width_scale(40))
    self.cash_label:set_icon("sprites/items/Cash.png", TILE_SCALE)

    self.item_info = InfoTextComponent:load()

    return self
end

function Interface:cash_animation(dt)
    local display_cash = PREV_CASH
    local target_cash = CASH
    local anim_speed = CASH*1.5

    -- money increased
    if display_cash < target_cash  then
        display_cash = math.min(display_cash + anim_speed*dt, target_cash)
    end
    -- money decreased
    if display_cash > target_cash then
        display_cash = math.max(display_cash - anim_speed*dt, target_cash)
    end
    self.cash_label:change_text(" " .. math.floor(display_cash))

    PREV_CASH = display_cash


    self.cash_label:resize_to_text()
end

function Interface:update(dt)
    self.date_label:change_text("Day " .. DAYS)
    self:cash_animation(dt)

    self.item_info:item_update(self.slot_bar.slots[self.slot_bar.current_slot_id + 1])
end

function Interface:draw()
    self.slot_bar:draw()
    self.date_label:draw(30, 55, 25, 220, 200, 150, 0.85, 1)
    self.cash_label:draw_with_icon(42, 28, 10, 255, 200, 80, 0.5, 1, 0, "left")
    self.time:draw(25, 35, 55, 180, 210, 255, 0.75, 1)
end

return Interface
