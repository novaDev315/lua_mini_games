local utils = require("lib.utils")
local Highscore = require("lib.highscore")
local UI = require("lib.ui")

local TypingGame = {}

function TypingGame:get_level(speed)
    if speed < 20 then
        return "beginner"
    elseif speed >= 20 and speed < 40 then
        return "intermediate"
    else
        return "advanced"
    end
end

function TypingGame:run_game()
    UI:display_title("Typing Game")
    UI:display_message("Select your level:", UI.colors.cyan)
    UI:display_message("1. Beginner", UI.colors.white)
    UI:display_message("2. Intermediate", UI.colors.white)
    UI:display_message("3. Advanced", UI.colors.white)

    local choice = tonumber(io.read())
    local level
    if choice == 1 then
        level = "beginner"
    elseif choice == 2 then
        level = "intermediate"
    elseif choice == 3 then
        level = "advanced"
    else
        UI:display_message("Invalid choice. Please select a valid level.", UI.colors.red)
        return
    end

    UI:display_message("You've chosen " .. level .. " level.", UI.colors.green)
    local words = {"apple", "banana", "cherry", "dog", "elephant", "frog", "giraffe", "house", "igloo", "jungle"}
    local words_to_type = {}
    if level == "beginner" then
        words_to_type = {words[1], words[2], words[3]}
    elseif level == "intermediate" then
        words_to_type = {words[1], words[2], words[3], words[4], words[5]}
    else
        words_to_type = words
    end

    local start_time = os.time()
    local score = 0

    for _, word in ipairs(words_to_type) do
        UI:display_message("Type the word: " .. word, UI.colors.yellow)
        local user_input = io.read()
        if user_input == word then
            score = score + 1
        end
    end

    local end_time = os.time()
    local elapsed_time = os.difftime(end_time, start_time)
    local words_per_minute = (score / elapsed_time) * 60

    UI:display_message("Your typing speed: " .. string.format("%.2f", words_per_minute) .. " words per minute", UI.colors.green)
    local level_recommended = self:get_level(words_per_minute)
    UI:display_message("Recommended level: " .. level_recommended, UI.colors.green)

    -- Update high score
    local is_new_highscore = Highscore:update_score("Typing Game", words_per_minute)
    if is_new_highscore then
        UI:display_message("New High Score for Typing Game!", UI.colors.bright_magenta)
    end

    while true do
        UI:display_message("\nWhat would you like to do next?", UI.colors.cyan)
        UI:display_message("1. Play again", UI.colors.white)
        UI:display_message("2. Return to main menu", UI.colors.white)
        local choice = io.read()

        if choice == "1" then
            self:run_game()
            break
        elseif choice == "2" then
            break
        else
            UI:display_message("Invalid choice. Please try again.", UI.colors.red)
        end
    end
end

return TypingGame