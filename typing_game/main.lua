local common = require("lib.common")
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
    common.clear_screen()
    print("Welcome to the Typing Game!")
    print("Select your level: ")
    print("1. Beginner")
    print("2. Intermediate")
    print("3. Advanced")

    local choice = tonumber(io.read())
    local level
    if choice == 1 then
        level = "beginner"
    elseif choice == 2 then
        level = "intermediate"
    elseif choice == 3 then
        level = "advanced"
    else
        print("Invalid choice. Please select a valid level.")
        return
    end

    print("You've chosen " .. level .. " level.")
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
        print("Type the word: " .. word)
        local user_input = io.read()
        if user_input == word then
            score = score + 1
        end
    end

    local end_time = os.time()
    local elapsed_time = os.difftime(end_time, start_time)
    local words_per_minute = (score / elapsed_time) * 60

    print("Your typing speed: " .. string.format("%.2f", words_per_minute) .. " words per minute")
    local level_recommended = self:get_level(words_per_minute)
    print("Recommended level: " .. level_recommended)
end

return TypingGame
