local function loadModule(self, moduleName)
    local sharedChunk = LoadResourceFile(self.resourceName, ("%s/shared.lua"):format(self.moduleToLoad))

    local contextChunk, targetContextFile = nil, "shared"
    if not sharedChunk then
        contextChunk = LoadResourceFile(self.resourceName, ("%s/%s.lua"):format(self.moduleToLoad, self.context))
        targetContextFile = self.context
    end

    if not contextChunk and not sharedChunk then
        print(("^1Module (%s) not found in %s"):format(moduleName, self.resourceName))  
        return
    end

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
    __index = function(self, moduleName)
        self.moduleToLoad = "imports/" .. moduleName
        local success, result = pcall(loadModule, self, moduleName)
        self.moduleToLoad = nil

        if not success then
            print("^1" .. result)
        end

        return rawget(self, moduleName)
    end
})

hnf.cache = {
    resource = GetCurrentResourceName()
}