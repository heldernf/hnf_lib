Direct = { tst = "oiiie" }

exports("GetDirectObject", function(target)
    local directObject = {}

    if target and type(target) == "table" and #target > 0 then
        for i, _target in pairs(target) do
            directObject[_target] = Direct[_target]
        end
    else
        directObject = Direct
    end

    return directObject
end)