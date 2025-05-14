local function checkParams(tableCheck, allRules)
    if type(tableCheck) ~= "table" then
        error(("Invalid parameter: 'tableCheck'. Expected type 'table', got '%s'"):format(type(tableCheck)), 0)
    end

    if type(allRules) ~= "table" then
        error(("Invalid parameter: 'rules'. Expected type 'table', got '%s'"):format(type(allRules)), 0)
    elseif not next(allRules) then
        error("Invalid parameter: 'rules'. No rules provided (the rules is empty)", 0)
    end
end

local function getTablePath(key, path)
    local keyType = type(key)
    local keyTypeCanBeOrChangeToNumber = tonumber(key) ~= nil
    local keyPrimitiveType, brackets

    if keyTypeCanBeOrChangeToNumber then
        keyPrimitiveType = keyType == "string" and "'%s'" or "%d"
        brackets = true
    end

    if not path then
        key = not brackets and ("<root>.%s"):format(key) or ("<root>[" .. keyPrimitiveType .."]"):format(key)
    else
        key = not brackets and ("%s.%s"):format(path, key) or ("%s[" .. keyPrimitiveType .. "]"):format(path, key)
    end
    return key
end

local function getExpectedTypes(rule, path)
    local ruleType = type(rule)

    if ruleType == "string" then
        return { rule }
    elseif ruleType == "table" and rule._type then
        return rule._type or { rule._type }
    elseif ruleType == "table" and #rule > 0 then
        return rule
    else
        local textError =
        "Invalid parameter: 'rules' at path '%s'. Expected 'string' or 'table(dict)' or 'table(array)', got '%s'"
        error((textError):format(path, ruleType), 0)
    end
end

local typesCfxLua = {
    ["nil"] = true,
    ["number"] = true,
    ["string"] = true,
    ["boolean"] = true,
    ["table"] = true,
    ["function"] = true,
    ["thread"] = true,
    ["userdata"] = true,
}

local function validateValue(valueType, expectedTypes, path)
    for _, type in ipairs(expectedTypes) do
        if not typesCfxLua[type] then
            local textError = "Invalid parameter: 'rules' at path '%s'. Expected any CFXLua primitive type, got %s"
            error(textError:format(path, type), 0)
        end

        if valueType == type then return true end
    end
end

local function checkValueTypeMatch(tableCheck, key, rule, path)
    if tableCheck[key] == nil then return false, { reason = "nil-key", currentType = "nil", path = path } end

    local valueType = type(tableCheck[key])
    local expectedTypes = getExpectedTypes(rule, path)
    local isValidValue = validateValue(valueType, expectedTypes, path)
    if not isValidValue then
        return false, {
            reason = "invalid-value-type",
            currentType = valueType,
            expectedTypes = expectedTypes,
            path = path,
        }
    else
        return true, valueType
    end
end

local function processState(processingState, tableCheck, key, isValidValue, valueData)
    if not next(processingState) then
        processingState.remainingKeys = 0
        for k, v in pairs(tableCheck) do
            processingState.remainingKeys = 1 + processingState.remainingKeys
        end
        return processingState
    else
        processingState.remainingKeys = 1 - processingState.remainingKeys
        if processingState.remainingKeys == 0 then processingState.remainingKeys = nil end
        processingState[key] = { isValidValue = isValidValue, data = valueData }
        return processingState
    end
end

local function validateTableAndRules(tableCheck, allRules, path, stopIfInvalid)
    checkParams(tableCheck, allRules)

    local finalData, processingState = {}, {}
    for key, rule in pairs(allRules) do
        path = getTablePath(key, path)

        local isValidValue, valueData = checkValueTypeMatch(tableCheck, key, rule, path)
        if rule._handler then rule._handler(tableCheck, key, isValidValue, valueData) end
        if stopIfInvalid and not isValidValue then
            return isValidValue, valueData
        elseif not isValidValue then
            table.insert(finalData, valueData)
        end

        local valueType = valueData.currentType or valueData
        if valueType == "table" and next(tableCheck[key]) then
            local allRulesClean = rule
            allRulesClean._type = nil
            allRulesClean._handler = nil
            allRulesClean._groupHandler = nil
            isValidValue, valueData = validateTableAndRules(tableCheck[key], allRulesClean, path, stopIfInvalid)

            if rule._groupHandler then
                processingState = processState(processingState, tableCheck, key, isValidValue, valueData)
                if not processingState.remainingKeys then rule._groupHandler(tableCheck, key, processingState) end
            end

            if stopIfInvalid and not isValidValue then
                return isValidValue, valueData
            elseif not isValidValue then
                table.insert(finalData, valueData)
            end
        end
    end

    return #finalData == 0, #finalData > 0 and finalData or nil
end

function hnf.validateTableWithRules(tableCheck, allRules, stopIfInvalid)
    stopIfInvalid = stopIfInvalid ~= false
    return validateTableAndRules(tableCheck, allRules, nil, stopIfInvalid)
end