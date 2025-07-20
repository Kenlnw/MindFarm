local game = require("src.game")
require("src.utils")

function love.load()
    game.load()

    scroll_timer = 0
    scroll_delay = 0.075
end

function love.update(dt)
    if scroll_timer > 0 then
        scroll_timer = scroll_timer - dt
        if scroll_timer < 0 then scroll_timer = 0 end
    end

    game.update(dt)
end

function love.draw()
    game.draw()
end

function love.keypressed(key)
    key_set_state(key)
end

function love.keyreleased(key)
    key_clear_state(key)
end

function love.mousepressed(x, y, button)
    mouse_set_state(x, y, button)
end

function love.mousereleased(x, y, button)
    mouse_clear_state(button)
end

function love.wheelmoved(x, y)
    if scroll_timer > 0 then return end

    if y > 0 then
        game.interface.slot_bar:change_slot_slide("right")
        scroll_timer = scroll_delay
    elseif y < 0 then
        game.interface.slot_bar:change_slot_slide("left")
        scroll_timer = scroll_delay
    end

end