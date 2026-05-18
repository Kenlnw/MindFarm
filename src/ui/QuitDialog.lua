local QuitDialog = {}
QuitDialog.__index = QuitDialog

function QuitDialog:load()
    TextBoxComponent = require("src.components.ui.TextBoxComponent")

    local self = setmetatable({}, QuitDialog)
    self.is_open = false
    return self
end

function QuitDialog:_build()
    local box_w = width_scale(300)
    local box_h = height_scale(110)
    local box_x = width_scale(640) - box_w / 2
    local box_y = height_scale(360) - box_h / 2

    local btn_w = width_scale(100)
    local btn_h = height_scale(40)
    local gap   = width_scale(20)
    local total_btn_w = btn_w * 2 + gap
    local btn_y = box_y + box_h - btn_h - height_scale(10)

    self.box_x = box_x
    self.box_y = box_y
    self.box_w = box_w
    self.box_h = box_h

    self.message = TextBoxComponent:load(
        "Quit MindFarm?",
        box_x, box_y,
        box_w, height_scale(50),
        height_scale(20)
    )

    self.btn_yes = TextBoxComponent:load(
        "[Y] Yes",
        box_x + (box_w - total_btn_w) / 2,
        btn_y,
        btn_w, btn_h,
        height_scale(16)
    )

    self.btn_no = TextBoxComponent:load(
        "[N] No",
        box_x + (box_w - total_btn_w) / 2 + btn_w + gap,
        btn_y,
        btn_w, btn_h,
        height_scale(16)
    )

    self.is_select = self.btn_yes
end

function QuitDialog:open()
    self:_build()
    self.is_open = true
    change_game_states("menu")
end

function QuitDialog:update()
    if not self.is_open then return end

    if is_key_down("escape") or is_key_down("n") then
        self.is_open = false
        change_game_states("running")

        key_clear_state("escape")
        key_clear_state("n")
    end

    if is_key_down("y") then
        love.event.quit()
    end

    if is_key_down("d") or is_key_down("right") then
        self.is_select = self.btn_no
        key_clear_state("d")
        key_clear_state("right")
    end

    if is_key_down("a") or is_key_down("left") then
        self.is_select = self.btn_yes
        key_clear_state("a")
        key_clear_state("left")
    end

    local mx, my = love.mouse.getPosition()

    if is_inside(mx, my, self.btn_yes) then
        self.is_select = self.btn_yes
    end

    if is_inside(mx, my, self.btn_no) then
        self.is_select = self.btn_no
    end

     if is_mouse_down(1) or is_key_down("return") then
        if self.is_select == self.btn_yes then
            love.event.quit()
        end
        if self.is_select == self.btn_no then
            self.is_open = false
            change_game_states("running")
        end

        mouse_clear_state(1)
        key_clear_state("return")
    end
end

function QuitDialog:draw()
    if not self.is_open then return end

    local w, h = love.graphics.getDimensions()

    -- background
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- message background
    love.graphics.setColor(30, 30, 30, 1)
    love.graphics.rectangle("fill", self.box_x, self.box_y, self.box_w, self.box_h, height_scale(8), 0)

    -- message
    self.message:draw(30, 30, 30, 255, 255, 255, 1, 1, 0)

    -- yes button (red)
    self.btn_yes:draw(200, 50, 50, 255, 255, 255, 1, 1, height_scale(6))

    -- no button (gray)
    self.btn_no:draw(100, 100, 100, 255, 255, 255, 1, 1, height_scale(6))

    if self.is_select then
        set_color(0, 0, 0)
        love.graphics.push()
        love.graphics.setLineWidth(height_scale(5))
        love.graphics.rectangle("line", self.is_select.x, self.is_select.y, self.is_select.width, self.is_select.height, height_scale(8))
        love.graphics.pop()
    end

    reset_color()
end

return QuitDialog