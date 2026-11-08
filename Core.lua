-- Core.lua
-- NoSpider: Core Logic for Arachnophobia Mode Add-on
-- Nameplate-based 3D model occlusion + automatic detection

local ADDON_NAME, NS = ...

-- ============================================
-- Basic Settings
-- ============================================
local defaults = {
    enabled = true,
    overlayAlpha = 0.95,          -- Overlay Opacity
    namePatternMatch = true,      -- Name-based pattern matching
    warningSound = true,          -- beep
    warningMessage = true,        -- warning message
    overlayColor = { 0.35, 0.55, 0.35 },  -- Overlay color (green color)
    overlayWidth = 180,           -- Overlay horizontal size
   overlayHeight = 260, -- Overlay vertical size (to cover entire model) 
    coverPortrait = true, -- also cover target/focus portrait 
    autoEnableNameplates = true, -- Automatically enable enemy nameplates 
    zoneWarning = true, -- Zone warning banner 
    spawnProximityWarning = true, -- Spawn coordinate approach warning 
    spawnProximityMeters = 100, -- Proximity warning radius (meters)
    combatLogDetection = true,    -- Battle log secondary detection
    deadSpiderWarning = true,     -- Dead spider hover warning
    zoneWarningSound = false,     -- local warning sound
    warningCooldown = 2,          -- Global Warning Cooldown (seconds)
    warnedNpcCooldown = 60,       -- Same Type Spider Re-Warning Cooldown (Seconds)
    scanInterval = 1.5,           -- Nameplate rescan cycle (seconds)
    showMapPins = true,           -- World map shows spider infestation areas
    showNPCList = true,           -- World map spider NPC list display
    dungeonPinSize = 16,          -- Dungeon Pin Icon Size
    dungeonPinOffset = 2.0,       -- Dungeon Pin Offset (%)
    heatmapGranularity = 3,       -- Heatmap resolution (1=low 25, 2=normal 50, 3=high 75, 4=very high 100)
    heatColorLo = { 1, 0.6, 0 },  -- Heatmap low-density color (orange)
    heatColorHi = { 1, 0.1, 0 },  -- Heatmap High Density Color (Red)
    zoneWarningWidth = 260,       -- Warning banner horizontal size
    zoneWarningHeight = 24,       -- Warning banner vertical size
    zoneWarningFontSize = 11,     -- Warning banner font size
    warnZoneBgColor = { 0.5, 0.4, 0.1, 0.50 },        -- Local warning banner background color
    warnProximityBgColor = { 0.4, 0.1, 0.1, 0.65 },    -- Approach warning banner background color
    zoneWarningPos = nil,         -- Alert banner position (nil=default, {point,x,y})
    npcListPos = nil,             -- NPC list location (nil=default, {point,x,y})
    customIDs = {},
    customZones = {},    -- [uiMapID] = true
}

-- ============================================
-- Local Reference (Performance)
-- ============================================
local UnitGUID = UnitGUID
local UnitName = UnitName
local UnitExists = UnitExists
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local strsplit = strsplit
local select = select
local tonumber = tonumber
local strlower = string.lower
local strfind = string.find
local pairs = pairs
local IsItemInRange = IsItemInRange
local UnitCanAttack = UnitCanAttack
local strformat = string.format
local C_Map = C_Map

-- status tracking
local activePlates = {}     -- [nameplate] = overlayFrame
local plateUnitMap = {}     -- [unitToken] = nameplate
local warnedNPCIDs = {}     -- [npcID] = expireTime (per-NPC ID warning cooldown)
local processedCombatGUIDs = {} -- [guid] = expireTime (Battle log processing cache)

-- Battle log subevent whitelist
local COMBAT_SUBEVENT_ALLOW = {
    SWING_DAMAGE = true,
    SPELL_DAMAGE = true,
    SPELL_CAST_START = true,
    SPELL_CAST_SUCCESS = true,
    SPELL_SUMMON = true,
    UNIT_DIED = true,
    RANGE_DAMAGE = true,
    SPELL_MISSED = true,
}

-- ============================================
-- utility function
-- ============================================
local function GetNPCID(unit)
    local guid = UnitGUID(unit)
    if not guid then return nil end
    local id = select(6, strsplit("-", guid))
    return tonumber(id)
end

local function IsSpiderByID(npcID)
    if not npcID then return false end
    if NS.SpiderIDs[npcID] then return true end
    if NoSpiderDB and NoSpiderDB.customIDs then
        return NoSpiderDB.customIDs[npcID] == true
    end
    return false
end

local function IsSpiderByName(unit)
    if not NoSpiderDB or not NoSpiderDB.namePatternMatch then return false end
    local name = UnitName(unit)
    if not name then return false end
    name = strlower(name)
    for _, pattern in pairs(NS.SpiderNamePatterns) do
        if strfind(name, strlower(pattern), 1, true) then
            return true
        end
    end
    return false
