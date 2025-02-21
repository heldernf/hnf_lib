local bussyDimensions = {}
local function getFreeDimension()
    local targetDimension = 1

    for _, bussyDimension in ipairs(bussyDimensions) do
        if bussyDimension == targetDimension then
            targetDimension = targetDimension + 1
        else
            break
        end
    end

    return targetDimension
end

function hnf.setPlayerAtFreeBucket(source)
    local freeDimension = getFreeDimension(source)
    table.insert(bussyDimensions, freeDimension)
    table.sort(bussyDimensions)

    SetPlayerRoutingBucket(source, freeDimension)
    return true
end

-- todo: add o return player to default dimension com self
function hnf.returnPlayerToDefaultDimension(source)
    local playerCurrentDimension = GetPlayerRoutingBucket(source)
    for i, bussyDimension in pairs(bussyDimensions) do
        if bussyDimension == playerCurrentDimension then
            table.remove(bussyDimensions, i)
        end
    end

    SetPlayerRoutingBucket(source, 0)
end