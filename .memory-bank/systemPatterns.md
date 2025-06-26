# System Patterns

## Architecture

The project follows a modular architecture, separating concerns into distinct Lua modules. The `main.lua` acts as the entry point, orchestrating the game selection and execution through an `Engine` module.

## Design Patterns

- **Module Pattern:** Each significant component (e.g., `Engine`, `Game`, `Highscore`, `UI`, `Utils`) is encapsulated within its own Lua module, returning a table of public functions and variables.
- **Event-Driven (Implicit):** While not a formal event bus, the `Engine` implicitly handles game transitions and interactions based on user input, triggering different game modules.
- **Singleton (Implicit):** The `Highscore` and `JSON` modules might be treated as implicit singletons, as their state is globally accessible and shared across the application.

## Key Technical Decisions

- **Lua as the Core Language:** Chosen for its simplicity, lightweight nature, and ease of embedding.
- **Text-Based UI:** Focus on command-line interaction for simplicity and broad compatibility.
- **JSON for Highscores:** Using a simple JSON file for persistent high score storage.