local function loadModule(self, key)
    local sharedChunk = LoadResourceFile(self.resourceName, ("%s/shared.lua"):format(self.moduleToLoad))

    local contextChunk, targetContextFile = nil, "shared"
    if not sharedChunk then
        contextChunk = LoadResourceFile(self.resourceName, ("%s/%s.lua"):format(self.moduleToLoad, self.context))
        targetContextFile = self.context
    end

    assert(not (not contextChunk and not sharedChunk), ("Not found module (%s)"):format(key))

    local module, err = load(sharedChunk or contextChunk, ("@@%s/%s/%s.lua"):format(self.resourceName, self.moduleToLoad, targetContextFile))
    if module and not err then
        module()
        return
    end

    print("^1" .. err)
end

hnf = setmetatable({
    context = IsDuplicityVersion() and "server" or "client",
    resourceName = "hnf_lib"
}, {
    __index = function(self, key)
        self.moduleToLoad = "imports/" .. key
        local success, result = pcall(loadModule, self, key)
        self.moduleToLoad = nil

        if not success then
            print("^1" .. result)
        end

        return rawget(self, key)
    end
})

hnf.cache = {
    resource = GetCurrentResourceName()
}