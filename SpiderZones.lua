-- SpiderZones.lua
-- 거미 출몰 지역 데이터 (C_Map.GetBestMapForUnit 기반 uiMapID)
--
-- TBC Classic 전용 uiMapID.
-- 야외 지역: { pin = true } (월드맵 핀 표시 O)
-- 던전/레이드: true (핀 표시 X, 지역 경고만)
-- 역호환: NS.SpiderZones[mapID] 체크 시 둘 다 truthy
--
-- zoneId: Wowhead URL에서 사용하는 지역 ID (wowhead.com/zone=XX)
-- /ns mapid 로 현재 위치의 uiMapID를 확인할 수 있습니다.
-- /ns addregion 으로 현재 지역을 거미 출몰 지역에 추가.
-- /ns removeregion 으로 제거.

local _, NS = ...

NS.SpiderZones = {

    -- ============================================
    -- 동부 왕국 / Eastern Kingdoms
    -- ============================================

    -- Tirisfal Glades / 티리스팔 숲 (zoneId: 85)
    [1420] = { pin = true },

    -- Silverpine Forest / 은빛소나무 숲 (zoneId: 130)
    [1421] = { pin = true },

    -- Western Plaguelands / 서부 역병지대 (zoneId: 28)
    [1422] = { pin = true },

    -- Eastern Plaguelands / 동부 역병지대 (zoneId: 139)
    [1423] = { pin = true },

    -- Hillsbrad Foothills / 힐스브래드 구릉지 (zoneId: 267)
    [1424] = { pin = true },

    -- Alterac Mountains / 알터랙 산맥 (zoneId: 36)
    [1416] = { pin = true },

    -- Arathi Highlands / 아라시 고원 (zoneId: 45)
    [1417] = { pin = true },

    -- The Hinterlands / 동부 내륙지 (zoneId: 47)
    [1425] = { pin = true },

    -- Searing Gorge / 이글거리는 협곡 (zoneId: 51)
    [1427] = { pin = true },

    -- Burning Steppes / 불타는 평원 (zoneId: 46)
    [1428] = { pin = true },

    -- Elwynn Forest / 엘윈 숲 (zoneId: 12)
    [1429] = { pin = true },

    -- Duskwood / 그늘숲 (zoneId: 10)
    [1431] = { pin = true },

    -- Loch Modan / 모단 호수 (zoneId: 38)
    [1432] = { pin = true },

    -- Redridge Mountains / 붉은마루 산맥 (zoneId: 44)
    [1433] = { pin = true },

    -- Swamp of Sorrows / 슬픔의 늪 (zoneId: 8)
    [1435] = { pin = true },

    -- Wetlands / 저습지 (zoneId: 11)
    [1437] = { pin = true },

    -- ============================================
    -- 칼림도어 / Kalimdor
    -- ============================================

    -- Teldrassil / 텔드랏실 (zoneId: 141)
    [1438] = { pin = true },

    -- Ashenvale / 잿빛 골짜기 (zoneId: 331)
    [1440] = { pin = true },

    -- Stonetalon Mountains / 돌발톱 산맥 (zoneId: 406)
    [1442] = { pin = true },

    -- Dustwallow Marsh / 먼지진흙 습지대 (zoneId: 15)
    [1445] = { pin = true },

    -- Tanaris / 타나리스 (zoneId: 440)
    [1446] = { pin = true },

    -- Azshara / 아즈샤라 (zoneId: 16)
    [1447] = { pin = true },

    -- Un'Goro Crater / 운고로 분화구 (zoneId: 490)
    [1449] = { pin = true },

    -- Silithus / 실리더스 (zoneId: 1377)
    [1451] = { pin = true },

    -- ============================================
    -- 아웃랜드·기타 / Outland & misc (TBC)
    -- ============================================

    -- Terokkar Forest / 테로카르 숲 (zoneId: 3519)
    [1952] = { pin = true },

    -- Ghostlands / 유령의 땅 (zoneId: 3433)
    [1942] = { pin = true },

    -- Bloodmyst Isle / 핏빛안개 섬 (zoneId: 3525)
    [1950] = { pin = true },

    -- Blade's Edge Mountains / 칼날 산맥 (zoneId: 3522)
    [1949] = { pin = true },

    -- ============================================
    -- 던전 / Dungeons
    -- ============================================

    -- Blackrock Depths / 검은바위 나락 — 2 sub-maps
    [242] = true,  -- Detention Block
    [243] = true,  -- Shadowforge City

    -- Dire Maul / 혈투의 전장 — 6 sub-maps
    [235] = true,  -- Gordok Commons
    [236] = true,  -- Capital Gardens
    [237] = true,  -- Court of the Highborne
    [238] = true,  -- Prison of Immol'Thar
    [239] = true,  -- Warpwood Quarter
    [240] = true,  -- The Shrine of Eldretharr

    -- Razorfen Downs / 가시덩굴 구릉
    [300] = true,

    -- Scholomance / 스칼로맨스 — 4 sub-maps
    [306] = true,  -- The Reliquary
    [307] = true,  -- Chamber of Summoning
    [308] = true,  -- The Upper Study
    [309] = true,  -- Headmaster's Study

    -- Stratholme / 스트라솔름 — 2 sub-maps
    [317] = true,  -- Crusader's Square
    [318] = true,  -- The Gauntlet

    -- Blackrock Spire / 검은바위 첨탑 — 6 sub-maps
    [250] = true,  -- Tazz'Alor
    [251] = true,  -- Skitterweb Tunnels
    [252] = true,  -- Hordemar City
    [253] = true,  -- Hall of Blackhand
    [254] = true,  -- Halycon's Lair
    [255] = true,  -- Chamber of Battle

    -- The Shattered Halls / 으스러진 손의 전당
    [246] = true,

    -- ============================================
    -- 레이드 / Raids
    -- ============================================

    -- Naxxramas / 낙스라마스 — 6 sub-maps
    [162] = true,  -- The Construct Quarter
    [163] = true,  -- The Arachnid Quarter
    [164] = true,  -- The Military Quarter
    [165] = true,  -- The Plague Quarter
    [166] = true,  -- Frostwyrm Lair
    [167] = true,  -- Kel'Thuzad's Chamber

    -- Ahn'Qiraj / 안퀴라즈 — 4 entries
    [247] = true,  -- Ruins of Ahn'Qiraj
    [319] = true,  -- The Hive Undergrounds
    [320] = true,  -- The Temple Gates
    [321] = true,  -- Vault of C'Thun

    -- Karazhan / 카라잔 — 17 sub-maps (350-366)
    [350] = true, [351] = true, [352] = true, [353] = true,
    [354] = true, [355] = true, [356] = true, [357] = true,
    [358] = true, [359] = true, [360] = true, [361] = true,
    [362] = true, [363] = true, [364] = true, [365] = true,
    [366] = true,

    -- Hyjal Summit / 하이잘 정상 (시간의 동굴)
    [329] = true,
}
