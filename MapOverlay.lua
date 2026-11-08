-- MapOverlay.lua
-- 월드맵 거미 출몰 지역 히트맵 오버레이
-- DeathLog 방식 WorldMapFrame:GetCanvas() 기반
--
-- 대륙 지도: 스폰 좌표를 대륙 좌표로 변환하여 히트맵 표시
-- 지역 지도: 스폰 좌표 기반 히트맵 그리드 (SpiderSpawnData)

local _, NS = ...

-- ============================================
-- 설정
-- ============================================
local GRANULARITY_VALUES = { 25, 50, 75, 100 }  -- 1=낮음, 2=보통, 3=높음, 4=매우높음
local HEATMAP_MAX_ALPHA = 0.55  -- 히트맵 최대 알파

local function GetGranularity()
    local idx = NoSpiderDB and NoSpiderDB.heatmapGranularity or 3
    return GRANULARITY_VALUES[idx] or 75
end

-- 색상 (NoSpiderDB에서 읽음, 초기화 전 폴백)
local function GetHeatColorLo()
    return NoSpiderDB and NoSpiderDB.heatColorLo or { 1, 0.6, 0 }
end
local function GetHeatColorHi()
    return NoSpiderDB and NoSpiderDB.heatColorHi or { 1, 0.1, 0 }
end

-- ============================================
-- 오버레이 프레임
-- ============================================
local canvas = WorldMapFrame:GetCanvas()

local overlayFrame = CreateFrame("Frame", "NoSpiderMapOverlay", canvas)
overlayFrame:SetAllPoints(canvas)
overlayFrame:SetFrameStrata("FULLSCREEN")
overlayFrame:SetFrameLevel(1)  -- 같은 스트라타 내 최저 레벨 → 다른 핀 아래

-- 텍스처 풀
local heatmapTextures = {}      -- [x][y] = texture
local lastRenderedMapID = nil

-- ============================================
-- 유틸: 지도 타입 판별
-- ============================================
local function GetMapType(mapID)
    if not mapID then return nil end
    local info = C_Map.GetMapInfo(mapID)
    return info and info.mapType or nil
end

-- ============================================
-- 히트맵 숨기기
-- ============================================
local function HideHeatmap()
    for x, row in pairs(heatmapTextures) do
        for y, tex in pairs(row) do
            tex:Hide()
        end
    end
end

-- ============================================
-- 좌표 수집: 지역 지도용 (직접 사용)
-- ============================================
local function CollectZoneCoords(mapID)
    local spawnData = NS.SpiderSpawnData and NS.SpiderSpawnData[mapID]
    if not spawnData or #spawnData == 0 then return nil end
    -- 0~100 스케일 그대로 반환
    return spawnData
end

-- ============================================
-- 좌표 수집: 대륙 지도용 (zone 좌표 → 대륙 좌표 변환)
-- ============================================
-- 대륙 지도의 자식 존을 C_Map API로 탐색하여
-- SpiderSpawnData에 좌표가 있는 존만 변환.
-- SpiderZones 테이블에 의존하지 않으므로 uiMapId 불일치 문제 없음.

