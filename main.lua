local games = {
    {
        name = "Typing Game",
        path = "typing_game.main"
    },
    {
        name = "Vim Key Mapping Game",
        path = "vim_key_mapping_game.main"
    }
}

local function show_menu()
    print("Select a game to play:")
    for i, game in ipairs(games) do
        print(i .. ". " .. game.name)
    end
    print((#games + 1) .. ". Exit")
end

local function main()
    while true do
        show_menu()
        local choice = io.read()
        local game_index = tonumber(choice)

        if game_index and game_index > 0 and game_index <= #games then
            local game_module = require(games[game_index].path)
            if games[game_index].name == "Vim Key Mapping Game" then
                local game = game_module:create()
                game:run_game()
            else
                game_module:run_game()
            end
        elseif game_index == #games + 1 then
            print("Goodbye!")
            break
        else
            print("Invalid choice. Please try again.")
        end
    end
end

main()