end

local function IsSpider(unit)
    if not unit then return false end
    local npcID = GetNPCID(unit)
    if IsSpiderByID(npcID) then return true end
    if IsSpiderByName(unit) then return true end
    return false
end

NS.IsSpider = IsSpider
NS.GetNPCID = GetNPCID

-- ============================================
-- distance estimation system
-- ============================================
-- Estimate the distance to the enemy with IsItemInRange(itemID, unit).
-- If you call it by item ID, it works even if you don't have it.
-- LibRangeCheck-3.0 (WeakAuras) Reference item list.
-- Return value: true=within range, false=outside range, nil=unable to determine

-- Item for checking distance to enemy {distance (m), item ID}
-- Sort in ascending order of distance (check from shortest distances first)
local RANGE_ITEMS = {
    { 5, 8149},   -- Voodoo Charm
    {10, 9606},   -- Treant Muisek Vessel
    {15, 4559},   -- Hydrocane
    {20, 10645},  -- Gnomish Death Ray
    {25, 13289},  -- Egan's Blaster
    {30, 835},    -- Large Rope Net
    {35, 8688},   -- Fate Rune
    {40, 4945},   -- Skin of Shadow
}

local function EstimateRange(unit)
    if not UnitExists(unit) or not UnitCanAttack("player", unit) then
        return nil
    end

    local lastRange = 0
    for _, data in ipairs(RANGE_ITEMS) do
        local range, itemID = data[1], data[2]
        local inRange = IsItemInRange(itemID, unit)
        if inRange == true then
            if lastRange == 0 then
                return strformat("< %dm", range)
            else
                return strformat("~%dm", (lastRange + range) / 2)
            end
        elseif inRange == false then
            lastRange = range
        end
        -- If nil, the item cannot be judged, then
    end

    if lastRange > 0 then
        return strformat("> %dm", lastRange)
    end

    return nil
end

-- ============================================
-- Nameplate Model Cover Overlay
-- ============================================
-- Nameplate is rendered above the unit's head.
-- Offset the overlay down from the nameplate
-- Method of covering the 3D model (torso + legs).

local overlayPool = {}

local function CreateOverlayFrame()
    local frame = table.remove(overlayPool)
    if not frame then
        frame = CreateFrame("Frame", nil, UIParent)
        frame:SetFrameStrata("TOOLTIP")

        -- outline
        local border = frame:CreateTexture(nil, "BACKGROUND")
        border:SetPoint("TOPLEFT", frame, "TOPLEFT", -3, 3)
        border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 3, -3)
        frame.border = border

        -- main background
        local bg = frame:CreateTexture(nil, "ARTWORK")
        bg:SetAllPoints(frame)
        frame.bg = bg

        -- alternative icon
        local icon = frame:CreateTexture(nil, "OVERLAY")
        icon:SetSize(100, 100)
        icon:SetPoint("CENTER", frame, "CENTER", 0, 16)
        icon:SetTexture("Interface\\AddOns\\NoSpider\\textures\\spidercover")
        frame.icon = icon

        -- safe text
        local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("CENTER", frame, "CENTER", 0, -14)
        text:SetFont(NS.FONT_KR, 12, "OUTLINE")
        text:SetText(NS.C.LIGHTGREEN .. "안전" .. NS.C.R)
        frame.text = text

        -- NPC name (top of overlay)
        local nameText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        nameText:SetPoint("TOP", frame, "TOP", 0, -8)
        nameText:SetFont(NS.FONT_KR, 9, "OUTLINE")
        frame.nameText = nameText

        -- street text
        local distText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        distText:SetPoint("CENTER", frame, "CENTER", 0, -34)
        distText:SetFont(NS.FONT_KR, 11, "OUTLINE")
        frame.distText = distText
    end
    return frame
end

local function ApplyOverlayStyle(frame)
    local db = NoSpiderDB
    local r, g, b = unpack(db.overlayColor)
    local a = db.overlayAlpha

    frame.bg:SetColorTexture(r, g, b, a)
    frame.border:SetColorTexture(r * 0.6, g * 0.6, b * 0.6, a)
end

