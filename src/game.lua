local game = {}
game.__index = game

function game.load()
    Map = require("src.Map")
    Player = require("src.Player")
    Camera = require("libraries.camera")
    Interface = require("src.ui.Interface")
    TimeComponent = require("src.components.ui.TimeComponent")

    love.graphics.setDefaultFilter("nearest", "nearest")

    game.width = love.graphics.getWidth()
    game.height = love.graphics.getHeight()

    game.time = TimeComponent:load(1440, 360, 2)

    current_world = map_lists["prototype_town"].world

    game.interface = Interface:load(game.time)
    game.player = Player:load(423*TILE_SCALE, 231*TILE_SCALE, game.interface)

    game.camera = Camera()

    game.prototype_town = Map:load(map_lists["prototype_town"].src, game.player, game.camera)

    game.can_check_collider = false


    change_game_states("running")
end

function game.update(dt)
    update_mouse_position(game.camera)

    if is_key_down("escape") then
        love.event.quit()
        key_clear_state("escape")
    end

    game.time.bed_transition:update(dt)
    game.interface.slot_bar:update(dt)
    game.prototype_town.useable_obj_component:update(dt)

    if game_states["running"] and not game.time.bed_transition.active then
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
        game.time:update(dt)
        game.player:update(dt)
        game.interface:update(dt)
        game:set_camera()
    elseif game.time.bed_transition.active and game.time.bed_transition.phase == "hold" then
        game.prototype_town.plantable_area_component:update_between_day(dt)
        game.prototype_town.useable_obj_component:update_between_day(dt)
        game.player:update_between_day(dt)
    end

    if game_states["paused"] then
        game.player:update_between_day(dt)
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

    if game_states["paused"] then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        reset_color()
    end

    game.interface:draw()
    game.prototype_town.useable_obj_component:storage_draw()
end

return game