local function CollectContinentCoords(continentMapID)
    local coords = {}

    local function AddZone(zoneMapID)
        local spawnData = NS.SpiderSpawnData and NS.SpiderSpawnData[zoneMapID]
        if not spawnData or #spawnData == 0 then return end

        local minX, maxX, minY, maxY = C_Map.GetMapRectOnMap(zoneMapID, continentMapID)
        if not minX then return end

        local dx = maxX - minX
        local dy = maxY - minY
        for _, c in ipairs(spawnData) do
            local cx = (minX + dx * c[1] / 100) * 100
            local cy = (minY + dy * c[2] / 100) * 100
            coords[#coords + 1] = { cx, cy }
        end
    end

    -- 대륙의 자식 존 탐색 (Zone 타입)
    local children = C_Map.GetMapChildrenInfo(continentMapID, Enum.UIMapType.Zone, true)
    if children then
        for _, childInfo in ipairs(children) do
            AddZone(childInfo.mapID)
        end
    end

    -- 폴백: 자식 존 탐색 실패 시 SpiderSpawnData 전체 키 시도
    if #coords == 0 and NS.SpiderSpawnData then
        for zoneMapID, _ in pairs(NS.SpiderSpawnData) do
            AddZone(zoneMapID)
        end
    end

    return #coords > 0 and coords or nil
end

-- ============================================
-- 히트맵 렌더링 (대륙/지역 공용)
-- ============================================
local function RenderHeatmap(coords)
    HideHeatmap()

    if not coords or #coords == 0 then return end

    local mWidth, mHeight = canvas:GetSize()
    if not mWidth or mWidth == 0 then return end

    local gran = GetGranularity()
    local cellSize = math.ceil(11 * 100 / gran)

    -- 좌표를 그리드 셀로 버킷팅
    local grid = {}
    local maxCount = 0
    for _, coord in ipairs(coords) do
        local wx, wy = coord[1], coord[2]
        local gx = math.floor(wx * gran / 100)
        local gy = math.floor(wy * gran / 100)
        if gx >= 0 and gx < gran and gy >= 0 and gy < gran then
            grid[gx] = grid[gx] or {}
            grid[gx][gy] = (grid[gx][gy] or 0) + 1
            if grid[gx][gy] > maxCount then maxCount = grid[gx][gy] end
        end
    end

    if maxCount == 0 then return end

    for x, row in pairs(grid) do
        for y, count in pairs(row) do
            local intensity = count / maxCount
            local alpha = math.min(intensity * 3, 1) * HEATMAP_MAX_ALPHA

            -- 텍스처 재사용 또는 생성
            heatmapTextures[x] = heatmapTextures[x] or {}
            if not heatmapTextures[x][y] then
                local tex = overlayFrame:CreateTexture(nil, "ARTWORK")
                tex:SetDrawLayer("BACKGROUND", 1)
                heatmapTextures[x][y] = tex
            end

            local tex = heatmapTextures[x][y]
            tex:SetSize(cellSize, cellSize)

            -- 밀도에 따른 색상 보간: 저밀도 → 고밀도
            local lo = GetHeatColorLo()
            local hi = GetHeatColorHi()
            local r = lo[1] * (1 - intensity) + hi[1] * intensity
            local g = lo[2] * (1 - intensity) + hi[2] * intensity
            local b = lo[3] * (1 - intensity) + hi[3] * intensity
            tex:SetColorTexture(r, g, b, alpha)

            tex:ClearAllPoints()
            tex:SetPoint("CENTER", overlayFrame, "TOPLEFT",
                mWidth * x / gran,
                -mHeight * y / gran)
            tex:Show()
        end
    end
end

-- ============================================
-- NPC 목록 패널
-- ============================================
local NPC_LIST_MAX = 15   -- 최대 표시 줄 수
local NPC_LINE_HEIGHT = 14
local NPC_PADDING = 6

local NPC_LIST_DEFAULTS = { point = "BOTTOMLEFT", parent = WorldMapFrame, relPoint = "BOTTOMLEFT", x = 8, y = 30 }
NS.NPC_LIST_DEFAULTS = NPC_LIST_DEFAULTS

local npcListFrame = CreateFrame("Frame", "NoSpiderNPCListFrame", WorldMapFrame)
npcListFrame:SetFrameStrata("FULLSCREEN")
npcListFrame:SetFrameLevel(2)
npcListFrame:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOMLEFT", 8, 30)
npcListFrame:Hide()

NS.MakeMovable(npcListFrame, "npcListPos", NPC_LIST_DEFAULTS, "NPC 목록")
NS.npcListFrame = npcListFrame

local npcListBg = npcListFrame:CreateTexture(nil, "BACKGROUND")
npcListBg:SetAllPoints()
npcListBg:SetColorTexture(0.05, 0.05, 0.05, 0.8)

local npcListTitle = npcListFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
npcListTitle:SetPoint("TOPLEFT", npcListFrame, "TOPLEFT", NPC_PADDING, -NPC_PADDING)
npcListTitle:SetTextColor(1, 0.6, 0)

local npcLines = {}
for i = 1, NPC_LIST_MAX do
    local line = npcListFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    line:SetPoint("TOPLEFT", npcListTitle, "BOTTOMLEFT", 2, -(4 + (i - 1) * NPC_LINE_HEIGHT))
    line:SetJustifyH("LEFT")
    line:Hide()
    npcLines[i] = line
end

local function HideNPCList()
    npcListFrame:Hide()
end

local function UpdateNPCList(mapID)
    if not NoSpiderDB or NoSpiderDB.showNPCList == false then
        HideNPCList()
        return
    end

    local npcIDs = NS.SpiderZoneNPCs and NS.SpiderZoneNPCs[mapID]
    if not npcIDs or #npcIDs == 0 then
        HideNPCList()
        return
    end

    local locale = GetLocale()
    local nameIdx = (locale == "koKR") and 2 or 1
    local altIdx = (locale == "koKR") and 1 or 2

    local count = math.min(#npcIDs, NPC_LIST_MAX)
    local maxWidth = 0

    for i = 1, count do
        local nameData = NS.SpiderNames and NS.SpiderNames[npcIDs[i]]
        if nameData then
            npcLines[i]:SetText("|cFFFFFFFF- |r" .. (nameData[nameIdx] or nameData[1]))
        else
            npcLines[i]:SetText("|cFFFFFFFF- |rNPC " .. npcIDs[i])
        end
        npcLines[i]:Show()
        local w = npcLines[i]:GetStringWidth()
        if w > maxWidth then maxWidth = w end
    end

    for i = count + 1, NPC_LIST_MAX do
        npcLines[i]:Hide()
    end

    npcListTitle:SetText(NS.C.GOLD .. "거미 NPC 목록" .. NS.C.R .. "  (" .. #npcIDs .. ")")
    local titleW = npcListTitle:GetStringWidth()
    if titleW > maxWidth then maxWidth = titleW end

    local frameW = maxWidth + NPC_PADDING * 2 + 4
    local frameH = NPC_PADDING * 2 + NPC_LINE_HEIGHT + 4 + count * NPC_LINE_HEIGHT
    npcListFrame:SetSize(frameW, frameH)
    npcListFrame:Show()
end

-- ============================================
-- 메인 업데이트
-- ============================================
local function UpdateOverlay(mapID)
    if not mapID then
        HideHeatmap()
        HideNPCList()
        if NS._HideDungeonPins then NS._HideDungeonPins() end
        return
    end

    -- 설정 꺼져 있으면 숨기기
    if not NoSpiderDB or not NoSpiderDB.enabled or not NoSpiderDB.showMapPins then
        HideHeatmap()
        HideNPCList()
        if NS._HideDungeonPins then NS._HideDungeonPins() end
        lastRenderedMapID = nil
        return
    end

    -- 동일 지도면 재렌더링 스킵
    if mapID == lastRenderedMapID then return end
    lastRenderedMapID = mapID

    local mapType = GetMapType(mapID)

    if mapType == Enum.UIMapType.Continent then
        -- 대륙 지도: zone 좌표를 대륙 좌표로 변환하여 히트맵
        RenderHeatmap(CollectContinentCoords(mapID))
        HideNPCList()
        if NS._HideDungeonPins then NS._HideDungeonPins() end

    elseif mapType == Enum.UIMapType.Zone then
        -- 지역 지도: 스폰 히트맵 + NPC 목록 + 던전 핀
        RenderHeatmap(CollectZoneCoords(mapID))
        UpdateNPCList(mapID)
        if NS._UpdateDungeonPins then NS._UpdateDungeonPins(mapID) end

    else
        -- 그 외 (월드맵, 던전 등): 숨기기
        HideHeatmap()
        HideNPCList()
        if NS._HideDungeonPins then NS._HideDungeonPins() end
    end
end

-- ============================================
-- WorldMapFrame 이벤트 후킹
-- ============================================
hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
    local mapID = WorldMapFrame:GetMapID()
    UpdateOverlay(mapID)
end)

-- 캔버스 크기 변경 시 (줌) 재렌더링
overlayFrame:SetScript("OnSizeChanged", function()
    if lastRenderedMapID then
        local prevMapID = lastRenderedMapID
        lastRenderedMapID = nil  -- 강제 재렌더링
        UpdateOverlay(prevMapID)
    end
end)

-- ============================================
-- 공개 API
-- ============================================
function NS.RefreshMapOverlay()
    lastRenderedMapID = nil
    if WorldMapFrame:IsShown() then
        UpdateOverlay(WorldMapFrame:GetMapID())
    else
        HideHeatmap()
    end
end

function NS.RemoveAllMapOverlays()
    HideHeatmap()
    HideNPCList()
    if NS._HideDungeonPins then NS._HideDungeonPins() end
    lastRenderedMapID = nil
end


-- ============================================
-- 지도 내 월드맵 버튼 (Krowi_WorldMapButtons)
-- ============================================
do
    local GRAN_LABELS = NS.GRAN_LABELS
    local KButtons = LibStub("Krowi_WorldMapButtons-1.4")
    local mapButton = KButtons:Add("NoSpiderMapButtonTemplate", "BUTTON")

    -- 아이콘 초기 틴트
    mapButton.Icon:SetVertexColor(1, 0.6, 0)

    -- 비활성 상태 표시
    local function UpdateIconState()
        if NoSpiderDB and NoSpiderDB.showMapPins then
            mapButton.Icon:SetVertexColor(1, 0.6, 0)
            mapButton.IconOverlay:Hide()
        else
            mapButton.Icon:SetVertexColor(0.5, 0.5, 0.5)
            mapButton.IconOverlay:Show()
        end
    end

    -- Refresh (라이브러리 콜백, 맵 전환 시 호출)
    function mapButton:Refresh() end

    -- 클릭 피드백
    mapButton:SetScript("OnMouseDown", function(self)
        self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 8, -8)
    end)

    -- 툴팁
    mapButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:AddLine("|cFFFF9900NoSpider|r", 1, 1, 1)
        GameTooltip:AddLine(" ")
        local mapState = (NoSpiderDB and NoSpiderDB.showMapPins) and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"
        GameTooltip:AddDoubleLine("히트맵", mapState, 0.8, 0.8, 0.8)
        local npcState = (NoSpiderDB and NoSpiderDB.showNPCList ~= false) and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"
        GameTooltip:AddDoubleLine("NPC 목록", npcState, 0.8, 0.8, 0.8)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("좌클릭: 히트맵 토글", 0.5, 0.5, 0.5)
        GameTooltip:AddLine("우클릭: 설정 메뉴", 0.5, 0.5, 0.5)
        GameTooltip:Show()
    end)
    mapButton:SetScript("OnLeave", GameTooltip_Hide)

    -- 드롭다운 메뉴 (우클릭용)
    local menuFrame = CreateFrame("Frame", "NoSpiderMapMenuFrame", mapButton, "UIDropDownMenuTemplate")

    local function InitMenu(frame, level)
        level = level or 1
        if level == 1 then
            local title = UIDropDownMenu_CreateInfo()
            title.text = "NoSpider"
            title.isTitle = true
            title.notCheckable = true
            UIDropDownMenu_AddButton(title, level)

            local toggle = UIDropDownMenu_CreateInfo()
            toggle.text = "히트맵 표시"
            toggle.checked = NoSpiderDB and NoSpiderDB.showMapPins
            toggle.isNotRadio = true
            toggle.keepShownOnClick = true
            toggle.func = function()
                NoSpiderDB.showMapPins = not NoSpiderDB.showMapPins
                NS.RefreshMapOverlay()
                UpdateIconState()
            end
            UIDropDownMenu_AddButton(toggle, level)

            local sep = UIDropDownMenu_CreateInfo()
            sep.text = ""
            sep.disabled = true
            sep.notCheckable = true
            UIDropDownMenu_AddButton(sep, level)

            local header = UIDropDownMenu_CreateInfo()
            header.text = "히트맵 해상도"
            header.isTitle = true
            header.notCheckable = true
            UIDropDownMenu_AddButton(header, level)

            local cur = NoSpiderDB and NoSpiderDB.heatmapGranularity or 3
            for i = 1, 4 do
                local info = UIDropDownMenu_CreateInfo()
                info.text = GRAN_LABELS[i]
                info.checked = (cur == i)
                info.func = function()
                    NoSpiderDB.heatmapGranularity = i
                    NS.RefreshMapOverlay()
                end
                UIDropDownMenu_AddButton(info, level)
            end

            local npcToggle = UIDropDownMenu_CreateInfo()
            npcToggle.text = "NPC 목록 표시"
            npcToggle.checked = NoSpiderDB and NoSpiderDB.showNPCList ~= false
            npcToggle.isNotRadio = true
            npcToggle.keepShownOnClick = true
            npcToggle.func = function()
                NoSpiderDB.showNPCList = not (NoSpiderDB.showNPCList ~= false)
                NS.RefreshMapOverlay()
            end
            UIDropDownMenu_AddButton(npcToggle, level)

            UIDropDownMenu_AddButton(sep, level)

            local config = UIDropDownMenu_CreateInfo()
            config.text = "설정 창 열기"
            config.notCheckable = true
            config.func = function()
                if NS.OpenOptionsPanel then NS.OpenOptionsPanel() end
            end
            UIDropDownMenu_AddButton(config, level)
        end
    end

    UIDropDownMenu_Initialize(menuFrame, InitMenu, "MENU")

    -- 좌클릭: 히트맵 토글, 우클릭: 드롭다운 메뉴
    mapButton:SetScript("OnMouseUp", function(self, button)
        self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -5)
        if button == "LeftButton" then
            NoSpiderDB.showMapPins = not NoSpiderDB.showMapPins
            NS.RefreshMapOverlay()
            UpdateIconState()
        elseif button == "RightButton" then
            ToggleDropDownMenu(1, nil, menuFrame, self, 0, 0)
        end
    end)
    mapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    -- 초기 상태 반영 (DB 로드 후)
    C_Timer.After(0, UpdateIconState)
