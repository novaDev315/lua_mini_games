
local utils = {}

function utils.clear_screen()
    os.execute("clear")
end

function utils.trim(text)
    return text:match("^%s*(.-)%s*$")
end

return utils
