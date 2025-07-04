local game = {}
game.__index = game

function game.load()
    require("src.Utils")
    wf = require("libraries.windfield")
    Map = require("src.Map")
    Player = require("src.Player")
    Camera = require("libraries.camera")
    Interface = require("src.Interface")

    game.title = "MindFarm"
    love.window.setTitle(game.title)
    love.graphics.setDefaultFilter("nearest", "nearest")

    game.width = love.graphics.getWidth()
    game.height = love.graphics.getHeight()
    game.world = wf.newWorld(0, 0)

    game.start_map = Map:load()
    game.player = Player:load(game.width/2, game.height/2)
    game.camera = Camera()
    game.interface = Interface:load()

end

function game.update(dt)
    game.player:update(dt)
    game:set_camera()

    -- game.interface:update(dt)
end

function game.set_camera()
    local round_x = round(game.player.x)
    local round_y = round(game.player.y)

    game.camera:lookAt(round_x, round_y)

    if game.camera.x < game.width/2 then
        game.camera.x = game.width/2
    elseif game.camera.x > (game.start_map.width - game.width/2) then
        game.camera.y = game.start_map.width - game.width/2
    end

    if game.camera.y < game.height/2 then
        game.camera.y = game.height/2
    elseif game.camera.y > (game.start_map.height - game.height/2) then
        game.camera.y = game.start_map.height - game.height/2
    end
end

function game.draw()
    game.camera:attach()
        game.start_map:draw()
        game.player:draw()
    game.camera:detach()

    game.interface:draw()
end

return game