---@param blip table
---@param blip.postion vector3
---@param blip.sprite int | string -- todo: test
---@param blip.size float
---@param blip.color int
---@param blip.name string
---@return handle newBlip -- todo: test
function hnf.createBlip(blip)
    local createdBlip = AddBlipForCoord(blip.position)
    SetBlipSprite(createdBlip, blip.sprite)
    SetBlipDisplay(createdBlip, 4)
    SetBlipScale(createdBlip, blip.size)
    SetBlipColour(createdBlip, blip.color)
    SetBlipAsShortRange(createdBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(blip.name)
    EndTextCommandSetBlipName(createdBlip)
    return createdBlip
end