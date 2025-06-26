local Game = require("lib.game")
local Highscore = require("lib.highscore")
local UI = require("lib.ui")

local Engine = {}

function Engine:new()
    local engine = {}
    engine.games = {}
    setmetatable(engine, { __index = Engine })
    return engine
end

function Engine:register_game(name, path)
    local game = Game:new(name, path)
    table.insert(self.games, game)
end

function Engine:show_menu()
    UI:display_title("Mini Games")
    UI:display_message("Select a game to play:", UI.colors.cyan)
    for i, game in ipairs(self.games) do
        local game_info = i .. ". " .. game.name
        local highscore = Highscore:get_score(game.name)
        if highscore > 0 then
            game_info = game_info .. " (High Score: " .. highscore .. ")"
        end
        UI:display_message(game_info, UI.colors.white)
    end
    UI:display_message((#self.games + 1) .. ". Exit", UI.colors.red)
end

function Engine:run()
    while true do
        self:show_menu()
        local choice = io.read()
        local game_index = tonumber(choice)

        if game_index and game_index > 0 and game_index <= #self.games then
            local game = self.games[game_index]
            game:run()
        elseif game_index == #self.games + 1 then
            UI:display_message("Goodbye!", UI.colors.green)
            break
        else
            UI:display_message("Invalid choice. Please try again.", UI.colors.red)
        end
    end
end

return Engine
