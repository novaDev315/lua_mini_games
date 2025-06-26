local utils = require("lib.utils")

local UI = {}

-- ANSI escape codes for colors
UI.colors = {
    reset = "\027[0m",
    black = "\027[30m",
    red = "\027[31m",
    green = "\027[32m",
    yellow = "\027[33m",
    blue = "\027[34m",
    magenta = "\027[35m",
    cyan = "\027[36m",
    white = "\027[37m",
    bright_black = "\027[90m",
    bright_red = "\027[91m",
    bright_green = "\027[92m",
    bright_yellow = "\027[93m",
    bright_blue = "\027[94m",
    bright_magenta = "\027[95m",
    bright_cyan = "\027[96m",
    bright_white = "\027[97m",
}

-- Function to get terminal width (approximation)
function UI:get_terminal_width()
    -- This is a common default, but can be made dynamic if needed
    return 80
end

-- Function to center text
function UI:center_text(text, width)
    width = width or self:get_terminal_width()
    local text_len = #text
    local padding = math.max(0, math.floor((width - text_len) / 2))
    return string.rep(" ", padding) .. text .. string.rep(" ", width - text_len - padding)
end

-- Function to draw a border
function UI:draw_border(width, char)
    width = width or self:get_terminal_width()
    char = char or "-"
    print(string.rep(char, width))
end

-- Function to display a title
function UI:display_title(title)
    utils.clear_screen()
    self:draw_border()
    print(self:center_text(title))
    self:draw_border()
    print("\n")
end

-- Function to display a message with color
function UI:display_message(message, color)
    color = color or UI.colors.reset
    print(color .. message .. UI.colors.reset)
end

return UI
