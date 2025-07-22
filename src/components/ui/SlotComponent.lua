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
    self.capacity = SLOT_CAPACITY

    self.amount_label = TextBox:load(self.item_amount, self.x, self.y + self.height - 20, self.width, 20, 20)

    return self
end

function SlotComponent:select()
    set_color(255, 255, 255)
    love.graphics.push()
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.pop()
end

function SlotComponent:store_item(item, amount, capacity)
    if item then
        self.item = item
        self.item_amount = self.item_amount + amount
        self.capacity = capacity or SLOT_CAPACITY
    end
end

function SlotComponent:handle_item_used()
    if self.item and self.item.properties.is_used and not self.item.properties.is_reuseable then
        self.item_amount = self.item_amount - 1
        if self.item_amount == 0 then
            self.item = nil
        else
            self.item.properties.is_used = false
        end
    end
end

function SlotComponent:update(dt)
    self:handle_item_used()

    self.amount_label:change_text(self.item_amount)

    if self.item then
        if self.item.properties.type == "food" then
            if is_mouse_down(2) then
                if self.item.properties.is_eatable then
                    mouse_current_state.is_using = true
                    self.item.properties:eat()
                    mouse_clear_state(2)
                end
            end
        elseif self.item.properties.type == "placeable_item" then
            if self.is_selected then
                self.item:show_object()
                -- if is_mouse_down(1) then
                --     mouse_current_state.is_using = true
                --     self.item:place()
                --     mouse_clear_state(1)
                -- end
            else
                self.item.properties.is_showed = false
            end
        end
        self.item:update(dt)
    end
end

function SlotComponent:draw()
    set_color(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    reset_color()

    if self.is_selected == true then
        self:select()
    end

    if self.item then
        self.item:draw()
    end

    if self.item_amount > 1  then
        self.amount_label:draw(0, 0, 0, 255, 255, 255, 0.3, 1)
    end

end

return SlotComponent