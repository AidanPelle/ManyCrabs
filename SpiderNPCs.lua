-- SpiderNPCs.lua
-- 거미 NPC ID + 이름 패턴 데이터베이스
-- 기여/추가: /nospider add <NPC ID>

local _, NS = ...

-- { [npcID] = true }
-- 주요 거미 몬스터 목록 (클래식/TBC)
NS.SpiderIDs = {

    -- ============================================
    -- 텔드랏실 / Teldrassil
    -- ============================================
    [1986] = true,  -- Webwood Spider / 나무그물거미
    [1998] = true,  -- Webwood Lurker / 나무그물 늑대거미
    [1999] = true,  -- Webwood Venomfang / 나무그물 독거미
    [2000] = true,  -- Webwood Silkspinner / 나무그물 비단거미
    [2001] = true,  -- Giant Webwood Spider / 거대한 나무그물 거미
    [1994] = true,  -- Githyiss the Vile / 흉측한 기시이스
    [7319] = true,  -- Lady Sathrah / 여왕거미 사스라

    -- ============================================
    -- 엘윈 숲 / Elwynn Forest
    -- ============================================
    [30]   = true,  -- Forest Spider / 숲거미
    [43]   = true,  -- Mine Spider / 굴거미
    [471]  = true,  -- Mother Fang / 여왕 굴거미

    -- ============================================
    -- 티리스팔 숲 / Tirisfal Glades
    -- ============================================
    [1504] = true,  -- Young Night Web Spider / 새끼 검은그물거미
    [1505] = true,  -- Night Web Spider / 검은그물거미
    [1555] = true,  -- Vicious Night Web Spider / 흉포한 검은그물거미
    [1688] = true,  -- Night Web Matriarch / 여왕 검은그물거미
    [10359] = true, -- Sri'skulk / 스리술크

    -- ============================================
    -- 은빛소나무 숲 / Silverpine Forest
    -- ============================================
    [1780] = true,  -- Moss Stalker / 이끼땅거미
    [1781] = true,  -- Mist Creeper / 안개땅거미
    [12433] = true, -- Krethis Shadowspinner / 크레시스 섀도스피너

    -- ============================================
    -- 서부 역병지대 / Western Plaguelands
    -- ============================================
    [1821] = true,  -- Carrion Lurker / 청소부 늑대거미
    [1822] = true,  -- Venom Mist Lurker / 독안개 늑대거미
    [1824] = true,  -- Plague Lurker / 돌연변이 늑대거미

    -- ============================================
    -- 동부 역병지대 / Eastern Plaguelands
    -- ============================================
    [8555] = true,  -- Crypt Stalker / 지하추적자
    [8556] = true,  -- Crypt Walker / 거미턱 지하마귀
    [8557] = true,  -- Crypt Horror / 공포의 지하마귀
    [8558] = true,  -- Crypt Slayer / 학살자 지하마귀

    -- ============================================
    -- 모단 호수 / Loch Modan
    -- ============================================
    [1184] = true,  -- Cliff Lurker / 절벽늑대거미
    [1185] = true,  -- Wood Lurker / 나무늑대거미
    [1195] = true,  -- Forest Lurker / 숲늑대거미
    [14266] = true, -- Shanda the Spinner / 검은올가미 샨다

    -- ============================================
    -- 저습지 / Wetlands
    -- ============================================
    [1111] = true,  -- Leech Stalker / 긴다리흡혈거미
    [1112] = true,  -- Leech Widow / 거머리과부거미
    [4040] = true,  -- Cave Stalker / 긴다리동굴거미

    -- ============================================
    -- 붉은마루 산맥 / Redridge Mountains
    -- ============================================
    [442]  = true,  -- Tarantula / 타란툴라
    [505]  = true,  -- Greater Tarantula / 거대한 타란툴라
    [616]  = true,  -- Chatter / 우두머리 집게턱타란툴라

    -- ============================================
    -- 그늘숲 / Duskwood
    -- ============================================
    [217]  = true,  -- Venom Web Spider / 그물독거미
    [539]  = true,  -- Pygmy Venom Web Spider / 새끼 그물독거미
    [569]  = true,  -- Green Recluse / 녹색그늘거미
    [574]  = true,  -- Naraxis / 나락시스
    [930]  = true,  -- Black Widow Hatchling / 새끼 검은과부거미
    [949]  = true,  -- Carrion Recluse / 청소부그늘거미


    -- ============================================
    -- 슬픔의 늪 / Swamp of Sorrows
    -- ============================================
    [769]  = true,  -- Deathstrike Tarantula / 맹독타란툴라
    [858]  = true,  -- Sorrow Spinner / 늪그물거미

    -- ============================================
    -- 잿빛 골짜기 / Ashenvale
    -- ============================================
    [3819] = true,  -- Wildthorn Stalker / 찔레가시 거미
    [3820] = true,  -- Wildthorn Venomspitter / 찔레가시 독거미
    [3821] = true,  -- Wildthorn Lurker / 찔레가시 늑대거미

    -- ============================================
    -- 돌발톱 산맥 / Stonetalon Mountains
    -- ============================================
    [4005] = true,  -- Deepmoss Creeper / 동굴이끼 땅거미
    [4006] = true,  -- Deepmoss Webspinner / 동굴이끼 그물거미
    [4007] = true,  -- Deepmoss Venomspitter / 동굴이끼 독거미
    [4263] = true,  -- Deepmoss Hatchling / 동굴이끼 새끼거미
    [4264] = true,  -- Deepmoss Matriarch / 동굴이끼 우두머리거미
    [11921] = true, -- Besseleth / 베스셀레스

    -- ============================================
    -- 힐스브래드 구릉지 / Hillsbrad Foothills
    -- ============================================
    [2348] = true,  -- Elder Moss Creeper / 덩치큰 이끼거미
    [2349] = true,  -- Giant Moss Creeper / 거대한 이끼거미
    [2350] = true,  -- Forest Moss Creeper / 숲이끼거미
    [14279] = true, -- Creepthess / 땅거미

    -- ============================================
    -- 아라시 고원 / Arathi Highlands
    -- ============================================
    [2563] = true,  -- Plains Creeper / 평원타란툴라
    [2565] = true,  -- Giant Plains Creeper / 거대한 평원타란툴라

    -- ============================================
    -- 먼지진흙 습지대 / Dustwallow Marsh
    -- ============================================
    [4376] = true,  -- Darkmist Spider / 암흑안개 거미
    [4377] = true,  -- Darkmist Lurker / 암흑안개 늑대거미
    [4378] = true,  -- Darkmist Recluse / 암흑안개 그늘거미
    [4379] = true,  -- Darkmist Silkspinner / 암흑안개 비단거미
    [4380] = true,  -- Darkmist Widow / 암흑안개 과부거미
    [4411] = true,  -- Darkfang Lurker / 검은송곳니 늑대거미
    [4412] = true,  -- Darkfang Creeper / 검은송곳니 땅거미
    [4413] = true,  -- Darkfang Spider / 검은송곳니 거미
    [4414] = true,  -- Darkfang Venomspitter / 검은송곳니 독거미
    [4415] = true,  -- Giant Darkfang Spider / 거대한 검은송곳니 거미

    -- ============================================
    -- 타나리스 / Tanaris
    -- ============================================
    [5455] = true,  -- Centipaar Wasp / 병정 센티파르
    [5456] = true,  -- Centipaar Stinger / 독침 센티파르
    [5457] = true,  -- Centipaar Swarmer / 우두머리 센티파르
    [5458] = true,  -- Centipaar Worker / 일꾼 센티파르
    [5459] = true,  -- Centipaar Tunneler / 땅꾼 센티파르
    [5460] = true,  -- Centipaar Sandreaver / 모래무지 센티파르

    -- ============================================
    -- 운고로 분화구 / Un'Goro Crater
    -- ============================================
    [6551]  = true, -- Gorishi Wasp / 병정 고리쉬
    [6552]  = true, -- Gorishi Worker / 일꾼 고리쉬
    [6553]  = true, -- Gorishi Reaver / 갈퀴발톱 고리쉬
    [6554]  = true, -- Gorishi Stinger / 독침 고리쉬
    [6555]  = true, -- Gorishi Tunneler / 땅꾼 고리쉬
    [9496]  = true, -- Gorishi Egg / 고리쉬 알
    [9498]  = true, -- Gorishi Grub / 고리쉬 유충
    [10040] = true, -- Gorishi Hive Guard / 파수꾼 고리쉬
    [10041] = true, -- Gorishi Hive Queen / 여왕 고리쉬

    -- ============================================
    -- 이글거리는 협곡 / Searing Gorge
    -- ============================================
    [5856] = true,  -- Glassweb Spider / 유리그물거미
    [5857] = true,  -- Searing Lava Spider / 불타는 용암거미
    [5858] = true,  -- Greater Lava Spider / 거대한 용암거미
    [8277] = true,  -- Rekk'tilac / 레크틸락

    -- ============================================
    -- 불타는 평원 / Burning Steppes
    -- ============================================
    [9699]  = true,  -- Fire Beetle / 불딱정벌레

    -- ============================================
    -- 아즈샤라 / Azshara
    -- ============================================
    [8762] = true,  -- Timberweb Recluse / 그물나무그늘거미

    -- ============================================
    -- 실리더스 / Silithus
    -- ============================================
    [11738] = true, -- Sand Skitterer / 모래그물 바위거미
    [11739] = true, -- Rock Stalker / 긴다리 바위거미
    [14472] = true, -- Gretheer / 그리시르

    -- ============================================
    -- 검은바위 나락 / Blackrock Depths (던전)
    -- ============================================
    [8933] = true,  -- Cave Creeper / 굴거미
    [8932] = true,  -- Borer Beetle / 천공딱정벌레

    -- ============================================
    -- 혈투의 전장 / Dire Maul (던전)
    -- ============================================
    [13160] = true, -- Carrion Swarmer / 청소부딱정벌레

    -- ============================================
    -- 가시덩굴 구릉 / Razorfen Downs (던전)
    -- ============================================
    [7349] = true,  -- Tomb Fiend / 무덤지하마귀
    [7351] = true,  -- Tomb Reaver / 갈퀴발톱 무덤지하마귀
    [7355] = true,  -- Tuten'kash / 투텐카쉬

    -- ============================================
    -- 스트라솔름 / Stratholme (던전)
    -- ============================================
    [10412] = true, -- Crypt Crawler / 갈퀴발 지하마귀
    [10413] = true, -- Crypt Beast / 흉포한 지하마귀

    -- ============================================
    -- 스칼로맨스 / Scholomance (던전)
    -- ============================================
    [11551] = true, -- Necrofiend / 소생한 지하마귀

    -- ============================================
    -- 검은바위 첨탑 / Blackrock Spire (던전)
    -- ============================================
    [10596] = true, -- Mother Smolderweb / 여왕 불그물거미
    [10375] = true, -- Spire Spiderling / 새끼 첨탑거미
    [10376] = true, -- Crystal Fang / 수정 맹독거미

    -- ============================================
    -- 줄구룹 / Zul'Gurub (레이드)
    -- ============================================
    [11370] = true, -- Razzashi Broodwidow / 래즈자쉬 과부거미
    [14532] = true, -- Razzashi Venombrood / 래즈자쉬 독거미
    [15041] = true, -- Spawn of Mar'li / 말리의 새끼거미

    -- ============================================
    -- 안퀴라즈 / AQ20, AQ40 (레이드)
    -- ============================================
    [15229] = true, -- Vekniss Soldier / 병정 베크니스
    [15230] = true, -- Vekniss Warrior / 전사 베크니스
    [15233] = true, -- Vekniss Guardian / 수호병 베크니스
    [15240] = true, -- Vekniss Hive Crawler / 집게발 베크니스
    [15247] = true, -- Qiraji Brainwasher / 퀴라지 세뇌관
    [15510] = true, -- Fankriss the Unyielding / 불굴의 판크리스
    [15511] = true, -- Lord Kri / 군주 크리
    [15475] = true, -- Beetle / 딱정벌레

    -- ============================================
    -- 낙스라마스 / Naxxramas (레이드)
    -- ============================================
    [15952] = true, -- Maexxna / 맥스나
    [15974] = true, -- Dread Creeper / 공포의 암흑거미
    [15975] = true, -- Carrion Spinner / 청소부 그물거미
    [15976] = true, -- Venom Stalker / 맹독 늑대거미
    [15977] = true, -- Infectious Skitterer / 전염병 독거미
    [15978] = true, -- Crypt Reaver / 칼날발톱 지하마귀
    [16573] = true, -- Crypt Guard / 지하마귀 수호병
    [16698] = true, -- Corpse Scarab / 송장 딱정벌레

    -- ============================================
    -- [TBC] 테로카르 숲 / Terokkar Forest
    -- ============================================
    [18466] = true, -- Dreadfang Lurker / 공포의 송곳니 늑대거미
    [18467] = true, -- Dreadfang Widow / 공포의 송곳니 과부거미
    [18647] = true, -- Deathskitter / 죽음의 땅거미

    -- ============================================
    -- [TBC] 핏빛안개 섬 / Bloodmyst Isle
    -- ============================================
    [17522] = true, -- Myst Spinner / 안개 그물거미
    [17523] = true, -- Myst Leecher / 안개 흡혈거미
    [17683] = true, -- Zarakh / 자라크

    -- ============================================
    -- [TBC] 칼날 산맥 / Blade's Edge Mountains
    -- ============================================
    [20714] = true, -- Ridge Stalker / 긴다리 마루돌기거미
    [20998] = true, -- Ridgespine Horror / 공포의 마루돌기거미
    [22044] = true, -- Cave Spider / 동굴 거미
    [22132] = true, -- Mature Cavern Crawler / 거대한 동굴 거미

    -- ============================================
    -- 동부 내륙지 / The Hinterlands
    -- ============================================
    [2686] = true,  -- Witherbark Broodguard / 마른나무껍질부족 혈거미
    [17236] = true, -- Tcha'kaz / 트차카즈

    -- ============================================
    -- [TBC] 카라잔 / Karazhan (레이드)
    -- ============================================
    [16170] = true, -- Coldmist Stalker / 얼음안개 땅거미
    [16171] = true, -- Coldmist Widow / 얼음안개 과부거미
    [16179] = true, -- Hyakiss the Lurker / 잠복꾼 히아키스

    -- ============================================
    -- [TBC] 유령의 땅 / Ghostlands
    -- ============================================
    [16350] = true, -- Spindleweb Spider / 물레그물 거미
    [16351] = true, -- Spindleweb Lurker / 물레그물 늑대거미
    [16352] = true, -- Giant Spindleweb Spider / 거대한 물레그물 거미

    -- ============================================
    -- [TBC] 하이잘 정상 / Hyjal Summit (레이드)
    -- ============================================
    [17897] = true, -- Crypt Fiend / 지하마귀

    -- ============================================
    -- [TBC] 아웃랜드 기타 / Outland misc
    -- ============================================
    [18983] = true, -- Blackfang Tarantula / 검은송곳니 타란툴라
    [20027] = true, -- Blackfang Tarantula / 검은송곳니 타란툴라
    [26033] = true, -- Tameable Spider / 길들일 수 있는 거미
    [22047] = true, -- Cave Beetle / 동굴 딱정벌레

    -- ============================================
    -- [TBC] 으스러진 손의 전당 / The Shattered Halls (던전)
    -- ============================================
    -- Fire Beetle (9699) 은 불타는 평원에 등록됨

    -- ============================================
    -- 사용자 커스텀 ID (슬래시 커맨드로 추가)
    -- ============================================
}

