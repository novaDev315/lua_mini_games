-- Define ANSI escape sequences for colors
local colors = {
    red = "\27[31m",
    green = "\27[32m",
    reset = "\27[0m"
}

local KeyMappingGame = {}
KeyMappingGame.__index = KeyMappingGame

-- Function to create a new instance of KeyMappingGame
function KeyMappingGame:create()
    local self = setmetatable({}, KeyMappingGame)
    self.key_mappings = {
        ["Save and Quit"] = " <leader>wq",
        ["Quit without saving"] = " <leader>qq",
        ["Save"]=" <leader>ww",
    ["Split Vertical"]=" <leader>sv",
    ["Split Horizontal"]=" <leader>sh",
    ["Make Split Windows Equal Width"]=" <leader>se",
    ["Close Split Window"]=" <leader>sx",
    ["Make Split Window Height Shorter"]=" <leader>sj",
    ["Make Split Windows Height Taller"]=" <leader>sk",
    ["Make Split Windows Width Bigger"]=" <leader>sl",
    ["Make Split Windows Width Smaller"]=" <leader>sh",
    ["Open New Tab"]=" <leader>to",
    ["Close Tab"]=" <leader>tx",
    ["Next Tab"]=" <leader>tn",
    ["Previous Tab"]=" <leader>tp",
    ["Put Diff from Current to Other"]=" <leader>cc",
    ["Get Diff from Left (local) During Merge"]=" <leader>cj",
    ["Get Diff from Right (remote) During Merge"]=" <leader>ck",
    ["Next Diff Hunk"]=" <leader>cn",
    ["Previous Diff Hunk"]=" <leader>cp",
    ["Jump to Next Quickfix List Item"]=" <leader>qn",
    ["Jump to Previous Quickfix List Item"]=" <leader>qp",
    ["Dismiss Noice Messages"]=" <leader>nd",
    ["Copy File Name"]=" <leader>cf",
    ["Copy File Path"]=" <leader>cp",
    ["Make Current File Executable"]=" <leader>x",
    ["Select All"]=" ==",
    ["Open Zoxide"]=" <leader>Z",
    ["Toggle Maximize Tab"]=" <leader>sm",
    ["Toggle File Explorer"]=" <leader>ee",
    ["Toggle Focus to File Explorer"]=" <leader>er",
    ["Find File in File Explorer"]=" <leader>ef",
    ["Find Files"]=" <leader>ff",
    ["Live Grep"]=" <leader>fg",
    ["Buffers"]=" <leader>fb",
    ["Help Tags"]=" <leader>fh",
    ["Current Buffer Fuzzy Find"]=" <leader>fs",
    ["Treesitter"]=" <leader>fm",
    ["Toggle Git Blame"]=" <leader>gb",
    ["Harpoon Add File"]=" <leader>ha",
    ["Harpoon Toggle Quick Menu"]=" <leader>hh",
    ["Harpoon Navigation 1"]=" <leader>h1",
    ["Harpoon Navigation 2"]=" <leader>h2",
    ["Harpoon Navigation 3"]=" <leader>h3",
    ["Harpoon Navigation 4"]=" <leader>h4",
    ["Harpoon Navigation 5"]=" <leader>h5",
    ["Harpoon Navigation 6"]=" <leader>h6",
    ["Harpoon Navigation 7"]=" <leader>h7",
    ["Harpoon Navigation 8"]=" <leader>h8",
    ["Harpoon Navigation 9"]=" <leader>h9",
    }
    self.score = 0
    self.total_questions = 0
    self.total_questions_initial = 0
    self.level = 1
    return self
end

-- Function to get a random element from a table
function KeyMappingGame:random_element(table_data)
    local keys = {}

    for k, _ in pairs(table_data) do
        table.insert(keys, k)
    end
    local rand_index = math.random(#keys)
    return keys[rand_index], table_data[keys[rand_index]]
end

-- Function to display question
function KeyMappingGame:display_question(task)
    self.total_questions = self.total_questions - 1
    print("Question " .. (self.total_questions_initial - self.total_questions) .. ": What is the key map for " .. colors.red .. task .. colors.reset .. "?")
end

-- Function to get user input
function KeyMappingGame:get_user_input()
    return io.read()
end

-- check if two strings are equal
function KeyMappingGame:is_string_equal(str1, str2)
    return self:trim(str1) == self:trim(str2)
end

-- trim leading and trailing whitespace
function KeyMappingGame:trim(text)
    return text:match("^%s*(.-)%s*$")
end

-- Function to validate user input
function KeyMappingGame:validate_input(user_input)
    -- Check if the user wants to stop the game
    if user_input == "/stop" then
        print("Exiting the game.")
        os.exit()
    end

    -- Check if the input is valid
    if user_input == "" then
        print("Invalid input. Please provide a valid key mapping.")
        return false
    end

    return true
end

-- Function to display feedback
function KeyMappingGame:display_feedback(is_correct, correct_answer)
    if is_correct then
        print(colors.green .. "Correct!" .. colors.reset)
    else
        print("Incorrect. The correct key map is: " .. colors.green .. correct_answer .. colors.reset)
    end
end

-- Function to display final score
function KeyMappingGame:display_final_score()
    print("-----------------------------------")
    print("Game Over!")
    print("Your final score is: " .. colors.green .. self.score .. " / " .. self.total_questions_initial .. colors.reset)
    print("Level: " .. self.level)
    print("-----------------------------------")
end

-- Main function to run the game
function KeyMappingGame:main()
    -- Setup game
    print("Welcome to Vim Key Mapping Trainer!")
    print("-----------------------------------")

    -- Ask the user how many questions they want to answer
    print("How many questions would you like to answer?")
    self.total_questions_initial = tonumber(self:get_user_input())
    self.total_questions = self.total_questions_initial
     -- test 
     print("total_questions_initial: ", self.total_questions_initial)
     print("total_questions: ", self.total_questions)

    -- Main game loop
    while self.total_questions > 0 do
        -- Randomly select a key mapping task
        local task, answer = self:random_element(self.key_mappings)

        -- Display question
        self:display_question(task)

        -- Get user answer 
        print("Your answer: ")
        local user_answer = self:get_user_input()

        -- Validate user input
        if not self:validate_input(user_answer) then
            -- Skip to the next iteration if input is invalid
            goto continue
        end

        -- Check if the user input matches the correct key mapping
        local is_correct = self:is_string_equal(self.key_mappings[task], user_answer)

        -- Display feedback
        self:display_feedback(is_correct, self.key_mappings[task])

        -- Increment score if the answer is correct
        if is_correct then
            self.score = self.score + 1

            -- Check if the user leveled up
            if self.score % 10 == 0 then
                self.level = self.level + 1
                print("Congratulations! You've reached Level " .. self.level .. "!")
            end
        end

        ::continue::
    end

    -- Display final score
    self:display_final_score()
end

--return KeyMappingGame
local key_mapping_game = KeyMappingGame:create()
key_mapping_game:main()
