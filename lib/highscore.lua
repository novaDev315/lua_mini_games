local json = require("lib.json")

local Highscore = {}

local HIGHSCORE_FILE = "highscores.json"

function Highscore:load_scores()
    local file = io.open(HIGHSCORE_FILE, "r")
    if file then
        local content = file:read("*all")
        file:close()
        if content and content ~= "" then
            local success, scores = pcall(json.decode, content)
            if success then
                return scores
            else
                print("Error decoding highscores.json: " .. scores)
                return {}
            end
        end
    end
    return {}
end

function Highscore:save_scores(scores)
    local file = io.open(HIGHSCORE_FILE, "w")
    if file then
        local success, encoded_scores = pcall(json.encode, scores)
        if success then
            file:write(encoded_scores)
        else
            print("Error encoding high scores: " .. encoded_scores)
        end
        file:close()
    else
        print("Error: Could not open " .. HIGHSCORE_FILE .. " for writing.")
    end
end

function Highscore:update_score(game_name, score)
    local scores = self:load_scores()
    if not scores[game_name] or score > scores[game_name] then
        scores[game_name] = score
        self:save_scores(scores)
        return true
    end
    return false
end

function Highscore:get_score(game_name)
    local scores = self:load_scores()
    return scores[game_name] or 0
end

return Highscore
