local SlotComponent = {}
SlotComponent.__index = SlotComponent

function SlotComponent:load(x, y, width, height, id, item, item_amount)
    local self = setmetatable({}, SlotComponent)
    self.x = x or 0
    self.y = y or 0

    self.width = width
    self.height = height

    self.id = id

    self.is_selected = false
    self.item = item or nil
    self.item_amount = item_amount or 4
    self.capacity = 3

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
    self.item = item
    self.item_amount = self.item_amount + amount
end

function SlotComponent:update(dt)
    if self.item and self.item.is_used then
        self.item_amount = self.item_amount - 1
        if self.item_amount == 0 then
            self.item = nil
        else
            self.item.is_used = false
        end
    end
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

end

return SlotComponent