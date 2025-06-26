# System Patterns

The project uses a simple game engine pattern. The engine is responsible for managing the game loop and the game states. Each game is a separate module that implements a `run_game` function. The engine loads the games and displays a menu to the user. When the user selects a game, the engine calls the `run_game` function for that game.
