-- SlashCommands.lua
-- NoSpider 슬래시 커맨드 (/ns, /nospider)

local _, NS = ...

local strlower = string.lower
local strformat = string.format
local tonumber = tonumber
local pairs = pairs

local function PrintHelp()
    local C = NS.C
    local p = C.PREFIX
    local W = C.WHITE
    local Y = C.YELLOW
    local G = C.GRAY
    local R = C.R
    print(p .. "=== 사용법 ===")

    -- 일반
    print(Y .. " [일반]" .. R)
    print("  /ns             토글 (활성화/비활성화)")
    print("  /ns on|off      활성화/비활성화")
    print("  /ns config      설정 창 열기")
    print("  /ns reset       설정 초기화")

    -- 오버레이
    print(Y .. " [오버레이]" .. R)
    print("  /ns alpha N     불투명도 (0.0~1.0)")
    print("  /ns width N     오버레이 가로 (100~400)")
    print("  /ns height N    오버레이 세로 (100~500)")
    print("  /ns portrait    초상화 가리기 토글")
    print("  /ns test        오버레이 크기 테스트 (타겟 네임플레이트)")

    -- 경고
    print(C.LIGHTORANGE .. " [경고]" .. R)
    print("  /ns sound       경고음 토글")
    print("  /ns name        이름 패턴 매칭 토글")
    print("  /ns nameplate   네임플레이트 자동활성화 토글")
    print("  /ns proximity   스폰 좌표 접근 경고 토글")
    print("  /ns zone        현재 위치 거미 접근 확인")

    -- NPC 관리
    print(C.GREEN .. " [NPC 관리]" .. R)
    print("  /ns add         현재 타겟 NPC ID 추가")
    print("  /ns add ID      특정 NPC ID 추가")
    print("  /ns remove ID   NPC ID 제거")
    print("  /ns check       현재 타겟 거미 여부 확인")
    print("  /ns list        커스텀 ID 목록")

    -- 맵
    print(C.LIGHTGRAY .. " [맵]" .. R)
    print("  /ns mappins       월드맵 오버레이 토글")
    print("  /ns heatmap 1~4   히트맵 해상도 (1=낮음, 4=매우높음)")
    print("  /ns addregion     현재 지역을 거미 출몰 지역에 추가")
    print("  /ns removeregion  거미 출몰 지역에서 제거")
    print("  /ns listregions   커스텀 거미 출몰 지역 목록")

    -- 개발자
    print(G .. " [개발자]" .. R)
    print(G .. "  /ns mapid         현재 위치 uiMapID 확인" .. R)
    print(G .. "  /ns pincoord      현재 위치 좌표 출력" .. R)
    print(G .. "  /ns debug         진단 정보 출력 (월드맵 열림 시 핀 포함)" .. R)

    print(" ")
    print("  |cFFFF9900* 모델 대체가 아닌 오버레이 방식이므로 먼 거리, 시체,|r")
    print("  |cFFFF9900  컷신, 로딩 직후 등에서 모델이 노출될 수 있습니다.|r")
end

