local game = {}
game.__index = game

function game.load()
    Map = require("src.Map")
    Player = require("src.Player")
    Camera = require("libraries.camera")
    Interface = require("src.ui.Interface")

    love.graphics.setDefaultFilter("nearest", "nearest")

    game.width = love.graphics.getWidth()
    game.height = love.graphics.getHeight()


    current_world = map_lists["prototype_town"].world

    game.interface = Interface:load()
    game.player = Player:load(game.width/2, game.height/2, game.interface)

    game.camera = Camera()

    game.prototype_town = Map:load(map_lists["prototype_town"].src, game.player, game.camera)

    game.can_check_collider = false

    change_game_states("running")
end

function game.update(dt)
    update_mouse_position(game.camera)

    if is_key_down("escape") then
        if game_states["running"] then
            change_game_states("paused")
        else
            change_game_states("running")
        end
        key_clear_state("escape")
    end

    if game_states["running"] then

        if is_key_down("p") then
            if game.can_check_collider then
                game.can_check_collider = false
            else
                game.can_check_collider = true
            end
            key_clear_state("p")
        elseif is_key_down("l") then
            day_changed = true
            key_clear_state("l")
        end


        current_world:update(dt)
        game.prototype_town:update(dt)
        game.player:update(dt)
        game.interface:update(dt)
        game:set_camera()
    end
end

function game.set_camera()
    local round_x = round(game.player.sprite.x)
    local round_y = round(game.player.sprite.y)

    game.camera:lookAt(round_x, round_y)

if game.camera.x < game.width/2 then
        game.camera.x = game.width/2
    elseif game.camera.x > (game.prototype_town.width - game.width/2) then
        game.camera.x = game.prototype_town.width - game.width/2
    end

    if game.camera.y < game.height/2 then
        game.camera.y = game.height/2
    elseif game.camera.y > (game.prototype_town.height - game.height/2) then
        game.camera.y = game.prototype_town.height - game.height/2
    end
end

function game.draw_world()
    for _, body in pairs(current_world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()

            if fixture:isSensor() then
                set_color(255, 0, 0)
            end

            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("line", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end

            reset_color()
        end
    end
end

function game.draw()
    game.camera:attach()
        game.prototype_town:draw()

        if game.can_check_collider then
            game.draw_world()
        end
        game.player:draw()
    game.camera:detach()

    game.interface:draw()
end

return game