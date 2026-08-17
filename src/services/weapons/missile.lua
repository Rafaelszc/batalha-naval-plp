local Missile = {}
Missile.__index = Missile

function Missile.new()
    return setmetatable({}, Missile)
end

function Missile:fire(board, x, y)
    return board:receive_area_shot(x, y, 1) -- 2x2 area centered on x,y
end

return Missile
