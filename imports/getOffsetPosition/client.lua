function HNF.getOffsetPosition(center, distance, angle)
    assert(not center or type(center) ~= "vector", "")

    local radio = math.rad(angle)
    local x = center.x + distance * math.cos(radio)
    local y = center.y + distance * math.sin(radio)
    return vector2(x, y)
end