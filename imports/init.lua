local hnfDefault = {
    context = IsDuplicityVersion() and 'server' or 'client',
    libResourceName = 'hnf_lib'
}

-- todo: se ja tiver o ox_lib iniciado entt n faz nada, senão inicializa ele aqui

lib.locale()

function LANG_LIB(key, ...)
    local result = locale(key, ...)

    if result == key then
        lib.getLocale(hnfDefault.libResourceName, key)
        result = locale(key, ...)
    end

    return result
end
local langLib = LANG_LIB

local function loadModule(self)
    local sharedChunk = LoadResourceFile(self.libResourceName, ('%s/shared.lua'):format(self.moduleToLoad))

    local chunkContext, targetContext = nil, 'shared'
    if not sharedChunk then
        chunkContext = LoadResourceFile(self.libResourceName, ('%s/%s.lua'):format(self.moduleToLoad, self.context))
        targetContext = self.context
    end

    if not chunkContext and not sharedChunk then
        -- todo: transformar os prints de erro em [ERROR]
        -- todo: os erros não podem mostrar a stack de execução, depdendendo do erro isso.
        -- Com base nisso talvez deva descer o erro até a primeira chamada e então chamar error()
        print(('^1Not found module "%s" (@%s/%s). Module don\'t exists or module name is wrong.'):format(self.moduleRef, self.libResourceName, self.moduleToLoad))
        return
    end

    local module, err = load(
        sharedChunk or chunkContext,
        ('@@%s/%s/%s.lua'):format(self.libResourceName, self.moduleToLoad, targetContext)
    )
    if module and not err then
        module()
        return true
    end

    print('^1' .. err .. '^7')
end

local function resolveModule(self, moduleRef)
    self.moduleRef = moduleRef
    self.moduleToLoad = 'imports/' .. moduleRef:gsub('(%l)(%u)', function(lower, upper)
        return lower .. '_' .. upper:lower()
    end)

    -- todo: trocar pelo o proprio pcall da lib aqui
    local success, result = pcall(loadModule, self)

    self.moduleToLoad = nil
    self.moduleRef = nil

    if not success then print('^1' .. result .. '^7') end

    return rawget(self, moduleRef)
end

hnf = setmetatable(hnfDefault, { __index = resolveModule })
