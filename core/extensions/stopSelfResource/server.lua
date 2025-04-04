AddEventHandler("__hnf_lib:DIRECT:stopSelfResource", function(resourceName)
    Wait(500)
    StopResource(resourceName)
end)

function Direct.stopSelfResource(resourceName)
    TriggerEvent("__hnf_lib:DIRECT:stopSelfResource", resourceName)
end