local function ShowNameplateOverlay(nameplate, unitToken)
    if activePlates[nameplate] then return end

    local frame = CreateOverlayFrame()
    local db = NoSpiderDB

    -- Attaches as a child of nameplate → automatically tracks location
    frame:SetParent(nameplate)
    frame:SetSize(db.overlayWidth, db.overlayHeight)
    frame:ClearAllPoints()
    -- Attached just below the nameplate
    frame:SetPoint("TOP", nameplate, "BOTTOM", 0, 0)
    frame:SetFrameLevel(nameplate:GetFrameLevel() + 20)

    ApplyOverlayStyle(frame)

    -- Display NPC name
    local name = UnitName(unitToken)
    if name then
        frame.nameText:SetText(NS.C.LIGHTGRAY .. name .. NS.C.R)
    end

    -- Distance Display OnUpdate Settings
    frame.unitToken = unitToken
    frame.distElapsed = 0
    frame.distText:SetText("")
    frame:SetScript("OnUpdate", function(self, elapsed)
        self.distElapsed = (self.distElapsed or 0) + elapsed
        if self.distElapsed < 0.2 then return end
        self.distElapsed = 0

        local rangeText = EstimateRange(self.unitToken)
        if rangeText then
            self.distText:SetText(NS.C.YELLOW .. rangeText .. NS.C.R)
        else
            self.distText:SetText("")
        end
    end)

    frame:Show()
    activePlates[nameplate] = frame
end

local function HideNameplateOverlay(nameplate)
    local frame = activePlates[nameplate]
    if frame then
        frame:SetScript("OnUpdate", nil)
        frame.unitToken = nil
        frame.distText:SetText("")
        frame:Hide()
        frame:ClearAllPoints()
        frame:SetParent(UIParent)
        table.insert(overlayPool, frame)
        activePlates[nameplate] = nil
    end
end

-- ============================================
-- Hide target/focus portrait
-- ============================================
local portraitOverlays = {}

local function CreatePortraitOverlay(portraitTexture, name)
    -- portraitTexture is a Texture object, so it is not a Frame.
    -- Take the parent Frame and create an overlay Frame there,
    -- The position is tailored to portraitTexture.
    local parentFrame = portraitTexture:GetParent()
    if not parentFrame then return nil end

    local frame = CreateFrame("Frame", "NoSpider_" .. name, parentFrame)
    frame:SetAllPoints(portraitTexture)
    frame:SetFrameStrata("DIALOG")
    frame:SetFrameLevel((parentFrame:GetFrameLevel() or 0) + 10)

    local bg = frame:CreateTexture(nil, "ARTWORK")
    bg:SetAllPoints(frame)
    frame.bg = bg

    local icon = frame:CreateTexture(nil, "OVERLAY")
    icon:SetSize(24, 24)
    icon:SetPoint("CENTER", frame, "CENTER")
    icon:SetTexture("Interface\\AddOns\\NoSpider\\textures\\spidercover")
    frame.icon = icon

    frame:Hide()
    return frame
end

local function UpdatePortraitOverlay(unitToken, portraitFrame, overlayKey)
    if not NoSpiderDB or not NoSpiderDB.enabled or not NoSpiderDB.coverPortrait then
        if portraitOverlays[overlayKey] then
            portraitOverlays[overlayKey]:Hide()
        end
        return
    end

    if not portraitFrame then return end

    if not portraitOverlays[overlayKey] then
        portraitOverlays[overlayKey] = CreatePortraitOverlay(portraitFrame, overlayKey)
        if not portraitOverlays[overlayKey] then return end
    end

    local overlay = portraitOverlays[overlayKey]
    local r, g, b = unpack(NoSpiderDB.overlayColor)
    overlay.bg:SetColorTexture(r, g, b, NoSpiderDB.overlayAlpha)

    if UnitExists(unitToken) and IsSpider(unitToken) then
        overlay:Show()
    else
        overlay:Hide()
    end
end

-- ============================================
-- warning system
-- ============================================
local lastWarningTime = 0

local function ShowWarning(unitName, npcID)
    local now = GetTime()

    -- Per-NPC ID cooldown (blocks re-warning of same type of spider)
    if npcID and warnedNPCIDs[npcID] and now < warnedNPCIDs[npcID] then return end

    -- Global Cooldown
    if now - lastWarningTime < (NoSpiderDB and NoSpiderDB.warningCooldown or 2) then return end
    lastWarningTime = now

    -- Per-NPC ID expiration time recording
    if npcID then
        warnedNPCIDs[npcID] = now + (NoSpiderDB and NoSpiderDB.warnedNpcCooldown or 60)
    end

    if NoSpiderDB.warningMessage then
        RaidNotice_AddMessage(
            RaidWarningFrame,
            NS.C.ORANGE .. "[NoSpider]" .. NS.C.R .. " 거미 감지: " .. (unitName or "?"),
            ChatTypeInfo["RAID_WARNING"]
        )
    end

    if NoSpiderDB.warningSound then
        PlaySound(8959)
    end
end

-- ============================================
-- Region-based advance warning
-- ============================================
-- A banner is always displayed at the top of the screen when entering the spider habitat subzone.
-- Get the current subzone name with GetSubZoneText() and compare it with SpiderSubZones DB.

local ZW_DEFAULTS = { point = "TOP", parent = UIParent, relPoint = "TOP", x = 0, y = -10 }