-- NPC 이름 데이터 (월드맵 NPC 목록 표시용)
-- { [npcID] = { "English Name", "한국어 이름" } }
NS.SpiderNames = {
    -- 텔드랏실 / Teldrassil
    [1986] = { "Webwood Spider", "나무그물거미" },
    [1998] = { "Webwood Lurker", "나무그물 늑대거미" },
    [1999] = { "Webwood Venomfang", "나무그물 독거미" },
    [2000] = { "Webwood Silkspinner", "나무그물 비단거미" },
    [2001] = { "Giant Webwood Spider", "거대한 나무그물 거미" },
    [1994] = { "Githyiss the Vile", "흉측한 기시이스" },
    [7319] = { "Lady Sathrah", "여왕거미 사스라" },
    -- 엘윈 숲 / Elwynn Forest
    [30]   = { "Forest Spider", "숲거미" },
    [43]   = { "Mine Spider", "굴거미" },
    [471]  = { "Mother Fang", "여왕 굴거미" },
    -- 티리스팔 숲 / Tirisfal Glades
    [1504] = { "Young Night Web Spider", "새끼 검은그물거미" },
    [1505] = { "Night Web Spider", "검은그물거미" },
    [1555] = { "Vicious Night Web Spider", "흉포한 검은그물거미" },
    [1688] = { "Night Web Matriarch", "여왕 검은그물거미" },
    [10359] = { "Sri'skulk", "스리술크" },
    -- 은빛소나무 숲 / Silverpine Forest
    [1780] = { "Moss Stalker", "이끼땅거미" },
    [1781] = { "Mist Creeper", "안개땅거미" },
    [12433] = { "Krethis Shadowspinner", "크레시스 섀도스피너" },
    -- 서부 역병지대 / Western Plaguelands
    [1821] = { "Carrion Lurker", "청소부 늑대거미" },
    [1822] = { "Venom Mist Lurker", "독안개 늑대거미" },
    [1824] = { "Plague Lurker", "돌연변이 늑대거미" },
    -- 동부 역병지대 / Eastern Plaguelands
    [8555] = { "Crypt Stalker", "지하추적자" },
    [8556] = { "Crypt Walker", "거미턱 지하마귀" },
    [8557] = { "Crypt Horror", "공포의 지하마귀" },
    [8558] = { "Crypt Slayer", "학살자 지하마귀" },
    -- 모단 호수 / Loch Modan
    [1184] = { "Cliff Lurker", "절벽늑대거미" },
    [1185] = { "Wood Lurker", "나무늑대거미" },
    [1195] = { "Forest Lurker", "숲늑대거미" },
    [14266] = { "Shanda the Spinner", "검은올가미 샨다" },
    -- 저습지 / Wetlands
    [1111] = { "Leech Stalker", "긴다리흡혈거미" },
    [1112] = { "Leech Widow", "거머리과부거미" },
    [4040] = { "Cave Stalker", "긴다리동굴거미" },
    -- 붉은마루 산맥 / Redridge Mountains
    [442]  = { "Tarantula", "타란툴라" },
    [505]  = { "Greater Tarantula", "거대한 타란툴라" },
    [616]  = { "Chatter", "우두머리 집게턱타란툴라" },
    -- 그늘숲 / Duskwood
    [217]  = { "Venom Web Spider", "그물독거미" },
    [539]  = { "Pygmy Venom Web Spider", "새끼 그물독거미" },
    [569]  = { "Green Recluse", "녹색그늘거미" },
    [574]  = { "Naraxis", "나락시스" },
    [930]  = { "Black Widow Hatchling", "새끼 검은과부거미" },
    [949]  = { "Carrion Recluse", "청소부그늘거미" },
    -- 슬픔의 늪 / Swamp of Sorrows
    [769]  = { "Deathstrike Tarantula", "맹독타란툴라" },
    [858]  = { "Sorrow Spinner", "늪그물거미" },
    -- 잿빛 골짜기 / Ashenvale
    [3819] = { "Wildthorn Stalker", "찔레가시 거미" },
    [3820] = { "Wildthorn Venomspitter", "찔레가시 독거미" },
    [3821] = { "Wildthorn Lurker", "찔레가시 늑대거미" },
    -- 돌발톱 산맥 / Stonetalon Mountains
    [4005] = { "Deepmoss Creeper", "동굴이끼 땅거미" },
    [4006] = { "Deepmoss Webspinner", "동굴이끼 그물거미" },
    [4007] = { "Deepmoss Venomspitter", "동굴이끼 독거미" },
    [4263] = { "Deepmoss Hatchling", "동굴이끼 새끼거미" },
    [4264] = { "Deepmoss Matriarch", "동굴이끼 우두머리거미" },
    [11921] = { "Besseleth", "베스셀레스" },
    -- 힐스브래드 구릉지 / Hillsbrad Foothills
    [2348] = { "Elder Moss Creeper", "덩치큰 이끼거미" },
    [2349] = { "Giant Moss Creeper", "거대한 이끼거미" },
    [2350] = { "Forest Moss Creeper", "숲이끼거미" },
    [14279] = { "Creepthess", "땅거미" },
    -- 아라시 고원 / Arathi Highlands
    [2563] = { "Plains Creeper", "평원타란툴라" },
    [2565] = { "Giant Plains Creeper", "거대한 평원타란툴라" },
    -- 먼지진흙 습지대 / Dustwallow Marsh
    [4376] = { "Darkmist Spider", "암흑안개 거미" },
    [4377] = { "Darkmist Lurker", "암흑안개 늑대거미" },
    [4378] = { "Darkmist Recluse", "암흑안개 그늘거미" },
    [4379] = { "Darkmist Silkspinner", "암흑안개 비단거미" },
    [4380] = { "Darkmist Widow", "암흑안개 과부거미" },
    [4411] = { "Darkfang Lurker", "검은송곳니 늑대거미" },
    [4412] = { "Darkfang Creeper", "검은송곳니 땅거미" },
    [4413] = { "Darkfang Spider", "검은송곳니 거미" },
    [4414] = { "Darkfang Venomspitter", "검은송곳니 독거미" },
    [4415] = { "Giant Darkfang Spider", "거대한 검은송곳니 거미" },
    -- 타나리스 / Tanaris
    [5455] = { "Centipaar Wasp", "병정 센티파르" },
    [5456] = { "Centipaar Stinger", "독침 센티파르" },
    [5457] = { "Centipaar Swarmer", "우두머리 센티파르" },
    [5458] = { "Centipaar Worker", "일꾼 센티파르" },
    [5459] = { "Centipaar Tunneler", "땅꾼 센티파르" },
    [5460] = { "Centipaar Sandreaver", "모래무지 센티파르" },
    -- 운고로 분화구 / Un'Goro Crater
    [6551] = { "Gorishi Wasp", "병정 고리쉬" },
    [6552] = { "Gorishi Worker", "일꾼 고리쉬" },
    [6553] = { "Gorishi Reaver", "갈퀴발톱 고리쉬" },
    [6554] = { "Gorishi Stinger", "독침 고리쉬" },
    [6555] = { "Gorishi Tunneler", "땅꾼 고리쉬" },
    [9496] = { "Gorishi Egg", "고리쉬 알" },
    [9498] = { "Gorishi Grub", "고리쉬 유충" },
    [10040] = { "Gorishi Hive Guard", "파수꾼 고리쉬" },
    [10041] = { "Gorishi Hive Queen", "여왕 고리쉬" },
    -- 이글거리는 협곡 / Searing Gorge
    [5856] = { "Glassweb Spider", "유리그물거미" },
    [5857] = { "Searing Lava Spider", "불타는 용암거미" },
    [5858] = { "Greater Lava Spider", "거대한 용암거미" },
    [8277] = { "Rekk'tilac", "레크틸락" },
    -- 불타는 평원 / Burning Steppes
    [9699] = { "Fire Beetle", "불딱정벌레" },
    -- 아즈샤라 / Azshara
    [8762] = { "Timberweb Recluse", "그물나무그늘거미" },
    -- 실리더스 / Silithus
    [11738] = { "Sand Skitterer", "모래그물 바위거미" },
    [11739] = { "Rock Stalker", "긴다리 바위거미" },
    [14472] = { "Gretheer", "그리시르" },
    -- 동부 내륙지 / The Hinterlands
    [2686] = { "Witherbark Broodguard", "마른나무껍질부족 혈거미" },
    [17236] = { "Tcha'kaz", "트차카즈" },
    -- 알터랙 산맥 / Alterac Mountains
    [2349] = { "Giant Moss Creeper", "거대한 이끼거미" },
    [2350] = { "Forest Moss Creeper", "숲이끼거미" },
    -- [TBC] 테로카르 숲 / Terokkar Forest
    [18466] = { "Dreadfang Lurker", "공포의 송곳니 늑대거미" },
    [18467] = { "Dreadfang Widow", "공포의 송곳니 과부거미" },
    [18647] = { "Deathskitter", "죽음의 땅거미" },
    -- [TBC] 핏빛안개 섬 / Bloodmyst Isle
    [17522] = { "Myst Spinner", "안개 그물거미" },
    [17523] = { "Myst Leecher", "안개 흡혈거미" },
    [17683] = { "Zarakh", "자라크" },
    -- [TBC] 칼날 산맥 / Blade's Edge Mountains
    [20714] = { "Ridge Stalker", "긴다리 마루돌기거미" },
    [20998] = { "Ridgespine Horror", "공포의 마루돌기거미" },
    [22044] = { "Cave Spider", "동굴 거미" },
    [22132] = { "Mature Cavern Crawler", "거대한 동굴 거미" },
    -- [TBC] 유령의 땅 / Ghostlands
    [16350] = { "Spindleweb Spider", "물레그물 거미" },
    [16351] = { "Spindleweb Lurker", "물레그물 늑대거미" },
    [16352] = { "Giant Spindleweb Spider", "거대한 물레그물 거미" },
    -- 검은바위 나락 / Blackrock Depths (던전)
    [8933] = { "Cave Creeper", "굴거미" },
    [8932] = { "Borer Beetle", "천공딱정벌레" },
    -- 혈투의 전장 / Dire Maul (던전)
    [13160] = { "Carrion Swarmer", "청소부딱정벌레" },
    -- 가시덩굴 구릉 / Razorfen Downs (던전)
    [7349] = { "Tomb Fiend", "무덤지하마귀" },
    [7351] = { "Tomb Reaver", "갈퀴발톱 무덤지하마귀" },
    [7355] = { "Tuten'kash", "투텐카쉬" },
    -- 검은바위 첨탑 / Blackrock Spire (던전)
    [10596] = { "Mother Smolderweb", "여왕 불그물거미" },
    [10375] = { "Spire Spiderling", "새끼 첨탑거미" },
    [10376] = { "Crystal Fang", "수정 맹독거미" },
    -- 줄구룹 / Zul'Gurub (레이드)
    [11370] = { "Razzashi Broodwidow", "래즈자쉬 과부거미" },
    [14532] = { "Razzashi Venombrood", "래즈자쉬 독거미" },
    [15041] = { "Spawn of Mar'li", "말리의 새끼거미" },
    -- 안퀴라즈 / AQ20, AQ40 (레이드)
    [15229] = { "Vekniss Soldier", "병정 베크니스" },
    [15230] = { "Vekniss Warrior", "전사 베크니스" },
    [15233] = { "Vekniss Guardian", "수호병 베크니스" },
    [15240] = { "Vekniss Hive Crawler", "집게발 베크니스" },
    [15247] = { "Qiraji Brainwasher", "퀴라지 세뇌관" },
    [15510] = { "Fankriss the Unyielding", "불굴의 판크리스" },
    [15511] = { "Lord Kri", "군주 크리" },
    [15475] = { "Beetle", "딱정벌레" },
    -- 스트라솔름 / Stratholme (던전)
    [10412] = { "Crypt Crawler", "갈퀴발 지하마귀" },
    [10413] = { "Crypt Beast", "흉포한 지하마귀" },
    -- 스칼로맨스 / Scholomance (던전)
    [11551] = { "Necrofiend", "소생한 지하마귀" },
    -- 낙스라마스 / Naxxramas (레이드)
    [15952] = { "Maexxna", "맥스나" },
    [15974] = { "Dread Creeper", "공포의 암흑거미" },
    [15975] = { "Carrion Spinner", "청소부 그물거미" },
    [15976] = { "Venom Stalker", "맹독 늑대거미" },
    [15977] = { "Infectious Skitterer", "전염병 독거미" },
    [15978] = { "Crypt Reaver", "칼날발톱 지하마귀" },
    [16573] = { "Crypt Guard", "지하마귀 수호병" },
    [16698] = { "Corpse Scarab", "송장 딱정벌레" },
    -- [TBC] 카라잔 / Karazhan (레이드)
    [16170] = { "Coldmist Stalker", "얼음안개 땅거미" },
    [16171] = { "Coldmist Widow", "얼음안개 과부거미" },
    [16179] = { "Hyakiss the Lurker", "잠복꾼 히아키스" },
    -- [TBC] 하이잘 정상 / Hyjal Summit (레이드)
    [17897] = { "Crypt Fiend", "지하마귀" },
    -- [TBC] 기타
    [22047] = { "Cave Beetle", "동굴 딱정벌레" },
}