local function HandleSlashCommand(msg)
    local args = {}
    for word in msg:gmatch("%S+") do
        table.insert(args, strlower(word))
    end
    local cmd = args[1] or ""
    local p = NS.C.PREFIX

    if cmd == "" then
        NoSpiderDB.enabled = not NoSpiderDB.enabled
        if NoSpiderDB.enabled then
            print(p .. "|cFF00FF00활성화|r")
            NS.EnsureNameplatesEnabled()
            NS.ScanExistingNameplates()
            NS.CheckZone()
        else
            print(p .. "|cFFFF0000비활성화|r")
            NS.ClearAllOverlays()
        end
        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end

    elseif cmd == "on" then
        NoSpiderDB.enabled = true
        print(p .. "|cFF00FF00활성화|r")
        NS.EnsureNameplatesEnabled()
        NS.ScanExistingNameplates()
        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end

    elseif cmd == "off" then
        NoSpiderDB.enabled = false
        print(p .. "|cFFFF0000비활성화|r")
        NS.ClearAllOverlays()
        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end

    elseif cmd == "alpha" then
        local val = tonumber(args[2])
        if val and val >= 0 and val <= 1 then
            NoSpiderDB.overlayAlpha = val
            print(p .. "불투명도: " .. val)
            NS.UpdateAllOverlayStyles()
        else
            print(p .. "0.0 ~ 1.0 사이 값을 입력하세요.")
        end

    elseif cmd == "width" then
        local val = tonumber(args[2])
        if val and val >= 100 and val <= 400 then
            NoSpiderDB.overlayWidth = val
            print(p .. "오버레이 가로: " .. val .. "px")
            NS.UpdateAllOverlaySizes()
        else
            print(p .. "100 ~ 400 사이 값을 입력하세요.")
        end

    elseif cmd == "height" then
        local val = tonumber(args[2])
        if val and val >= 100 and val <= 500 then
            NoSpiderDB.overlayHeight = val
            print(p .. "오버레이 세로: " .. val .. "px")
            NS.UpdateAllOverlaySizes()
        else
            print(p .. "100 ~ 500 사이 값을 입력하세요.")
        end

    elseif cmd == "portrait" then
        NoSpiderDB.coverPortrait = not NoSpiderDB.coverPortrait
        local state = NoSpiderDB.coverPortrait and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"
        print(p .. "초상화 가리기: " .. state)
        NS.OnTargetChanged()
        NS.OnFocusChanged()

    elseif cmd == "nameplate" then
        NoSpiderDB.autoEnableNameplates = not NoSpiderDB.autoEnableNameplates
        local state = NoSpiderDB.autoEnableNameplates and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"
        print(p .. "네임플레이트 자동활성화: " .. state)

    elseif cmd == "sound" then
        NoSpiderDB.warningSound = not NoSpiderDB.warningSound
        local state = NoSpiderDB.warningSound and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"
        print(p .. "경고음: " .. state)

    elseif cmd == "name" then
        NoSpiderDB.namePatternMatch = not NoSpiderDB.namePatternMatch
        local state = NoSpiderDB.namePatternMatch and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"
        print(p .. "이름 패턴 매칭: " .. state)
        NS.ClearAllOverlays()
        if NoSpiderDB.enabled then NS.ScanExistingNameplates() end

    elseif cmd == "add" then
        local npcID = tonumber(args[2])
        if not npcID then
            if UnitExists("target") then
                npcID = NS.GetNPCID("target")
                if not npcID then
                    print(p .. "타겟의 NPC ID를 가져올 수 없습니다.")
                    return
                end
            else
                print(p .. "타겟을 선택하거나 NPC ID를 입력하세요.")
                return
            end
        end
        NoSpiderDB.customIDs[npcID] = true
        local name = UnitExists("target") and UnitName("target") or "?"
        print(p .. "추가됨: NPC ID " .. npcID .. " (" .. name .. ")")
        NS.ClearAllOverlays()
        if NoSpiderDB.enabled then NS.ScanExistingNameplates() end

    elseif cmd == "remove" then
        local npcID = tonumber(args[2])
        if npcID then
            NoSpiderDB.customIDs[npcID] = nil
            print(p .. "제거됨: NPC ID " .. npcID)
            NS.ClearAllOverlays()
            if NoSpiderDB.enabled then NS.ScanExistingNameplates() end
        else
            print(p .. "제거할 NPC ID를 입력하세요.")
        end

    elseif cmd == "check" then
        if UnitExists("target") then
            local npcID = NS.GetNPCID("target")
            local name = UnitName("target") or "?"
            local spider = NS.IsSpider("target")
            local result = spider and "|cFFFF0000거미입니다!|r" or "|cFF00FF00거미가 아닙니다.|r"
            print(p .. name .. " (ID: " .. (npcID or "?") .. ") - " .. result)
        else
            print(p .. "타겟을 선택하세요.")
        end

    elseif cmd == "list" then
        print(p .. "커스텀 NPC ID 목록:")
        local count = 0
        for id, _ in pairs(NoSpiderDB.customIDs) do
            print("  - " .. id)
            count = count + 1
        end
        if count == 0 then print("  (없음)") end

    elseif cmd == "test" then
        if UnitExists("target") then
            local np = C_NamePlate.GetNamePlateForUnit("target")
            if np then
                NS.HideNameplateOverlay(np)
                NS.ShowNameplateOverlay(np, "target")
                print(p .. "테스트 오버레이 표시. /ns width, height 로 조절하세요.")
                print(p .. "현재: " .. NoSpiderDB.overlayWidth .. "x" .. NoSpiderDB.overlayHeight)
            else
                print(p .. "타겟의 네임플레이트가 보이지 않습니다. 가까이 가세요.")
            end
        else
            print(p .. "타겟을 선택하세요.")
        end

    elseif cmd == "reset" then
        NS.ResetDB()
        print(p .. "설정이 초기화되었습니다.")
        NS.ClearAllOverlays()

    elseif cmd == "zone" then
        local zone = GetZoneText() or ""
        local mapID = C_Map.GetBestMapForUnit("player")
        local isSpiderZ = NS.IsSpiderZone(mapID)
        local zoneStatus = isSpiderZ and "|cFFFFAA00[주의] 거미 출몰 지역|r" or "|cFF00FF00안전|r"
        print(p .. "지역: " .. zone .. " (mapID: " .. tostring(mapID) .. ") - " .. zoneStatus)
        if mapID and NS.IsNearSpiderSpawn then
            local pos = C_Map.GetPlayerMapPosition(mapID, "player")
            if pos then
                local px, py = pos:GetXY()
                local meters = NoSpiderDB.spawnProximityMeters or 100
                local radius = NS.MetersToMapUnits(meters, mapID)
                local isNear = NS.IsNearSpiderSpawn(mapID, px * 100, py * 100, radius)
                local proxStatus = isNear and "|cFFFF0000[경고] 거미 출몰 좌표 근처|r" or "|cFF00FF00안전|r"
                print(p .. "스폰 좌표: " .. proxStatus .. strformat(" (반경: %dm)", meters))
            else
                print(p .. "좌표를 가져올 수 없습니다 (인스턴스 내부?)")
            end
        end

    elseif cmd == "proximity" then
        NoSpiderDB.spawnProximityWarning = not NoSpiderDB.spawnProximityWarning
        local state = NoSpiderDB.spawnProximityWarning and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"
        print(p .. "스폰 좌표 접근 경고: " .. state)
        NS.CheckZone()

    elseif cmd == "mapid" then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            local info = C_Map.GetMapInfo(mapID)
            local name = info and info.name or "?"
            local mapType = info and info.mapType or "?"
            local parentID = info and info.parentMapID or 0
            local isSpider = NS.IsSpiderZone(mapID) and "|cFFFF0000거미 출몰 지역|r" or "|cFF00FF00미등록|r"
            print(p .. "현재 uiMapID: " .. mapID .. " (" .. name .. ")")
            print(p .. "mapType: " .. tostring(mapType) .. " / parentMapID: " .. parentID)
            print(p .. "지역 상태: " .. isSpider)
        else
            print(p .. "현재 위치의 mapID를 가져올 수 없습니다.")
        end

    elseif cmd == "addregion" then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            local info = C_Map.GetMapInfo(mapID)
            local name = info and info.name or "?"
            NoSpiderDB.customZones[mapID] = true
            print(p .. "거미 출몰 지역 추가: " .. name .. " (ID: " .. mapID .. ")")
            NS.CheckZone()
            if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
        else
            print(p .. "현재 위치의 mapID를 가져올 수 없습니다.")
        end

    elseif cmd == "removeregion" then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            local info = C_Map.GetMapInfo(mapID)
            local name = info and info.name or "?"
            NoSpiderDB.customZones[mapID] = nil
            print(p .. "거미 출몰 지역 제거: " .. name .. " (ID: " .. mapID .. ")")
            NS.CheckZone()
            if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
        else
            print(p .. "현재 위치의 mapID를 가져올 수 없습니다.")
        end

    elseif cmd == "listregions" then
        print(p .. "커스텀 거미 출몰 지역:")
        local count = 0
        for id, _ in pairs(NoSpiderDB.customZones) do
            local info = C_Map.GetMapInfo(id)
            local name = info and info.name or "?"
            print("  - " .. name .. " (ID: " .. id .. ")")
            count = count + 1
        end
        if count == 0 then print("  (없음)") end

    elseif cmd == "mappins" then
        NoSpiderDB.showMapPins = not NoSpiderDB.showMapPins
        if NoSpiderDB.showMapPins then
            print(p .. "월드맵 오버레이 |cFF00FF00활성화|r")
        else
            print(p .. "월드맵 오버레이 |cFFFF0000비활성화|r")
        end
        if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end

    elseif cmd == "heatmap" then
        local val = tonumber(args[2])
        if val and val >= 1 and val <= 4 then
            local labels = { "낮음(25)", "보통(50)", "높음(75)", "매우높음(100)" }
            NoSpiderDB.heatmapGranularity = val
            print(p .. "히트맵 해상도: " .. labels[val])
            if NS.RefreshMapOverlay then NS.RefreshMapOverlay() end
        else
            print(p .. "사용법: /ns heatmap 1~4 (1=낮음, 2=보통, 3=높음, 4=매우높음)")
        end

    elseif cmd == "pincoord" then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID then
            local pos = C_Map.GetPlayerMapPosition(mapID, "player")
            if pos then
                local x, y = pos:GetXY()
                local info = C_Map.GetMapInfo(mapID)
                local name = info and info.name or "?"
                local sub = GetSubZoneText() or ""
                print(p .. "현재 위치 좌표:")
                print(strformat('    ["%s"] = { mapID = %d, x = %.2f, y = %.2f },',
                    strlower(sub ~= "" and sub or name), mapID, x, y))
                print(p .. "Zone: " .. name .. " | SubZone: " .. sub)
            else
                print(p .. "좌표를 가져올 수 없습니다 (인스턴스 내부?)")
            end
        else
            print(p .. "현재 위치의 mapID를 가져올 수 없습니다.")
        end

    elseif cmd == "debug" then
        NS.PrintDebugInfo()
    elseif cmd == "errors" or cmd == "errorlog" then
        NS.PrintErrorLog()

    elseif cmd == "clearerrors" then
        NS.ClearErrorLog()
        print(p .. " Error log cleared.")
    elseif cmd == "config" or cmd == "options" or cmd == "설정" then
        if NS.OpenOptionsPanel then
            NS.OpenOptionsPanel()
        end

    elseif cmd == "help" then
        PrintHelp()
    else
        PrintHelp()
    end
end

SLASH_NOSPIDER1 = "/nospider"
SLASH_NOSPIDER2 = "/ns"
SlashCmdList["NOSPIDER"] = HandleSlashCommand
