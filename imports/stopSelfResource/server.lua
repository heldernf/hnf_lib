function hnf.stopSelfResource(reason)
    local hnfDirect = exports[hnf.libResourceName]:GetDirectObject({"stopSelfResource"})
    hnfDirect.stopSelfResource(hnf.cache.resource, reason)
end