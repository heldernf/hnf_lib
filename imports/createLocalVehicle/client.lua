function hnf.createLocalVehicle(vehicle, location)
    local promise = promise:new()

    ESX.Game.SpawnLocalVehicle(vehicle.model, location.xyz, location.w, function(vehicleEntity)
        ESX.Game.SetVehicleProperties(vehicleEntity, vehicle)
        promise:resolve(vehicleEntity)
    end)

    return Citizen.Await(promise)
end