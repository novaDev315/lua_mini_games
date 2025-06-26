
local Game = {}
Game.__index = Game

function Game:new(name, path)
    local game = setmetatable({}, Game)
    game.name = name
    game.path = path
    game.instance = require(path)
    return game
end

function Game:run()
    self.instance:run_game()
end

return Game
