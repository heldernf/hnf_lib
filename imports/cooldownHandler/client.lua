local antiSpamTimers = {}
function hnf.cooldownHandler(waitTime)
    local callingFunction = debug.getinfo(2, "n").name or "unknown"

    if antiSpamTimers[callingFunction] then return end
    antiSpamTimers[callingFunction] = true

    CreateThread(function()
        Wait(waitTime or 500)
        antiSpamTimers[callingFunction] = nil
    end)

    return true
end