-- 지역별 거미 NPC 매핑 (uiMapID → NPC ID 목록)
-- SpiderSpawnData.lua 주석의 NPC 목록과 동기화 필요
NS.SpiderZoneNPCs = {
    [1435] = { 769, 858 },                                     -- 슬픔의 늪
    [1431] = { 217, 539, 569, 574, 930, 949 },                 -- 그늘숲
    [1437] = { 1111, 1112, 4040 },                              -- 저습지
    [1429] = { 30, 43, 471 },                                   -- 엘윈 숲
    [1445] = { 4376, 4377, 4378, 4379, 4380, 4411, 4412, 4413, 4414, 4415 }, -- 먼지진흙 습지대
    [1447] = { 8762 },                                          -- 아즈샤라
    [1422] = { 1821, 1822, 1824 },                              -- 서부 역병지대
    [1423] = { 8555, 8556, 8557, 8558 },                          -- 동부 역병지대
    [1416] = { 2349, 2350 },                                    -- 알터랙 산맥
    [1432] = { 1184, 1185, 1195, 14266 },                       -- 모단 호수
    [1433] = { 442, 505, 616 },                                 -- 붉은마루 산맥
    [1417] = { 2563, 2565 },                                    -- 아라시 고원
    [1425] = { 2686, 17236 },                                   -- 동부 내륙지
    [1427] = { 5856, 5857, 5858, 8277, 9699 },                   -- 이글거리는 협곡
    [1428] = { 9699 },                                          -- 불타는 평원
    [1420] = { 1504, 1505, 1555, 1688, 10359 },                 -- 티리스팔 숲
    [1421] = { 1780, 1781, 12433 },                              -- 은빛소나무 숲
    [1438] = { 1986, 1994, 1998, 1999, 2000, 2001, 7319 },      -- 텔드랏실
    [1424] = { 2348, 2349, 2350, 14279 },                       -- 힐스브래드 구릉지
    [1440] = { 3819, 3820, 3821 },                              -- 잿빛 골짜기
    [1442] = { 4005, 4006, 4007, 4263, 4264, 11921 },           -- 돌발톱 산맥
    [1446] = { 5455, 5456, 5457, 5458, 5459, 5460 },            -- 타나리스
    [1449] = { 6551, 6552, 6553, 6554, 6555, 9496, 9498, 10040, 10041 }, -- 운고로 분화구
    [1451] = { 11738, 11739, 14472 },                            -- 실리더스
    [1942] = { 16350, 16351, 16352 },                            -- 유령의 땅
    [1952] = { 18466, 18467, 18647 },                            -- 테로카르 숲
    [1949] = { 20714, 20998, 22044, 22132 },                     -- 칼날 산맥
    [1950] = { 17522, 17523, 17683 },                            -- 핏빛안개 섬
}

