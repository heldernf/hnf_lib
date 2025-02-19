-- pcall ja com o if success
function HNF.Utils.pcall(func, ...)
    local success, returnData = pcall(function(...)
        return table.pack(func(...))
    end, ...)
    if success then return table.unpack(returnData) end

    HNF.Utils.informFail({ index = "pcallFailed", params = {returnData} })
end