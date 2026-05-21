local langLib = LANG_LIB
local resourceName, context = cache.resource, hnf.context

local cachedConfig = {}

local Config = {}
function Config:new(path)
    local fullPath = '@' .. resourceName .. '/configs/'

    if path ~= nil then
        assert(type(path) == 'string', 'Param "path" must be a string.')
        assert(path ~= '', 'Param "path" cannot be an empty string.')

        local formattedPath = path:gsub('%.', '/')
        fullPath = fullPath .. formattedPath .. '/'
    end
    fullPath = fullPath .. '%s.lua'

    return setmetatable({
        path = path,
        sharedFullPath = fullPath:format('shared'),
        contextFullPath = fullPath:format(context),
    }, { __index = self })
end

function Config:load()
    local config = {}

    for _, targetConfig in ipairs({ 'shared', 'context' }) do
        local fullPathIndexName = targetConfig .. 'FullPath'

        local contextConfigExist = LoadResourceFile(resourceName, self[fullPathIndexName]:gsub('@.-/', ''))
        if contextConfigExist then
            config[targetConfig] = require(self[fullPathIndexName]:gsub('%.lua$', ''):gsub('/', '.'))
        end
    end

    return config.shared, config.context
end

function Config:isValid(sharedConfig, contextConfig)
    local configs = { shared = sharedConfig, context = contextConfig }

    if configs.shared == nil and configs.context == nil then
        return false, langLib('missingConfigFiles', self.path or '<root>', self.sharedFullPath, self.contextFullPath)
    end

    local isValid = {}
    for configContext, config in pairs(configs) do
        local configType = type(config)
        local fullPathIndexName = configContext .. 'FullPath'

        if configType ~= 'table' then return false, langLib('configMustBeTable', self[fullPathIndexName], configType) end
        if not next(config) then return false, langLib('configIsEmptyTable', self[fullPathIndexName]) end

        isValid[configContext] = true
    end

    return isValid
end

function Config:require()
    local config = self:getCacheConfig(self.path or 'root')
    if config then return config end

    local sharedConfig, contextConfig = self:load()
    local isValid, errMessage = self:isValid(sharedConfig, contextConfig)
    if not isValid then error(errMessage) end

    return self:setCacheConfig(self.path or 'root', (isValid.shared and isValid.context) and
        table.merge(sharedConfig, contextConfig) or
        (sharedConfig or contextConfig)
    )
end

function Config:GetKeysFromPath(path)
    local keys = {}

    for key in path:gmatch('[^%.]+') do
        table.insert(keys, key)
    end

    return keys
end

function Config:getCacheConfig(path)
    local keys = self:GetKeysFromPath(path)

    local current
    for i, key in ipairs(keys) do
        if i == 1 and not current then current = cachedConfig end

        if not current[key] then return nil end
        current = current[key]
    end

    return current
end

function Config:setCacheConfig(path, value)
    local keys = self:GetKeysFromPath(path)

    local current = cachedConfig
    for i, key in ipairs(keys) do
        if i == #keys then
            current[key] = value
            return current[key]
        end

        if type(current[key]) ~= 'table' then
            current[key] = {}
        end

        current = current[key]
    end
end

local function requireConfig(path)
    local config = Config:new(path)
    local folderNameType = type(path)

    if folderNameType == 'table' then
        assert(lib.array.isArray(path), 'Parameter "path" must be an table<array>. Received "table".')
        assert(next(path), 'Parameter "path" is an empty table<array>.')

        local targetConfigs = {}
        for i, name in ipairs(path) do
            assert(type(name) == 'string',
                ('Parameter "path" at index %d must be a string. Received "%s".'):format(i, type(name)))

            targetConfigs[name] = config:require()
        end

        return targetConfigs
    elseif folderNameType == 'string' or folderNameType == 'nil' then
        return config:require()
    else
        error(('Parameter "path" must be a string, table<array> or nil. Received "%s".'):format(folderNameType))
    end
end

hnf.requireConfig = setmetatable({}, {
    __call = function(_, path)
        return requireConfig(path)
    end
})