-- 던전/레이드 입구 툴팁 매핑 (툴팁 텍스트 → NPC ID 목록)
-- 월드맵 던전 아이콘 hover 시 거미 NPC 목록 표시용
-- 영문/한국어 이름 모두 키로 등록
-- 던전/레이드 이름 번역 (영문 → 한국어)
NS.SpiderDungeonDisplayNames = {
    ["Blackrock Depths"]     = "검은바위 나락",
    ["Blackrock Spire"]      = "검은바위 첨탑",
    ["Lower Blackrock Spire"] = "검은바위 첨탑 하층",
    ["Upper Blackrock Spire"] = "검은바위 첨탑 상층",
    ["Razorfen Downs"]       = "가시덩굴 구릉",
    ["Zul'Gurub"]            = "줄구룹",
    ["Ruins of Ahn'Qiraj"]   = "안퀴라즈 폐허",
    ["Temple of Ahn'Qiraj"]  = "안퀴라즈 사원",
    ["Ahn'Qiraj"]            = "안퀴라즈",
    ["Stratholme"]           = "스트라솔름",
    ["Scholomance"]          = "스칼로맨스",
    ["Naxxramas"]            = "낙스라마스",
    ["Karazhan"]             = "카라잔",
    ["Hyjal Summit"]         = "하이잘 정상",
    ["Dire Maul"]            = "혈투의 전장",
    ["The Shattered Halls"]  = "으스러진 손의 전당",
}

