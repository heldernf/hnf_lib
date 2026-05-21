AddEventHandler('__hnf_lib:Helper:StopSelfResource', function(resourceName)
    Wait(500) -- Mandatory
    print(('^3 Stopping "%s". Stop requested by the resource itself (%s).^7'):format(resourceName, resourceName))
    StopResource(resourceName)
end)

local function stopSelfResource(resourceName, reason)
    TriggerEvent('__hnf_lib:Helper:StopSelfResource', resourceName)
end

exports('stopSelfResource', stopSelfResource)
