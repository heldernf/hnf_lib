-- pcall ja com o if success
function hnf.pcall(func, ...)
    local success, returnData = pcall(function(...)
        return table.pack(func(...))
    end, ...)
    if success then return table.unpack(returnData) end
end