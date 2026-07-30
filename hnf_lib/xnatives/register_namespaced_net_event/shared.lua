local resource = cache.resource

--[[
Como terei também o x.AddNamespacedEventHandler, quero poder fazer uma pasta que engloba
o register_namespaced_net_event/ e o add_namespaced_event_handler/ e não so isso, mas
ao chamar um dos dois, ele roda um codigo que serve para os dois e esse codigo deve está
em uma outra pasta queo o nome dela ja indique que é exclusivo para algo interno ali, tipo
um helper porem para as xnatives, entt é um helper para um grupo que é essas duas pastas
e também deve existir um helper para o singular, entt para cada xnative que precisar de um
helper, tipo os imports.

Além disso, devo ter dois tipos de helpers, um que é em tempo de execução e o outro que
é apenas quando o modulo é chamado

Também devo fazer os triggers rapido assim como esses sets rapidos de eventos.
]]
local function GetEventName(name)
    -- add config da lib aqui e ele deve usar o proprio requireConfig
    if Config.UseSidePrefix then
        return string.format("%s:%s:%s", resource, IsDuplicityVersion() and "server" or "client", name)
    end

    return string.format("%s:%s", resource, name)
end

function x.RegisterNamespacedNetEvent(name, ...)
    local finalName = GetEventName(name)
    RegisterNetEvent(finalName, ...)
end