NS.SpiderDungeonTooltips = {}
do
    local data = {
        { names = { "Blackrock Depths", "검은바위 나락" },
          npcs = { 8933, 8932 } },
        { names = { "Razorfen Downs", "가시덩굴 구릉" },
          npcs = { 7349, 7351, 7355 } },
        { names = { "Stratholme", "스트라솔름" },
          npcs = { 10412, 10413 } },
        { names = { "Scholomance", "스칼로맨스" },
          npcs = { 11551 } },
        { names = { "Blackrock Spire", "검은바위 첨탑",
                    "Lower Blackrock Spire", "검은바위 첨탑 하층",
                    "Upper Blackrock Spire", "검은바위 첨탑 상층" },
          npcs = { 10596, 10375, 10376 } },
        { names = { "Zul'Gurub", "줄구룹" },
          npcs = { 11370, 14532, 15041 } },
        { names = { "Ruins of Ahn'Qiraj", "안퀴라즈 폐허" },
          npcs = { 15229, 15230, 15233, 15240, 15247, 15511, 15475 } },
        { names = { "Temple of Ahn'Qiraj", "안퀴라즈 사원", "Ahn'Qiraj", "안퀴라즈" },
          npcs = { 15229, 15230, 15233, 15240, 15247, 15510, 15511, 15475 } },
        { names = { "Naxxramas", "낙스라마스" },
          npcs = { 15952, 15974, 15975, 15976, 15977, 15978, 16573, 16698 } },
        { names = { "Hyjal Summit", "하이잘 정상" },
          npcs = { 17897 } },
        { names = { "Karazhan", "카라잔" },
          npcs = { 16170, 16171, 16179 } },
        { names = { "Dire Maul", "혈투의 전장" },
          npcs = { 13160 } },
        { names = { "The Shattered Halls", "으스러진 손의 전당" },
          npcs = { 9699 } },
    }
    for _, entry in ipairs(data) do
        for _, name in ipairs(entry.names) do
            NS.SpiderDungeonTooltips[name] = entry.npcs
        end
    end
