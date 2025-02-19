---@param entity number | string -- todo: test
---@param coords vector3 | vector4
function HNF.setEntityAtCoords(entity, coords)
    if not DoesEntityExist(entity) then return end
    if coords.xyz then SetEntityCoords(entity, coords.xyz) end
    if coords.w then SetEntityHeading(entity, coords.w) end
end