local game = {}
game.__index = game

function game.load()
    require("src.utils")
    wf = require("libraries.windfield")
    Map = require("src.classes.Map")
    Player = require("src.classes.Player")
    Camera = require("libraries.camera")
    Interface = require("src.classes.Interface")

    game.title = "MindFarm"
    love.window.setTitle(game.title)
    love.graphics.setDefaultFilter("nearest", "nearest")

    game.width = love.graphics.getWidth()
    game.height = love.graphics.getHeight()
    game.world = wf.newWorld(0, 0)
    game.add_all_collison_classes()

    game.prototype_town = Map:load(game.world, "maps/prototype_town.lua")
    
    game.player = Player:load(game.world, game.width/2, game.height/2)
    game.camera = Camera()
    game.interface = Interface:load()

end

function game.add_all_collison_classes()
    game.world:addCollisionClass("Player")
    game.world:addCollisionClass("Collision")
    game.world:addCollisionClass("PlantableArea")
end

function game.update(dt)
    game.player:update(dt)
    game:set_camera()

    

    game.world:update(dt)
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
        game.player:draw()
        game.world:draw()
    game.camera:detach()

    game.interface:draw()
end

return game