-- ErrorLogger.lua
-- Persists recent ManyCrabs errors so they can be reported after /reload or relog.

local ADDON_NAME, NS = ...

local MAX_ERRORS = 50
local previousErrorHandler = geterrorhandler()

local function IsOurError(message, stack)
    local text = (tostring(message) .. "\n" .. (stack or "")):lower()
    return text:find("manycrabs", 1, true) ~= nil
        or text:find("nospider", 1, true) ~= nil
end

local function RecordError(message, stack)
    if not IsOurError(message, stack) then return end

    if type(NoSpiderErrorLog) ~= "table" then
        NoSpiderErrorLog = {}
    end

    local entry = {
        time = date("%Y-%m-%d %H:%M:%S"),
        message = tostring(message),
        stack = stack,
    }
    table.insert(NoSpiderErrorLog, entry)
    while #NoSpiderErrorLog > MAX_ERRORS do
        table.remove(NoSpiderErrorLog, 1)
    end
end

seterrorhandler(function(message)
    local stack = debugstack(2, 30, 30)
    RecordError(message, stack)

    -- Preserve Blizzard's (or another add-on's) normal error display behavior.
    if previousErrorHandler then
        return previousErrorHandler(message)
    end
end)

function NS.GetErrorLog()
    return NoSpiderErrorLog or {}
end

function NS.ClearErrorLog()
    NoSpiderErrorLog = {}
end

function NS.PrintErrorLog()
    local log = NS.GetErrorLog()
    if #log == 0 then
        print("|cFFFFCC00ManyCrabs:|r No captured errors.")
        return
    end

    print("|cFFFFCC00ManyCrabs:|r " .. #log .. " captured error(s), newest first:")
    for i = #log, 1, -1 do
        local entry = log[i]
        print(string.format("[%s] %s", entry.time or "?", entry.message or "Unknown error"))
    end
    print("|cFFFFCC00ManyCrabs:|r Full details are saved in NoSpiderErrorLog in SavedVariables.")
end