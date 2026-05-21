---@param ped number
---@param armour number
---@return nil
function x.SetPedArmourSync(ped, armour)
    SetPedArmour(ped, armour)
    while GetPedArmour(ped) ~= armour do Wait(0) end
end