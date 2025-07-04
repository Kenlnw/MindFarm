local game = require("src.game")

function love.load()
    game.load()
end

function love.update(dt)
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
    end
end