# Active Context

## Current Work Focus

The primary focus of the current work is to establish a robust and modular framework for mini-games. This involves:

- **Refactoring:** Reorganizing the project structure for better maintainability and scalability.
- **Engine Implementation:** Developing a core `Engine` module to manage game registration, selection, and execution.
- **Utility Modules:** Creating shared utility modules for common functionalities like UI, high scores, and JSON handling.

## Recent Changes

- Introduced a new `Engine` module in `lib/engine.lua`.
- Updated `main.lua` to utilize the new `Engine` for game management.
- Reorganized the `lib` directory, adding `game.lua`, `highscore.lua`, `json.lua`, `ui.lua`, and `utils.lua`.
- Removed `common.lua` and `helper.lua`.
- Added initial project documentation files (`.rules`, `GEMINI.md`, `.memory-bank/*`, `highscores.json`).

## Next Steps

- Implement the core logic for the `Engine` module.
- Integrate existing games (Typing Game, Vim Key Mapping Game) with the new `Engine`.
- Develop the high score functionality.
- Enhance the user interface for game selection and in-game interactions.