end

-- ============================================
-- 던전/레이드 입구 커스텀 핀
-- ============================================
-- TBC Classic에서 던전 입구 아이콘은 맵 텍스처(정적 이미지)이므로
-- 인터랙티브 핀이 존재하지 않음.
-- 거미 출몰 던전 위치에 커스텀 핀을 직접 생성하여 툴팁 표시.
do
    local function GetDungeonPinSize()
        return NoSpiderDB and NoSpiderDB.dungeonPinSize or 16
    end
    local function GetDungeonPinOffset()
        return (NoSpiderDB and NoSpiderDB.dungeonPinOffset or 2.0) / 100
    end

    local dungeonPins = {}
    local activeDungeonPins = 0

    local function ShowDungeonTooltip(self)
        if not self._dungeonData then return end
        local locale = GetLocale()
        local nameIdx = (locale == "koKR") and 2 or 1
        local altIdx = (locale == "koKR") and 1 or 2

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local dnNames = NS.SpiderDungeonDisplayNames
        for i, entry in ipairs(self._dungeonData) do
            if i > 1 then GameTooltip:AddLine(" ") end
            local dn = entry.displayName
            local koName = dnNames and dnNames[dn]
            GameTooltip:AddLine((locale == "koKR" and koName) or dn, 1, 1, 1)
            GameTooltip:AddLine("|cFFFF9900[NoSpider]|r 거미 NPC", 1, 0.6, 0)
            for _, npcID in ipairs(entry.npcIDs) do
                local nameData = NS.SpiderNames and NS.SpiderNames[npcID]
                if nameData then
                    GameTooltip:AddLine("  - " .. (nameData[nameIdx] or nameData[1]), 1, 1, 1)
                end
            end
        end
        GameTooltip:Show()
    end

    local function GetOrCreatePin(index)
        if dungeonPins[index] then return dungeonPins[index] end

        local pin = CreateFrame("Frame", nil, canvas)
        pin:SetSize(GetDungeonPinSize(), GetDungeonPinSize())
        pin:SetFrameStrata("FULLSCREEN")
        pin:SetFrameLevel(5)
        pin:EnableMouse(true)

        -- 주황색 배경
        local bg = pin:CreateTexture(nil, "BACKGROUND")
        bg:SetPoint("TOPLEFT", -2, 2)
        bg:SetPoint("BOTTOMRIGHT", 2, -2)
        bg:SetColorTexture(0.7, 0.3, 0.0, 0.8)

        -- 아이콘
        local icon = pin:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexture("Interface\\AddOns\\NoSpider\\textures\\spidercover")

        pin:SetScript("OnEnter", function(self)
            icon:SetAlpha(1.0)
            ShowDungeonTooltip(self)
        end)
        pin:SetScript("OnLeave", function(self)
            icon:SetAlpha(0.8)
            GameTooltip:Hide()
        end)

        pin:Hide()
        dungeonPins[index] = pin
        return pin
    end

    local function HideDungeonPins()
        for i = 1, activeDungeonPins do
            dungeonPins[i]:Hide()
        end
        activeDungeonPins = 0
    end

    local function UpdateDungeonPins(mapID)
        HideDungeonPins()
        if not NoSpiderDB or not NoSpiderDB.enabled or not NoSpiderDB.showMapPins then return end

        local mWidth, mHeight = canvas:GetSize()
        if not mWidth or mWidth == 0 then return end

        -- 입구 데이터 수집: { [posKey] = { x, y, dungeons = { {displayName, npcIDs}, ... } } }
        local entrancesByPos = {}

        -- 1차: C_EncounterJournal API 시도
        if C_EncounterJournal and C_EncounterJournal.GetDungeonEntrancesForMap then
            local ok, apiResult = pcall(C_EncounterJournal.GetDungeonEntrancesForMap, mapID)
            if ok and apiResult then
                for _, info in ipairs(apiResult) do
                    local name = info.name
                    local npcIDs = NS.SpiderDungeonTooltips and NS.SpiderDungeonTooltips[name]
                    if npcIDs then
                        local pos = info.position
                        local px = pos.x or pos[1] or 0
                        local py = pos.y or pos[2] or 0
                        local key = string.format("%.3f,%.3f", px, py)
                        if not entrancesByPos[key] then
                            entrancesByPos[key] = { x = px, y = py, dungeons = {} }
                        end
                        entrancesByPos[key].dungeons[#entrancesByPos[key].dungeons + 1] =
                            { displayName = name, npcIDs = npcIDs }
                    end
                end
            end
        end

        -- 2차: API 결과 없으면 하드코딩 폴백
        if not next(entrancesByPos) then
            local fallback = NS.SpiderDungeonPinData and NS.SpiderDungeonPinData[mapID]
            if fallback then
                for _, entry in ipairs(fallback) do
                    local key = string.format("%.3f,%.3f", entry.x, entry.y)
                    if not entrancesByPos[key] then
                        entrancesByPos[key] = { x = entry.x, y = entry.y, dungeons = {} }
                    end
                    for _, dname in ipairs(entry.dungeons) do
                        local npcIDs = NS.SpiderDungeonTooltips and NS.SpiderDungeonTooltips[dname]
                        if npcIDs then
                            entrancesByPos[key].dungeons[#entrancesByPos[key].dungeons + 1] =
                                { displayName = dname, npcIDs = npcIDs }
                        end
                    end
                end
            end
        end

        -- 핀 생성
        local idx = 0
        for _, data in pairs(entrancesByPos) do
            if #data.dungeons > 0 then
                idx = idx + 1
                local pin = GetOrCreatePin(idx)
                pin._dungeonData = data.dungeons
                local sz = GetDungeonPinSize()
                pin:SetSize(sz, sz)
                pin:ClearAllPoints()
                pin:SetPoint("CENTER", canvas, "TOPLEFT",
                    mWidth * (data.x + GetDungeonPinOffset()),
                    -mHeight * data.y)
                pin:Show()
            end
        end
        activeDungeonPins = idx
    end

    -- 공개 함수 (UpdateOverlay에서 호출)
    NS._UpdateDungeonPins = UpdateDungeonPins
    NS._HideDungeonPins = HideDungeonPins
end
