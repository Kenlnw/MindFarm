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
    if key == "right" then
        game.interface.slot_bar:change_slot_slide(key)
    elseif key == "left" then
        game.interface.slot_bar:change_slot_slide(key)
    elseif tonumber(key) ~= nil then
        game.interface.slot_bar:change_slot_at(tonumber(key))
    elseif key == "c" then
        if game.player.water_can then
            game.player.water_can = false
        else
            game.player.water_can = true
        end
    elseif key == "l" then
        DAYS = DAYS + 1;
    elseif key == "p" then
        if game.can_check_collider then
            game.can_check_collider = false
        else
            game.can_check_collider = true
        end
    elseif key == "e" then
        if game.player.current_item and game.player.current_item.is_eatable then
            game.player.current_item:eat()
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        game.prototype_town.plantable_area_component:interact_left_click()
    elseif button == 2 then
        game.prototype_town.plantable_area_component:interact_right_click()
    end
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