local zoneWarningFrame = CreateFrame("Frame", "NoSpiderZoneWarning", UIParent)
zoneWarningFrame:SetSize(260, 24)  -- InitDB 후 갱신됨
zoneWarningFrame:SetPoint("TOP", UIParent, "TOP", 0, -10)
zoneWarningFrame:SetFrameStrata("HIGH")

NS.MakeMovable(zoneWarningFrame, "zoneWarningPos", ZW_DEFAULTS, "경고 배너")

local zwBorder = zoneWarningFrame:CreateTexture(nil, "BACKGROUND")
zwBorder:SetPoint("TOPLEFT", -2, 2)
zwBorder:SetPoint("BOTTOMRIGHT", 2, -2)
zwBorder:SetColorTexture(0, 0, 0, 0.5)

local zwBg = zoneWarningFrame:CreateTexture(nil, "ARTWORK")
zwBg:SetAllPoints()
zwBg:SetColorTexture(unpack(NS.C.WARN_PROXIMITY_BG))

local zwText = zoneWarningFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
zwText:SetPoint("CENTER")
zwText:SetFont(NS.FONT_KR, 11, "OUTLINE")
zoneWarningFrame.text = zwText
zoneWarningFrame:Hide()

local WARNING_NONE = 0
local WARNING_ZONE = 1         -- Entering the area (mild warning)
local WARNING_PROXIMITY = 2    -- Approaching spawn coordinates (strong warning)

local currentWarningLevel = WARNING_NONE

function NS.UpdateZoneWarningStyle()
    local w = NoSpiderDB and NoSpiderDB.zoneWarningWidth or 260
    local h = NoSpiderDB and NoSpiderDB.zoneWarningHeight or 24
    local fs = NoSpiderDB and NoSpiderDB.zoneWarningFontSize or 11
    zoneWarningFrame:SetSize(w, h)
    zwText:SetFont(NS.FONT_KR, fs, "OUTLINE")
    -- Update background color to match current warning level
    if currentWarningLevel == WARNING_PROXIMITY then
        zwBg:SetColorTexture(unpack(NoSpiderDB.warnProximityBgColor))
    elseif currentWarningLevel == WARNING_ZONE then
        zwBg:SetColorTexture(unpack(NoSpiderDB.warnZoneBgColor))
    end
end
local currentZoneName = ""

local function IsSpiderZone(mapID)
    if not mapID then return false end
    if NS.SpiderZones[mapID] then return true end
    if NoSpiderDB and NoSpiderDB.customZones then
        return NoSpiderDB.customZones[mapID] == true
    end
    return false
end

-- ============================================
-- Spawn coordinate approach detection (grid-based spatial index)
-- ============================================
-- Split SpiderSpawnData coordinates (0-100) into grid cells
-- Search only cells around the player → performance close to O(1).

local spawnGridCache = {}       -- [mapID] = cells or false
local SPAWN_GRID_CELL = 5      -- Cell size from 0-100 scale
local DEFAULT_MAP_METERS = 1333 -- C_Map.GetMapWorldSize Fallback Default (Meters)

-- Convert meters to map coordinates (0-100) scale
local function MetersToMapUnits(meters, mapID)
    local w
    if C_Map.GetMapWorldSize then
        w = C_Map.GetMapWorldSize(mapID)
    end
    if not w or w <= 0 then w = DEFAULT_MAP_METERS end
    return (meters / w) * 100
end

