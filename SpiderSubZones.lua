-- SpiderSubZones.lua
-- 거미 서식 서브존 데이터 (GetSubZoneText 기반)
--
-- GetSubZoneText() 반환값을 소문자로 비교합니다.
-- 클라이언트 언어에 맞는 서브존 이름을 등록해야 합니다.
-- /ns zone 으로 현재 서브존 이름 확인 가능.
-- /ns addzone 으로 현재 서브존을 거미 구역에 추가.
-- /ns removezone 으로 거미 구역에서 제거.

local _, NS = ...

NS.SpiderSubZones = {

    -- 텔드랏실 / Teldrassil
    ["ban'ethil hollow"] = true,
    ["바네실 동굴"] = true,
    ["shadowglen"] = true,
    ["그늘 협곡"] = true,

    -- 던 모로 / Dun Morogh
    ["chill breeze valley"] = true,
    ["눈마루 골짜기"] = true,

    -- 티리스팔 숲 / Tirisfal Glades
    ["night web's hollow"] = true,
    ["검은그물 거미굴"] = true,
    ["deathknell"] = true,
    ["데스넬"] = true,

    -- 은빛소나무 숲 / Silverpine Forest
    ["skittering dark"] = true,
    ["the skittering dark"] = true,
    ["종종걸음 어둠굴"] = true,

    -- 붉은마루 산맥 / Redridge Mountains
    ["render's valley"] = true,
    ["렌더의 골짜기"] = true,
    ["stonewatch falls"] = true,
    ["돌망루 폭포"] = true,
    ["three corners"] = true,
    ["붉은마루 삼거리"] = true,

    -- 그늘숲 / Duskwood
    ["rotting orchard"] = true,
    ["썩은 과수원"] = true,
    ["hushed bank"] = true,
    ["the hushed bank"] = true,
    ["고요한 강둑"] = true,
    ["어스름 강둑"] = true,
    ["brightwood grove"] = true,
    ["밝은숲 수풀"] = true,
    ["밝은숲"] = true,
    ["vul'gol ogre mound"] = true,
    ["불골 오우거 동산"] = true,

    -- 돌발톱 산맥 / Stonetalon Mountains
    ["webwinder path"] = true,
    ["거미줄 길"] = true,
    ["sishir canyon"] = true,
    ["시시르 협곡"] = true,

    -- 이글거리는 협곡 / Searing Gorge
    ["firewatch ridge"] = true,
    ["불망루 마루"] = true,

    -- 검은바위 첨탑 / Blackrock Spire
    ["blackrock spire"] = true,
    ["검은바위 첨탑"] = true,

    -- 낙스라마스 거미 지구 / Naxxramas
    ["the arachnid quarter"] = true,
    ["arachnid quarter"] = true,
    ["거미 지구"] = true,

    -- 안퀴라즈 / Ahn'Qiraj
    ["ahn'qiraj"] = true,
    ["안퀴라즈"] = true,

    -- [TBC] 테로카르 숲 / Terokkar Forest
    ["bone wastes"] = true,
    ["백골 황무지"] = true,
    ["netherweb ridge"] = true,
    ["황천그물 마루"] = true,

    -- 타나리스 / Tanaris
    ["the noxious lair"] = true,
    ["맹독의 둥지"] = true,

    -- 운고로 분화구 / Un'Goro Crater
    ["the slithering scar"] = true,
    ["갈래굽이 구렁"] = true,

    -- [WotLK] 아즈조네룹 / Azjol-Nerub
    ["azjol-nerub"] = true,
    ["아졸네룹"] = true,
}

