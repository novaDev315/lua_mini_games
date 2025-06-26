local Engine = require("lib.engine")

local engine = Engine:new()

engine:register_game("Typing Game", "typing_game.main")
engine:register_game("Vim Key Mapping Game", "vim_key_mapping_game.main")

engine:run()