-- Util.lua
-- NoSpider 공통 상수 및 유틸리티
-- 다른 모든 파일보다 먼저 로드됨

local _, NS = ...

-- ============================================
-- 색상 상수
-- ============================================
NS.C = {
    -- 채팅 메시지 접두사
    PREFIX     = "|cFF00FF00[NoSpider]|r ",
    -- 텍스트 색상 코드 (인라인용)
    GREEN      = "|cFF00FF00",
    RED        = "|cFFFF0000",
    ORANGE     = "|cFFFF6600",
    YELLOW     = "|cFFFFCC00",
    GOLD       = "|cFFFF9900",
    LIGHTYELLOW = "|cFFFFDD00",
    LIGHTORANGE = "|cFFFFAA00",
    WHITE      = "|cFFFFFFFF",
    GRAY       = "|cFF888888",
    LIGHTGRAY  = "|cFFDDDDDD",
    LIGHTGREEN = "|cFF90EE90",
    R          = "|r",
    -- 경고 배너 배경색 (RGBA)
    WARN_PROXIMITY_BG = { 0.4, 0.1, 0.1, 0.65 },
    WARN_ZONE_BG      = { 0.5, 0.4, 0.1, 0.50 },
}

-- ============================================
-- 폰트 상수
-- ============================================
NS.FONT_KR = "Fonts\\2002.TTF"

-- ============================================
-- 공유 데이터
-- ============================================
NS.GRAN_LABELS = { "낮음 (25)", "보통 (50)", "높음 (75)", "매우높음 (100)" }

-- ============================================
-- 드래그 이동 유틸리티
-- ============================================
-- frame: 이동할 프레임
-- dbKey: NoSpiderDB에 저장할 키 이름
-- defaults: { point, parent, relPoint, x, y } 기본 위치
-- tooltipTitle: 툴팁에 표시할 이름 (선택)
function NS.MakeMovable(frame, dbKey, defaults, tooltipTitle)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetClampedToScreen(true)

    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, _, x, y = self:GetPoint()
        if NoSpiderDB then
            NoSpiderDB[dbKey] = { point = point, x = x, y = y }
        end
    end)
    frame:SetScript("OnMouseUp", function(self, button)
        if button == "RightButton" then
            if NS.OpenOptionsPanel then NS.OpenOptionsPanel() end
        end
    end)
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:AddLine("[NoSpider] " .. (tooltipTitle or ""), 1, 1, 1)
        GameTooltip:AddLine("드래그: 이동 | 우클릭: 설정", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- 저장된 위치 복원
function NS.RestorePosition(frame, dbKey, defaults)
    local pos = NoSpiderDB and NoSpiderDB[dbKey]
    if pos then
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, defaults.parent, pos.point, pos.x, pos.y)
    end
end
