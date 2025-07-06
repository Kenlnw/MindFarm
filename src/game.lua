local game = {}
game.__index = game

function game.load()
    require("src.utils")
    Map = require("src.classes.Map")
    Player = require("src.classes.Player")
    Camera = require("libraries.camera")
    Interface = require("src.classes.Interface")

    game.title = "MindFarm"
    love.window.setTitle(game.title)
    love.graphics.setDefaultFilter("nearest", "nearest")

    game.width = love.graphics.getWidth()
    game.height = love.graphics.getHeight()

    debug_init()

    game.world = love.physics.newWorld(0, 0)
    -- game.world:setCallbacks(game.on_collision_enter, game.on_collision_exit)

    game.interface = Interface:load()
    game.player = Player:load(game.world, game.width/2, game.height/2, game.interface)

    game.prototype_town = Map:load(game.world, "maps/prototype_town.lua", game.player)
    
    game.camera = Camera()

end

function game.update(dt)
    game.prototype_town:update(dt)
    game.world:update(dt)
    game.player:update(dt)
    game.interface:update(dt)
    game:set_camera()
end

function game.set_camera()
    local round_x = round(game.player.x)
    local round_y = round(game.player.y)

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

function game.draw()
    game.camera:attach()
        game.prototype_town:draw()
        -- if debug_bool == true then
        --     if debug_obj.is_planted then
        --         love.graphics.rectangle("fill", debug_obj.x, debug_obj.y, debug_obj.width, debug_obj.height)
        --     else
        --         love.graphics.rectangle("line", debug_obj.x, debug_obj.y, debug_obj.width, debug_obj.height)
        --     end
        -- end
        game.player:draw()
        -- game.world:draw()
    game.camera:detach()

    game.interface:draw()
    debug_print()
end

return game