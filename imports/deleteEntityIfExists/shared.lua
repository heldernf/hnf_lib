function HNF.Utils.deleteEntityIfExists(entity)
    if DoesEntityExist(entity) then DeleteEntity(entity) end
end