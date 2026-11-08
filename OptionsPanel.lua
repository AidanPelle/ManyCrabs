-- OptionsPanel.lua
-- NoSpider 설정 패널 (AceConfig-3.0 기반)

local _, NS = ...

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local function RefreshAll()
    if NS.UpdateAllOverlayStyles then NS.UpdateAllOverlayStyles() end
    if NS.UpdateAllOverlaySizes then NS.UpdateAllOverlaySizes() end
    if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
    if NS.UpdateZoneWarningStyle then NS.UpdateZoneWarningStyle() end
end

local GRAN_LABELS = NS.GRAN_LABELS

local options = {
    name = "NoSpider - 거미 공포증 모드",
    type = "group",
    childGroups = "tab",
    args = {

        -- ============================================
        -- 탭 1: 일반
        -- ============================================
        general = {
            name = "일반",
            type = "group",
            order = 1,
            args = {
                descGeneral = {
                    type = "description",
                    name = "기본 동작과 감지 방식을 설정합니다.",
                    order = 0,
                    fontSize = "medium",
                },
                enabled = {
                    type = "toggle",
                    name = "애드온 활성화",
                    desc = "비활성화하면 모든 오버레이와 경고가 중단됩니다.",
                    order = 1,
                    width = "full",
                    get = function() return NoSpiderDB.enabled end,
                    set = function(_, v)
                        NoSpiderDB.enabled = v
                        if v then
                            NS.EnsureNameplatesEnabled()
                            NS.ScanExistingNameplates()
                            NS.CheckZone()
                        else
                            NS.ClearAllOverlays()
                        end
                        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
                    end,
                },
                namePatternMatch = {
                    type = "toggle",
                    name = "이름 패턴 매칭",
                    desc = "ID 목록에 없는 거미를 이름으로 보완 감지합니다.",
                    order = 2,
                    width = 1.5,
                    get = function() return NoSpiderDB.namePatternMatch end,
                    set = function(_, v)
                        NoSpiderDB.namePatternMatch = v
                        NS.ClearAllOverlays()
                        if NoSpiderDB.enabled then NS.ScanExistingNameplates() end
                    end,
                },
                autoEnableNameplates = {
                    type = "toggle",
                    name = "적 네임플레이트 자동 활성화",
                    desc = "네임플레이트가 꺼져 있으면 자동으로 켭니다. 네임플레이트가 보여야 거미를 감지할 수 있습니다.",
                    order = 3,
                    width = 1.5,
                    get = function() return NoSpiderDB.autoEnableNameplates end,
                    set = function(_, v) NoSpiderDB.autoEnableNameplates = v end,
                },
                combatLogDetection = {
                    type = "toggle",
                    name = "전투 로그 보조 감지",
                    desc = "전투 로그에서 거미 NPC의 GUID를 추출하여 네임플레이트 감지를 보완합니다.",
                    order = 4,
                    width = 1.5,
                    get = function() return NoSpiderDB.combatLogDetection end,
                    set = function(_, v) NoSpiderDB.combatLogDetection = v end,
                },
                spacer1 = { type = "description", name = "\n", order = 90 },
                resetHeader = { type = "header", name = "초기화", order = 91 },
                resetBtn = {
                    type = "execute",
                    name = "전체 설정 초기화",
                    order = 92,
                    confirm = true,
                    confirmText = "[NoSpider] 모든 설정을 초기화하시겠습니까?",
                    func = function()
                        NS.ResetDB()
                        NS.ClearAllOverlays()
                        RefreshAll()
                        print(NS.C.PREFIX .. "설정이 초기화되었습니다.")
                    end,
                },
            },
        },

        -- ============================================
        -- 탭 2: 경고
        -- ============================================
        warning = {
            name = "경고",
            type = "group",
            order = 2,
            args = {
                descWarning = {
                    type = "description",
                    name = "거미 감지 시 경고와 지역 경고 배너를 설정합니다.",
                    order = 0,
                    fontSize = "medium",
                },
                warningSound = {
                    type = "toggle",
                    name = "경고음 재생",
                    desc = "거미가 네임플레이트에 감지되면 경고음을 재생합니다.",
                    order = 1,
                    width = 1.2,
                    get = function() return NoSpiderDB.warningSound end,
                    set = function(_, v) NoSpiderDB.warningSound = v end,
                },
                warningMessage = {
                    type = "toggle",
                    name = "경고 메시지 표시",
                    desc = "거미 감지 시 화면 중앙에 경고 메시지를 표시합니다.",
                    order = 2,
                    width = 1.2,
                    get = function() return NoSpiderDB.warningMessage end,
                    set = function(_, v) NoSpiderDB.warningMessage = v end,
                },
                deadSpiderWarning = {
                    type = "toggle",
                    name = "죽은 거미 마우스오버 경고",
                    desc = "죽은 거미 시체에 마우스를 올리면 경고합니다. 시체 모델이 보일 수 있으므로 주의용.",
                    order = 3,
                    width = 1.5,
                    get = function() return NoSpiderDB.deadSpiderWarning end,
                    set = function(_, v) NoSpiderDB.deadSpiderWarning = v end,
                },

                -- 지역 경고 배너
                bannerHeader = { type = "header", name = "지역 경고 배너", order = 10 },
                zoneWarning = {
                    type = "toggle",
                    name = "경고 배너 표시",
                    desc = "거미 출몰 지역에 진입하면 화면 상단에 경고 배너를 표시합니다.",
                    order = 11,
                    width = 1.2,
                    get = function() return NoSpiderDB.zoneWarning end,
                    set = function(_, v) NoSpiderDB.zoneWarning = v; NS.CheckZone() end,
                },
                zoneWarningSound = {
                    type = "toggle",
                    name = "소리 재생",
                    desc = "지역 경고 배너가 표시될 때 경고음도 재생합니다.",
                    order = 12,
                    width = 1.2,
                    get = function() return NoSpiderDB.zoneWarningSound end,
                    set = function(_, v) NoSpiderDB.zoneWarningSound = v end,
                },
                spawnProximityWarning = {
                    type = "toggle",
                    name = "스폰 좌표 접근 경고",
                    desc = "거미 스폰 좌표에 가까이 가면 강한 경고(빨간색 배너)를 표시합니다.",
                    order = 13,
                    width = 1.2,
                    get = function() return NoSpiderDB.spawnProximityWarning end,
                    set = function(_, v) NoSpiderDB.spawnProximityWarning = v; NS.CheckZone() end,
                },
                spawnProximityMeters = {
                    type = "range",
                    name = "접근 경고 반경 (m)",
                    desc = "거미 스폰 좌표로부터 이 거리 이내에 들어오면 경고합니다.",
                    order = 14,
                    min = 30, max = 300, step = 10,
                    width = 1.5,
                    get = function() return NoSpiderDB.spawnProximityMeters or 100 end,
                    set = function(_, v) NoSpiderDB.spawnProximityMeters = v; NS.CheckZone() end,
                },

                -- 배너 색상
                bannerColorHeader = { type = "header", name = "배너 색상", order = 15 },
                warnZoneBgColor = {
                    type = "color",
                    name = "지역 경고 색상",
                    desc = "거미 출몰 지역 진입 시 표시되는 배너의 배경색.",
                    order = 16,
                    hasAlpha = true,
                    width = 1.2,
                    get = function()
                        local c = NoSpiderDB.warnZoneBgColor
                        return c[1], c[2], c[3], c[4]
                    end,
                    set = function(_, r, g, b, a)
                        NoSpiderDB.warnZoneBgColor = { r, g, b, a }
                        NS.UpdateZoneWarningStyle()
                    end,
                },
                warnProximityBgColor = {
                    type = "color",
                    name = "접근 경고 색상",
                    desc = "거미 스폰 좌표에 접근했을 때 표시되는 배너의 배경색.",
                    order = 17,
                    hasAlpha = true,
                    width = 1.2,
                    get = function()
                        local c = NoSpiderDB.warnProximityBgColor
                        return c[1], c[2], c[3], c[4]
                    end,
                    set = function(_, r, g, b, a)
                        NoSpiderDB.warnProximityBgColor = { r, g, b, a }
                        NS.UpdateZoneWarningStyle()
                    end,
                },

                -- 배너 외형
                bannerStyleHeader = { type = "header", name = "배너 외형", order = 20 },
                zoneWarningWidth = {
                    type = "range",
                    name = "가로 (px)",
                    order = 21,
                    min = 150, max = 500, step = 10,
                    width = 1.2,
                    get = function() return NoSpiderDB.zoneWarningWidth or 260 end,
                    set = function(_, v) NoSpiderDB.zoneWarningWidth = v; NS.UpdateZoneWarningStyle() end,
                },
                zoneWarningHeight = {
                    type = "range",
                    name = "세로 (px)",
                    order = 22,
                    min = 16, max = 60, step = 2,
                    width = 1.2,
                    get = function() return NoSpiderDB.zoneWarningHeight or 24 end,
                    set = function(_, v) NoSpiderDB.zoneWarningHeight = v; NS.UpdateZoneWarningStyle() end,
                },
                zoneWarningFontSize = {
                    type = "range",
                    name = "글꼴 크기 (pt)",
                    order = 23,
                    min = 8, max = 20, step = 1,
                    width = 1.2,
                    get = function() return NoSpiderDB.zoneWarningFontSize or 11 end,
                    set = function(_, v) NoSpiderDB.zoneWarningFontSize = v; NS.UpdateZoneWarningStyle() end,
                },
                resetWarnPos = {
                    type = "execute",
                    name = "배너 위치 초기화",
                    order = 24,
                    func = function()
                        NoSpiderDB.zoneWarningPos = nil
                        local f = _G["NoSpiderZoneWarning"]
                        if f then f:ClearAllPoints(); f:SetPoint("TOP", UIParent, "TOP", 0, -10) end
                        print(NS.C.PREFIX .. "경고 배너 위치 초기화")
                    end,
                },

                -- 쿨다운
                cooldownHeader = { type = "header", name = "쿨다운", order = 30 },
                warningCooldown = {
                    type = "range",
                    name = "경고 쿨다운 (초)",
                    desc = "연속 경고 사이의 최소 간격. 짧을수록 자주, 길수록 덜 경고합니다.",
                    order = 31,
                    min = 0.5, max = 10, step = 0.5,
                    width = 1.2,
                    get = function() return NoSpiderDB.warningCooldown end,
                    set = function(_, v) NoSpiderDB.warningCooldown = v end,
                },
                warnedNpcCooldown = {
                    type = "range",
                    name = "동일 종류 거미 재경고 쿨다운 (초)",
                    desc = "같은 종류의 거미에 대해 다시 경고하기까지의 대기 시간. 같은 NPC ID를 가진 모든 개체에 적용됩니다.",
                    order = 32,
                    min = 10, max = 300, step = 10,
                    width = 1.2,
                    get = function() return NoSpiderDB.warnedNpcCooldown end,
                    set = function(_, v) NoSpiderDB.warnedNpcCooldown = v end,
                },
            },
        },

        -- ============================================
        -- 탭 3: 월드맵
        -- ============================================
        worldmap = {
            name = "월드맵",
            type = "group",
            order = 3,
            args = {
                descMap = {
                    type = "description",
                    name = "월드맵 히트맵, NPC 목록, 던전 핀을 설정합니다.",
                    order = 0,
                    fontSize = "medium",
                },
                showMapPins = {
                    type = "toggle",
                    name = "출몰 지역 히트맵 표시",
                    desc = "월드맵에 거미 스폰 밀집도를 히트맵으로 표시합니다.",
                    order = 1,
                    width = 1.2,
                    get = function() return NoSpiderDB.showMapPins end,
                    set = function(_, v)
                        NoSpiderDB.showMapPins = v
                        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
                    end,
                },
                showNPCList = {
                    type = "toggle",
                    name = "NPC 목록 패널 표시",
                    desc = "월드맵 좌측 하단에 해당 지역의 거미 NPC 목록을 표시합니다.",
                    order = 2,
                    width = 1.2,
                    get = function() return NoSpiderDB.showNPCList ~= false end,
                    set = function(_, v)
                        NoSpiderDB.showNPCList = v
                        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
                    end,
                },
                heatmapGranularity = {
                    type = "select",
                    name = "히트맵 해상도",
                    desc = "히트맵 격자 수. 높을수록 정밀하지만 성능에 영향을 줄 수 있습니다.",
                    order = 3,
                    values = GRAN_LABELS,
                    style = "dropdown",
                    width = 1.2,
                    get = function() return NoSpiderDB.heatmapGranularity end,
                    set = function(_, v)
                        NoSpiderDB.heatmapGranularity = v
                        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
                    end,
                },
                heatColorLo = {
                    type = "color",
                    name = "저밀도 색상",
                    desc = "히트맵에서 거미 밀도가 낮은 영역의 색상.",
                    order = 4,
                    width = 1.0,
                    get = function()
                        local c = NoSpiderDB.heatColorLo
                        return c[1], c[2], c[3]
                    end,
                    set = function(_, r, g, b)
                        NoSpiderDB.heatColorLo = { r, g, b }
                        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
                    end,
                },
                heatColorHi = {
                    type = "color",
                    name = "고밀도 색상",
                    desc = "히트맵에서 거미 밀도가 높은 영역의 색상.",
                    order = 5,
                    width = 1.0,
                    get = function()
                        local c = NoSpiderDB.heatColorHi
                        return c[1], c[2], c[3]
                    end,
                    set = function(_, r, g, b)
                        NoSpiderDB.heatColorHi = { r, g, b }
                        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
                    end,
                },
                resetListPos = {
                    type = "execute",
                    name = "NPC 목록 위치 초기화",
                    order = 6,
                    func = function()
                        NoSpiderDB.npcListPos = nil
                        if NS.npcListFrame then
                            NS.npcListFrame:ClearAllPoints()
                            NS.npcListFrame:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOMLEFT", 8, 30)
                        end
                        print(NS.C.PREFIX .. "NPC 목록 위치 초기화")
                    end,
                },

                -- 던전 핀
                dungeonHeader = { type = "header", name = "던전 핀", order = 10 },
                dungeonPinSize = {
                    type = "range",
                    name = "크기 (px)",
                    desc = "월드맵 던전 입구 경고 아이콘의 크기.",
                    order = 11,
                    min = 8, max = 32, step = 1,
                    width = 1.2,
                    get = function() return NoSpiderDB.dungeonPinSize or 16 end,
                    set = function(_, v)
                        NoSpiderDB.dungeonPinSize = v
                        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
                    end,
                },
                dungeonPinOffset = {
                    type = "range",
                    name = "오프셋 (%)",
                    desc = "던전 핀의 위치 보정값. 핀이 던전 입구와 어긋날 때 조정합니다.",
                    order = 12,
                    min = 0, max = 5, step = 0.5,
                    width = 1.2,
                    get = function() return NoSpiderDB.dungeonPinOffset or 2.0 end,
                    set = function(_, v)
                        NoSpiderDB.dungeonPinOffset = v
                        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
                    end,
                },
            },
        },

        -- ============================================
        -- 탭 4: 오버레이
        -- ============================================
        overlay = {
            name = "오버레이",
            type = "group",
            order = 4,
            args = {
                descOverlay = {
                    type = "description",
                    name = "네임플레이트 오버레이 외형과 성능을 설정합니다.",
                    order = 0,
                    fontSize = "medium",
                },
                overlayAlpha = {
                    type = "range",
                    name = "불투명도",
                    desc = "오버레이의 투명도. 0%이면 완전 투명, 100%이면 완전 불투명.",
                    order = 1,
                    min = 0, max = 1, step = 0.05,
                    isPercent = true,
                    width = 1.5,
                    get = function() return NoSpiderDB.overlayAlpha end,
                    set = function(_, v) NoSpiderDB.overlayAlpha = v; NS.UpdateAllOverlayStyles() end,
                },
                overlayColor = {
                    type = "color",
                    name = "오버레이 색상",
                    desc = "거미 모델 위에 덮이는 사각형의 색상.",
                    order = 2,
                    width = 1.0,
                    get = function()
                        local c = NoSpiderDB.overlayColor
                        return c[1], c[2], c[3]
                    end,
                    set = function(_, r, g, b)
                        NoSpiderDB.overlayColor = { r, g, b }
                        NS.UpdateAllOverlayStyles()
                    end,
                },
                overlayWidth = {
                    type = "range",
                    name = "가로 (px)",
                    order = 3,
                    min = 100, max = 400, step = 10,
                    width = 1.2,
                    get = function() return NoSpiderDB.overlayWidth end,
                    set = function(_, v) NoSpiderDB.overlayWidth = v; NS.UpdateAllOverlaySizes() end,
                },
                overlayHeight = {
                    type = "range",
                    name = "세로 (px)",
                    order = 4,
                    min = 100, max = 500, step = 10,
                    width = 1.2,
                    get = function() return NoSpiderDB.overlayHeight end,
                    set = function(_, v) NoSpiderDB.overlayHeight = v; NS.UpdateAllOverlaySizes() end,
                },
                coverPortrait = {
                    type = "toggle",
                    name = "타겟/포커스 초상화 가리기",
                    desc = "거미를 타겟/포커스했을 때 유닛 프레임의 초상화도 색상으로 덮습니다.",
                    order = 5,
                    width = "full",
                    get = function() return NoSpiderDB.coverPortrait end,
                    set = function(_, v)
                        NoSpiderDB.coverPortrait = v
                        NS.OnTargetChanged(); NS.OnFocusChanged()
                    end,
                },

                -- 성능
                perfHeader = { type = "header", name = "성능", order = 10 },
                scanInterval = {
                    type = "range",
                    name = "리스캔 주기 (초)",
                    desc = "활성 네임플레이트를 재검사하는 주기. 짧으면 반응이 빠르지만 CPU를 더 사용합니다.",
                    order = 11,
                    min = 0.5, max = 5, step = 0.5,
                    width = 1.5,
                    get = function() return NoSpiderDB.scanInterval end,
                    set = function(_, v) NoSpiderDB.scanInterval = v end,
                },
            },
        },
    },
}

-- AceConfig 등록
AceConfig:RegisterOptionsTable("NoSpider", options)

-- Blizzard Interface Options에 추가
local panelRef = AceConfigDialog:AddToBlizOptions("NoSpider", "NoSpider")
NS.settingsCategory = panelRef

-- 독립 설정 창 토글 (슬래시 커맨드 / 맵 메뉴에서 호출)
function NS.OpenOptionsPanel()
    -- Blizzard 옵션을 통해 열기
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory("NoSpider")
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory("NoSpider")
        InterfaceOptionsFrame_OpenToCategory("NoSpider")
    end
end
