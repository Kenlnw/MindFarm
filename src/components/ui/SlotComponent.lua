local SlotComponent = {}
SlotComponent.__index = SlotComponent

function SlotComponent:load(x, y, width, height, id, item)
    TextBox = require("src.components.ui.TextboxComponent")

    local self = setmetatable({}, SlotComponent)
    self.x = x or 0
    self.y = y or 0

    self.width = width
    self.height = height

    self.id = id

    self.is_selected = false
    self.item = item or nil
    self.item_amount =  0
    self.capacity = 3

    self.amount_label = TextBox:load(self.item_amount, self.x + self.width - 20, self.y + self.height - 20, self.width / 4, self.height / 4, 20)

    return self
end

function SlotComponent:select()
    set_color(255, 255, 255)
    love.graphics.push()
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.pop()
end

function SlotComponent:store_item(item, amount)
    if item then
        self.item = item
        self.item_amount = self.item_amount + amount
    end
end

function SlotComponent:update(dt)
    if self.item and self.item.properties.is_used then
        self.item_amount = self.item_amount - 1
        if self.item_amount == 0 then
            self.item = nil
        else
            self.item.properties.is_used = false
        end
    end

    self.amount_label:change_text(self.item_amount)
end

function SlotComponent:draw()
    set_color(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    reset_color()

    if self.is_selected == true then
        self:select()
    end

    if self.item then
        self.item:draw()
    end

    if self.item_amount > 0 then
        self.amount_label:draw(0, 0, 0, 255, 255, 255, 0, 1)
    end

end

return SlotComponent