end

-- 거미 던전/레이드 입구 핀 좌표 (C_EncounterJournal API 폴백용)
-- 좌표: 0~1 스케일 (맵 비율)
-- /ns pincoord 로 정확한 좌표를 측정하여 보정 가능
NS.SpiderDungeonPinData = {
    -- 이글거리는 협곡 → 검은바위 산 (나락 + 첨탑)
    [1427] = {
        { x = 0.44, y = 0.91, dungeons = { "Blackrock Depths", "Blackrock Spire" } },
    },
    -- 불타는 평원 → 검은바위 산
    [1428] = {
        { x = 0.29, y = 0.38, dungeons = { "Blackrock Depths", "Blackrock Spire" } },
    },
    -- 황야의 땅 → 가시덩굴 구릉
    [1413] = {
        { x = 0.41, y = 0.93, dungeons = { "Razorfen Downs" } },
    },
    -- 가시덤불 골짜기 → 줄구룹
    [1434] = {
        { x = 0.52, y = 0.17, dungeons = { "Zul'Gurub" } },
    },
    -- 동부 역병지대 → 스트라솔름, 낙스라마스
    [1423] = {
        { x = 0.43, y = 0.19, dungeons = { "Stratholme" } },
        { x = 0.31, y = 0.17, dungeons = { "Naxxramas" } },
    },
    -- 서부 역병지대 → 스칼로맨스
    [1422] = {
        { x = 0.69, y = 0.73, dungeons = { "Scholomance" } },
    },
    -- 실리더스 → 안퀴라즈
    [1451] = {
        { x = 0.26, y = 0.92, dungeons = { "Ruins of Ahn'Qiraj", "Temple of Ahn'Qiraj" } },
    },
    -- 죽음의 안개 → 카라잔
    [1430] = {
        { x = 0.47, y = 0.75, dungeons = { "Karazhan" } },
    },
    -- 타나리스 → 하이잘 정상 (시간의 동굴)
    [1446] = {
        { x = 0.66, y = 0.49, dungeons = { "Hyjal Summit" } },
    },
}

-- 거미 이름 패턴 매칭 (ID 목록에 없는 거미 보완용)
NS.SpiderNamePatterns = {
    -- 영어
    "spider", "tarantula", "webspinner", "silkspinner",
    "venomfang", "darkfang", "widow", "recluse",
    "skitterer", "creeper", "smolderweb", "webwood",
    "nerub", "crypt fiend",
    -- TBC 아웃랜드
    "dreadfang", "netherspine", "nethermine", "gorishi", "centipaar",
    -- 한국어
    "거미", "타란튤라", "독거미", "네루비안",
    "고리쉬", "센티파르",
}
