# Progress

## What Works

- The project structure has been refactored to be more modular.
- The `Engine` module is in place to manage game registration and execution.
- Basic utility modules for UI, JSON, and high scores are available.
- The `main.lua` file has been updated to use the new `Engine`.

## What's Left to Build

- Implement the core logic within the `Engine` module to handle game selection and execution flow.
- Integrate the existing Typing Game and Vim Key Mapping Game with the new `Engine`.
- Develop the full high score functionality (saving, loading, displaying).
- Enhance the user interface for a better game selection and in-game experience.

## Current Status

The project is in a refactoring phase, establishing a solid foundation for future game development. The core structure is in place, and the next steps involve integrating existing games and implementing core functionalities.

## Known Issues

- Existing games are not yet integrated with the new `Engine` and will not run directly.
- High score functionality is not yet implemented.
- The UI is currently minimal and requires further development.
