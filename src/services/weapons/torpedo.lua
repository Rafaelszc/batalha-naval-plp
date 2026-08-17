local Torpedo = {}
Torpedo.__index = Torpedo

function Torpedo.new()
    return setmetatable({}, Torpedo)
end

function Torpedo:fire(board, x, y, is_horizontal)
    return board:receive_line_shot(x, y, is_horizontal)
end

return Torpedo