local function GetSpawnGrid(mapID)
    if spawnGridCache[mapID] ~= nil then return spawnGridCache[mapID] end
    local spawns = NS.SpiderSpawnData and NS.SpiderSpawnData[mapID]
    if not spawns or #spawns == 0 then
        spawnGridCache[mapID] = false
        return false
    end
    local cells = {}
    for _, c in ipairs(spawns) do
        local gx = math.floor(c[1] / SPAWN_GRID_CELL)
        local gy = math.floor(c[2] / SPAWN_GRID_CELL)
        if not cells[gx] then cells[gx] = {} end
        if not cells[gx][gy] then cells[gx][gy] = {} end
        cells[gx][gy][#cells[gx][gy] + 1] = c
    end
    spawnGridCache[mapID] = cells
    return cells
end

local function IsNearSpiderSpawn(mapID, px, py, radius)
    -- px, py, radius: scale 0-100
    local cells = GetSpawnGrid(mapID)
    if not cells then return false end
    local radiusSq = radius * radius
    local cr = math.ceil(radius / SPAWN_GRID_CELL)
    local pgx = math.floor(px / SPAWN_GRID_CELL)
    local pgy = math.floor(py / SPAWN_GRID_CELL)
    for dx = -cr, cr do
        local col = cells[pgx + dx]
        if col then
            for dy = -cr, cr do
                local cell = col[pgy + dy]
                if cell then
                    for _, c in ipairs(cell) do
                        local ex, ey = c[1] - px, c[2] - py
                        if ex * ex + ey * ey <= radiusSq then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local function CheckZone()
    if not NoSpiderDB or not NoSpiderDB.enabled then
        zoneWarningFrame:Hide()
        currentWarningLevel = WARNING_NONE
        currentZoneName = ""
        return
    end

    local mapID = C_Map.GetBestMapForUnit("player")

    -- Spawn coordinate approach warning (replaces subzone warning)
    local isNearSpawn = false
    if NoSpiderDB.spawnProximityWarning and mapID then
        local pos = C_Map.GetPlayerMapPosition(mapID, "player")
        if pos then
            local px, py = pos:GetXY()
            local radius = MetersToMapUnits(NoSpiderDB.spawnProximityMeters or 100, mapID)
            isNearSpawn = IsNearSpiderSpawn(mapID, px * 100, py * 100, radius)
        end
    end

    local isSpiderZ = IsSpiderZone(mapID)

    if isNearSpawn then
        if currentWarningLevel ~= WARNING_PROXIMITY then
            currentWarningLevel = WARNING_PROXIMITY
            currentZoneName = (mapID and C_Map.GetMapInfo(mapID) and C_Map.GetMapInfo(mapID).name) or ""
            zwBg:SetColorTexture(unpack(NoSpiderDB.warnProximityBgColor))
            zwText:SetText(NS.C.ORANGE .. "[NoSpider]" .. NS.C.R .. " " .. NS.C.LIGHTYELLOW .. "[경고] 거미 출몰 좌표 접근" .. NS.C.R)
            zoneWarningFrame:Show()
            ShowWarning("거미 출몰 좌표 접근")
        end
    elseif isSpiderZ and NoSpiderDB.zoneWarning then
        local zoneName = (mapID and C_Map.GetMapInfo(mapID) and C_Map.GetMapInfo(mapID).name) or ""
        if currentWarningLevel ~= WARNING_ZONE or zoneName ~= currentZoneName then
            currentWarningLevel = WARNING_ZONE
            currentZoneName = zoneName
            zwBg:SetColorTexture(unpack(NoSpiderDB.warnZoneBgColor))
            zwText:SetText(NS.C.ORANGE .. "[NoSpider]" .. NS.C.R .. " " .. NS.C.LIGHTORANGE .. "[주의] 거미 출몰 지역" .. NS.C.R .. " - " .. zoneName)
            zoneWarningFrame:Show()
            if NoSpiderDB.zoneWarningSound then
                ShowWarning(zoneName)
            end
        end
    elseif currentWarningLevel > WARNING_NONE then
        currentWarningLevel = WARNING_NONE
        currentZoneName = ""
        zoneWarningFrame:Hide()
    end
end

-- ============================================
-- Automatically activate nameplate
-- ============================================
-- NAME_PLATE_UNIT_ADDED fires only when the nameplate appears on the screen.
-- Spiders cannot be automatically detected when the nameplate is turned off.
-- Force all relevant CVars to be set.

local function EnsureNameplatesEnabled()
    if not NoSpiderDB.autoEnableNameplates then return end

    local changed = false

    -- Show enemy nameplate
    if GetCVar("nameplateShowEnemies") ~= "1" then
        SetCVar("nameplateShowEnemies", "1")
        changed = true
    end

    -- Ensure nameplate maximum distance (default may be low)
    local maxDist = tonumber(GetCVar("nameplateMaxDistance") or "0")
    if maxDist < 60 then
        SetCVar("nameplateMaxDistance", "60")
        changed = true
    end

    -- Also display non-target nameplates (important!)
    -- TBC Anniversary may only display targets without this setting
    if GetCVar("nameplateShowAll") and GetCVar("nameplateShowAll") ~= "1" then
        SetCVar("nameplateShowAll", "1")
        changed = true
    end

    if changed then
        print(NS.C.PREFIX .. "거미 자동 감지를 위해 네임플레이트 설정을 조정했습니다.")
        print(NS.C.PREFIX .. "적 네임플레이트가 보이지 않으면 " .. NS.C.YELLOW .. "V키" .. NS.C.R .. "를 눌러주세요.")
    end
end

-- ============================================
-- 이벤트 핸들러
-- ============================================
local function OnNamePlateAdded(unitToken)
    if not NoSpiderDB or not NoSpiderDB.enabled then return end

    local nameplate = GetNamePlateForUnit(unitToken)
    if not nameplate then return end

    plateUnitMap[unitToken] = nameplate

    if IsSpider(unitToken) then
        ShowNameplateOverlay(nameplate, unitToken)
        -- 오버레이로 가려졌으므로 경고 불필요
    end
end

local function OnNamePlateRemoved(unitToken)
    local nameplate = plateUnitMap[unitToken]
    if nameplate then
        HideNameplateOverlay(nameplate)
        plateUnitMap[unitToken] = nil
    end
end

local function OnTargetChanged()
    UpdatePortraitOverlay("target", TargetFramePortrait or (TargetFrame and TargetFrame.portrait), "target")
end

local function OnFocusChanged()
    UpdatePortraitOverlay("focus", FocusFramePortrait or (FocusFrame and FocusFrame.portrait), "focus")
end

-- ============================================
-- 스캔 / 정리
-- ============================================
local function ScanExistingNameplates()
    for i = 1, 40 do
        local unitToken = "nameplate" .. i
        if UnitExists(unitToken) then
            OnNamePlateAdded(unitToken)
        end
    end
end

local function ClearAllOverlays()
    for nameplate, frame in pairs(activePlates) do
        frame:Hide()
        frame:ClearAllPoints()
        frame:SetParent(UIParent)
        table.insert(overlayPool, frame)
    end
    wipe(activePlates)
    wipe(plateUnitMap)

    for key, overlay in pairs(portraitOverlays) do
        overlay:Hide()
    end

    zoneWarningFrame:Hide()
    currentWarningLevel = WARNING_NONE
    currentZoneName = ""
end

-- ============================================
-- 주기적 네임플레이트 리스캔 (안전망)
-- ============================================
-- NAME_PLATE_UNIT_ADDED를 놓치는 경우를 대비하여
-- 1.5초마다 현재 보이는 모든 네임플레이트를 재검사.

local scanFrame = CreateFrame("Frame", nil, UIParent)
local scanElapsed = 0

scanFrame:SetScript("OnUpdate", function(self, elapsed)
    if not NoSpiderDB or not NoSpiderDB.enabled then return end

    scanElapsed = scanElapsed + elapsed
    if scanElapsed < (NoSpiderDB.scanInterval or 1.5) then return end
    scanElapsed = 0

    for i = 1, 40 do
        local unitToken = "nameplate" .. i
        if UnitExists(unitToken) then
            local nameplate = GetNamePlateForUnit(unitToken)
            if nameplate and not activePlates[nameplate] and IsSpider(unitToken) then
                plateUnitMap[unitToken] = nameplate
                ShowNameplateOverlay(nameplate, unitToken)
                -- 리스캔에서 발견 시 경고는 생략 (이미 근처에 있으므로)
            end
        end
    end

    -- 만료된 캐시 엔트리 정리
    local now = GetTime()
    for id, expire in pairs(warnedNPCIDs) do
        if now >= expire then
            warnedNPCIDs[id] = nil
        end
    end
    for guid, expire in pairs(processedCombatGUIDs) do
        if now >= expire then
            processedCombatGUIDs[guid] = nil
        end
    end

    -- 스폰 좌표 접근 검사 (주기적)
    CheckZone()
end)

-- ============================================
-- 전투 로그 보조 감지
-- ============================================
-- 전투 중 거미의 GUID가 로그에 나타나면
-- 해당 유닛의 네임플레이트를 찾아 오버레이 적용.
-- NAME_PLATE_UNIT_ADDED를 보완하는 역할.

local PROCESSED_COMBAT_GUID_COOLDOWN = 3

local function OnCombatLogEvent()
    if not NoSpiderDB or not NoSpiderDB.enabled then return end
    if not NoSpiderDB.combatLogDetection then return end

    local _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, destName = CombatLogGetCurrentEventInfo()

    -- 서브이벤트 필터링 (반복성 이벤트 조기 리턴)
    if not COMBAT_SUBEVENT_ALLOW[subEvent] then return end

    local now = GetTime()

    -- source나 dest 중 거미 NPC가 있는지 확인
    local function CheckGUID(guid, name)
        if not guid then return end

        -- Per-GUID 처리 캐시 (동일 GUID 반복 스캔 방지)
        if processedCombatGUIDs[guid] and now < processedCombatGUIDs[guid] then return end
        processedCombatGUIDs[guid] = now + PROCESSED_COMBAT_GUID_COOLDOWN

        local id = select(6, strsplit("-", guid))
        local npcID = tonumber(id)
        if not IsSpiderByID(npcID) then return end

        -- 이 NPC의 네임플레이트 찾기
        for i = 1, 40 do
            local unitToken = "nameplate" .. i
            if UnitExists(unitToken) then
                local unitGUID = UnitGUID(unitToken)
                if unitGUID == guid then
                    local nameplate = GetNamePlateForUnit(unitToken)
                    if nameplate and not activePlates[nameplate] then
                        plateUnitMap[unitToken] = nameplate
                        ShowNameplateOverlay(nameplate, unitToken)
                        -- 오버레이로 가려졌으므로 경고 불필요
                    end
                    return
                end
            end
        end

        -- 네임플레이트 밖 (먼 거리) → 사전 경고
        ShowWarning(name, npcID)
    end

    CheckGUID(sourceGUID, sourceName)
    CheckGUID(destGUID, destName)
end

-- ============================================
-- 디버그
-- ============================================
local debugMode = false

local function PrintDebugInfo()
    local p = NS.C.GREEN .. "[NoSpider Debug]" .. NS.C.R .. " "
    print(p .. "=== 상태 진단 ===")
    print(p .. "애드온 활성: " .. tostring(NoSpiderDB and NoSpiderDB.enabled))

    -- CVar 상태
    local cvars = {
        "nameplateShowEnemies",
        "nameplateShowAll",
        "nameplateMaxDistance",
        "nameplateShowFriends",
    }
    for _, cvar in pairs(cvars) do
        local val = GetCVar(cvar)
        print(p .. cvar .. " = " .. tostring(val))
    end

    -- 현재 보이는 네임플레이트 수
    local plateCount = 0
    local spiderPlateCount = 0
    for i = 1, 40 do
        local unitToken = "nameplate" .. i
        if UnitExists(unitToken) then
            plateCount = plateCount + 1
            local name = UnitName(unitToken) or "?"
            local npcID = GetNPCID(unitToken)
            local spider = IsSpider(unitToken)
            if spider then spiderPlateCount = spiderPlateCount + 1 end
            print(p .. "  nameplate" .. i .. ": " .. name .. " (ID:" .. tostring(npcID) .. ") spider=" .. tostring(spider))
        end
    end
    print(p .. "네임플레이트 총: " .. plateCount .. ", 거미: " .. spiderPlateCount)

    -- 활성 오버레이 수
    local overlayCount = 0
    for _ in pairs(activePlates) do overlayCount = overlayCount + 1 end
    print(p .. "활성 오버레이: " .. overlayCount)

    -- 타겟 정보
    if UnitExists("target") then
        local name = UnitName("target") or "?"
        local npcID = GetNPCID("target")
        local spider = IsSpider("target")
        local np = GetNamePlateForUnit("target")
        print(p .. "타겟: " .. name .. " (ID:" .. tostring(npcID) .. ") spider=" .. tostring(spider) .. " nameplate=" .. tostring(np ~= nil))
    else
        print(p .. "타겟: 없음")
    end

    -- 월드맵 핀 디버그 (월드맵이 열려있을 때만)
    if WorldMapFrame and WorldMapFrame:IsShown() then
        print(p .. "=== 월드맵 핀 디버그 ===")
        local wmID = WorldMapFrame:GetMapID()
        print(p .. "월드맵 ID: " .. tostring(wmID))

        if WorldMapFrame.EnumeratePinsByTemplate then
            local pinCount = 0
            local ok, err = pcall(function()
                for pin in WorldMapFrame:EnumeratePinsByTemplate("DungeonEntrancePinTemplate") do
                    pinCount = pinCount + 1
                    print(p .. strformat("  핀 #%d: name=%s, journalID=%s, hooked=%s",
                        pinCount,
                        tostring(pin.name),
                        tostring(pin.journalInstanceID),
                        tostring(pin._noSpiderHooked)))
                    if pin.name and NS.SpiderDungeonTooltips then
                        local match = NS.SpiderDungeonTooltips[pin.name]
                        print(p .. strformat("    매칭: %s", match and ("NPC " .. #match .. "개") or "없음"))
                    end
                end
            end)
            if not ok then
                print(p .. "|cFFFF0000EnumeratePinsByTemplate 오류: " .. tostring(err) .. "|r")
            end
            if pinCount == 0 then
                print(p .. "던전 핀 없음")
            end
        end

        if WorldMapFrame.pinPools then
            print(p .. "--- 핀 템플릿 ---")
            for template, pool in pairs(WorldMapFrame.pinPools) do
                local n = 0
                if pool.activeObjects then
                    for _ in pairs(pool.activeObjects) do n = n + 1 end
                end
                if n > 0 then
                    print(p .. strformat("  %s: %d개", template, n))
                end
            end
        end
    end

    print(p .. "=== V키를 눌러 적 네임플레이트가 보이는지 확인하세요 ===")
end

-- ============================================
-- NS 공개 API (SlashCommands.lua, OptionsPanel.lua 에서 참조)
-- ============================================
NS.EnsureNameplatesEnabled = EnsureNameplatesEnabled
NS.ScanExistingNameplates = ScanExistingNameplates
NS.ClearAllOverlays = ClearAllOverlays
NS.CheckZone = CheckZone
NS.IsSpiderZone = IsSpiderZone
NS.IsNearSpiderSpawn = IsNearSpiderSpawn
NS.MetersToMapUnits = MetersToMapUnits
NS.OnTargetChanged = OnTargetChanged
NS.OnFocusChanged = OnFocusChanged
NS.ShowNameplateOverlay = ShowNameplateOverlay
NS.HideNameplateOverlay = HideNameplateOverlay
NS.PrintDebugInfo = PrintDebugInfo
NS.activePlates = activePlates
NS.portraitOverlays = portraitOverlays

function NS.UpdateAllOverlayStyles()
    for _, frame in pairs(activePlates) do ApplyOverlayStyle(frame) end
    for _, overlay in pairs(portraitOverlays) do
        local r, g, b = unpack(NoSpiderDB.overlayColor)
        overlay.bg:SetColorTexture(r, g, b, NoSpiderDB.overlayAlpha)
    end
end

function NS.UpdateAllOverlaySizes()
    for _, frame in pairs(activePlates) do
        frame:SetSize(NoSpiderDB.overlayWidth, NoSpiderDB.overlayHeight)
    end
end

function NS.ResetDB()
    wipe(NoSpiderDB)
    for k, v in pairs(defaults) do
        if type(v) == "table" then
            NoSpiderDB[k] = {}
            for kk, vv in pairs(v) do NoSpiderDB[k][kk] = vv end
        else
            NoSpiderDB[k] = v
        end
    end
end


-- ============================================
-- 초기화
-- ============================================
local function InitDB()
    if not NoSpiderDB then
        NoSpiderDB = {}
    end
    for k, v in pairs(defaults) do
        if NoSpiderDB[k] == nil then
            if type(v) == "table" then
                NoSpiderDB[k] = {}
                for kk, vv in pairs(v) do NoSpiderDB[k][kk] = vv end
            else
                NoSpiderDB[k] = v
            end
        end
    end
    -- warnedGuidCooldown → warnedNpcCooldown 마이그레이션
    if NoSpiderDB.warnedGuidCooldown then
        NoSpiderDB.warnedNpcCooldown = NoSpiderDB.warnedGuidCooldown
        NoSpiderDB.warnedGuidCooldown = nil
    end
    -- spawnProximityRadius (맵 비율) → spawnProximityMeters (미터) 마이그레이션
    if NoSpiderDB.spawnProximityRadius then
        NoSpiderDB.spawnProximityMeters = math.floor(NoSpiderDB.spawnProximityRadius * DEFAULT_MAP_METERS + 0.5)
        NoSpiderDB.spawnProximityRadius = nil
    end
end

-- ============================================
-- 이벤트 등록
-- ============================================
local eventFrame = CreateFrame("Frame", "NoSpiderEventFrame", UIParent)

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == ADDON_NAME then
            InitDB()
            print(NS.C.PREFIX .. "거미 공포증 모드 v1.0 로드! /ns help")
            print(NS.C.PREFIX .. "자동 감지를 위해 적 네임플레이트가 켜져 있어야 합니다. (" .. NS.C.YELLOW .. "V키" .. NS.C.R .. ")")
            print(NS.C.PREFIX .. NS.C.GOLD .. "오버레이 방식이므로 일부 상황에서 모델이 노출될 수 있습니다." .. NS.C.R)
            print(NS.C.PREFIX .. "문제 발생 시 " .. NS.C.YELLOW .. "/ns debug" .. NS.C.R .. " 로 진단하세요.")
            -- 경고 배너 스타일 복원
            NS.UpdateZoneWarningStyle()

            -- 저장된 프레임 위치 복원
            NS.RestorePosition(zoneWarningFrame, "zoneWarningPos", ZW_DEFAULTS)
            if NS.npcListFrame and NS.NPC_LIST_DEFAULTS then
                NS.RestorePosition(NS.npcListFrame, "npcListPos", NS.NPC_LIST_DEFAULTS)
            end

            C_Timer.After(1, function()
                if NoSpiderDB.enabled then
                    EnsureNameplatesEnabled()
                    ScanExistingNameplates()
                    CheckZone()
                end
                if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
            end)
            self:UnregisterEvent("ADDON_LOADED")
        end

    elseif event == "NAME_PLATE_UNIT_ADDED" then
        OnNamePlateAdded(...)

    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        OnNamePlateRemoved(...)

    elseif event == "PLAYER_TARGET_CHANGED" then
        OnTargetChanged()

    elseif event == "PLAYER_FOCUS_CHANGED" then
        OnFocusChanged()

    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        -- 죽은 거미(시체)에 마우스오버 시에만 경고
        -- 살아있는 거미는 오버레이로 이미 가려져 있으므로 경고 불필요
        if NoSpiderDB and NoSpiderDB.enabled and NoSpiderDB.deadSpiderWarning
            and UnitExists("mouseover")
            and IsSpider("mouseover") and UnitIsDead("mouseover") then
            ShowWarning(UnitName("mouseover"), GetNPCID("mouseover"))
        end

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        OnCombatLogEvent()

    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" then
        CheckZone()
    end
end)