-- 서브존 좌표 데이터 (영문 정규화 이름 → { mapID, x, y })
-- /ns pincoord 로 현재 위치 좌표를 수집하여 입력.
NS.SpiderSubZoneCoords = {
    -- 텔드랏실 / Teldrassil
    ["ban'ethil hollow"]    = { mapID = 1438, x = 0.45, y = 0.55 },
    ["shadowglen"]          = { mapID = 1438, x = 0.59, y = 0.33 },

    -- 던 모로 / Dun Morogh
    ["chill breeze valley"] = { mapID = 1426, x = 0.25, y = 0.49 },

    -- 티리스팔 숲 / Tirisfal Glades
    ["night web's hollow"]  = { mapID = 1420, x = 0.28, y = 0.52 },
    ["deathknell"]          = { mapID = 1420, x = 0.29, y = 0.71 },

    -- 은빛소나무 숲 / Silverpine Forest
    ["skittering dark"]     = { mapID = 1421, x = 0.36, y = 0.62 },

    -- 붉은마루 산맥 / Redridge Mountains
    ["render's valley"]     = { mapID = 1433, x = 0.24, y = 0.25 },
    ["stonewatch falls"]    = { mapID = 1433, x = 0.64, y = 0.55 },
    ["three corners"]       = { mapID = 1433, x = 0.26, y = 0.58 },

    -- 그늘숲 / Duskwood
    ["rotting orchard"]     = { mapID = 1431, x = 0.53, y = 0.23 },
    ["hushed bank"]         = { mapID = 1431, x = 0.18, y = 0.56 },
    ["brightwood grove"]    = { mapID = 1431, x = 0.65, y = 0.27 },
    ["vul'gol ogre mound"]  = { mapID = 1431, x = 0.35, y = 0.75 },

    -- 돌발톱 산맥 / Stonetalon Mountains
    ["webwinder path"]      = { mapID = 1442, x = 0.58, y = 0.26 },
    ["sishir canyon"]       = { mapID = 1442, x = 0.52, y = 0.44 },

    -- 이글거리는 협곡 / Searing Gorge
    ["firewatch ridge"]     = { mapID = 1427, x = 0.33, y = 0.34 },

    -- [TBC] 테로카르 숲 / Terokkar Forest
    ["bone wastes"]         = { mapID = 108,  x = 0.42, y = 0.74 },
    ["netherweb ridge"]     = { mapID = 108,  x = 0.53, y = 0.82 },

    -- 타나리스 / Tanaris
    ["the noxious lair"]    = { mapID = 1446, x = 0.36, y = 0.47 },

    -- 운고로 분화구 / Un'Goro Crater
    ["the slithering scar"] = { mapID = 1449, x = 0.50, y = 0.78 },
}

-- 한국어 이름 → 영문 정규화 이름 (중복 핀 방지)
NS.SpiderSubZoneAliases = {
    ["바네실 동굴"]       = "ban'ethil hollow",
    ["그늘 협곡"]         = "shadowglen",
    ["눈마루 골짜기"]     = "chill breeze valley",
    ["검은그물 거미굴"]   = "night web's hollow",
    ["데스넬"]            = "deathknell",
    ["종종걸음 어둠굴"]   = "skittering dark",
    ["렌더의 골짜기"]     = "render's valley",
    ["돌망루 폭포"]       = "stonewatch falls",
    ["붉은마루 삼거리"]   = "three corners",
    ["썩은 과수원"]       = "rotting orchard",
    ["고요한 강둑"]       = "hushed bank",
    ["어스름 강둑"]       = "hushed bank",
    ["밝은숲 수풀"]       = "brightwood grove",
    ["밝은숲"]            = "brightwood grove",
    ["불골 오우거 동산"]  = "vul'gol ogre mound",
    ["거미줄 길"]         = "webwinder path",
    ["시시르 협곡"]       = "sishir canyon",
    ["불망루 마루"]       = "firewatch ridge",
    ["백골 황무지"]       = "bone wastes",
    ["황천그물 마루"]     = "netherweb ridge",
    ["맹독의 둥지"]       = "the noxious lair",
    ["갈래굽이 구렁"]     = "the slithering scar",
    -- 영문 별명 (the 접두사 변형)
    ["the skittering dark"] = "skittering dark",
    ["the hushed bank"]     = "hushed bank",
}
