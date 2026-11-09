## Changelog

### [1.4.3] - 2026-03-27

#### 버그 수정
- **동일 종류 거미 반복 경고 수정**
  - 기존: 같은 종류(NPC ID)의 다른 개체(GUID)에 대해 2초 글로벌 쿨다운만 적용되어 반복 경고 발생
  - 변경: Per-GUID 쿨다운을 Per-NPC ID 쿨다운으로 대체하여 같은 종류의 거미는 60초간 재경고 억제
  - 설정 키 `warnedGuidCooldown` → `warnedNpcCooldown` 변경 (기존 설정 자동 마이그레이션)

### [1.4.2] - 2026-03-25

#### 데이터 추가
- **딱정벌레 계열 NPC 6종 추가**
  - 불타는 평원/이글거리는 협곡/으스러진 손의 전당: 불딱정벌레(9699, Fire Beetle)
  - 검은바위 나락: 천공딱정벌레(8932, Borer Beetle)
  - 안퀴라즈(AQ20/AQ40): 딱정벌레(15475, Beetle)
  - 혈투의 전장(Dire Maul): 청소부딱정벌레(13160, Carrion Swarmer)
  - 낙스라마스: 송장 딱정벌레(16698, Corpse Scarab)
  - 기타(위치 불명): 동굴 딱정벌레(22047, Cave Beetle)
- **거미 출몰 지역 5곳 추가**
  - 불타는 평원 (Burning Steppes, uiMapID 1428)
  - 검은바위 나락 (Blackrock Depths, uiMapID 242-243)
  - 혈투의 전장 (Dire Maul, uiMapID 235-240)
  - 으스러진 손의 전당 (The Shattered Halls, uiMapID 246)
- `NS.SpiderZoneNPCs` — 이글거리는 협곡에 9699 추가, 불타는 평원(1428) 신규 등록
- `NS.SpiderDungeonTooltips` — 검은바위 나락에 8932 추가, 안퀴라즈에 15475, 낙스라마스에 16698 추가 + 혈투의 전장·으스러진 손의 전당 신규 등록
- `NS.SpiderDungeonDisplayNames` — 혈투의 전장, 으스러진 손의 전당 추가
- `fetch_spawns.py` NPC 목록 및 존 매핑 동기화 (Burning Steppes zoneId 46 추가)
- 스폰 좌표: 29개 지역 13,279좌표 (이전 28개 지역 13,091좌표)

### [1.4.1] - 2026-03-23

#### 데이터 수정
- **지하마귀 NPC 11종 `NS.SpiderNames` 누락 수정**
  - NPC ID에만 등록되고 이름 테이블에 누락되어 월드맵 NPC 리스트에 표시되지 않던 문제 수정
  - 동부 역병지대: 거미턱 지하마귀(8556), 공포의 지하마귀(8557), 학살자 지하마귀(8558)
  - 가시덩굴 구릉: 무덤지하마귀(7349), 갈퀴발톱 무덤지하마귀(7351)
  - 스트라솔름: 갈퀴발 지하마귀(10412), 흉포한 지하마귀(10413)
  - 스칼로맨스: 소생한 지하마귀(11551)
  - 낙스라마스: 칼날발톱 지하마귀(15978), 지하마귀 수호병(16573)
  - 하이잘 정상: 지하마귀(17897)
- `NS.SpiderZoneNPCs[1423]` — 동부 역병지대에 8556, 8557, 8558 추가
- `NS.SpiderDungeonTooltips` — 스트라솔름, 스칼로맨스, 하이잘 정상 신규 등록 + 가시덩굴 구릉, 낙스라마스에 지하마귀 NPC 추가
- `NS.SpiderDungeonDisplayNames` — 스트라솔름, 스칼로맨스, 하이잘 정상 추가
- `NS.SpiderDungeonPinData` — 스트라솔름(동부 역병지대), 스칼로맨스(서부 역병지대), 하이잘 정상(타나리스) 핀 좌표 추가

#### UI/UX 개선
- **접근 경고 반경 미터 단위로 변경**
  - `spawnProximityRadius` (맵 비율 %) → `spawnProximityMeters` (미터)
  - `C_Map.GetMapWorldSize`로 존 크기를 가져와 미터→맵 좌표 자동 변환 (미지원 시 1333m 폴백)
  - 옵션 슬라이더: 30~300m (10m 단위, 기본 100m)
  - `/ns zone` 출력도 미터 단위로 변경
  - 거리 추정 표시(`EstimateRange`) 단위도 미터(m)로 통일
  - 기존 `spawnProximityRadius` 설정 자동 마이그레이션
- **프레임 우클릭 동작 변경**
  - 경고 배너 / NPC 목록 우클릭: 위치 초기화 → 설정 창 열기
  - 위치 초기화는 옵션 패널 버튼으로 사용

### [1.4.0] - 2026-03-21

#### 신규 기능
- **월드맵 NPC 목록 패널**
  - 지역 지도를 열면 좌하단에 해당 지역의 거미 NPC 목록 표시
  - 로캘에 맞는 언어(한국어/영문)로 NPC 이름 표시
  - 드래그로 위치 이동 가능, 우클릭으로 초기화
  - 대륙/던전/월드맵에서는 자동 숨김
- **던전 입구 커스텀 핀**
  - 거미 출몰 던전이 있는 지역 지도에 주황색 `!` 핀 표시
  - hover 시 던전 이름 + 거미 NPC 목록 툴팁
  - C_EncounterJournal API 우선, 하드코딩 좌표 폴백
  - 핀 크기 / 오프셋 사용자 설정 가능
- **프레임 드래그 이동**
  - 경고 배너, NPC 목록 패널을 드래그로 위치 이동 가능
  - 위치가 NoSpiderDB에 저장되어 재로그 시 복원
  - 우클릭으로 기본 위치 초기화
- **경고 배너 외형 설정**
  - 가로(150~500px), 세로(16~60px), 글꼴 크기(8~20pt) 조절 가능

#### 데이터 추가
- **지하마귀(Crypt Fiend) 계열 NPC 11종 추가**
  - 동부 역병지대: 거미턱 지하마귀(8556), 공포의 지하마귀(8557), 학살자 지하마귀(8558)
  - 스트라솔름: 갈퀴발 지하마귀(10412), 흉포한 지하마귀(10413)
  - 스칼로맨스: 소생한 지하마귀(11551)
  - 가시덩굴 구릉: 무덤지하마귀(7349), 갈퀴발톱 무덤지하마귀(7351)
  - 낙스라마스: 칼날발톱 지하마귀(15978), 지하마귀 수호병(16573)
  - 하이잘 정상: 지하마귀(17897)
- **거미 출몰 지역 4곳 추가**
  - 가시덩굴 구릉 (Razorfen Downs, uiMapID 300)
  - 스칼로맨스 (Scholomance, uiMapID 306-309)
  - 스트라솔름 (Stratholme, uiMapID 317-318)
  - 하이잘 정상 (Hyjal Summit, uiMapID 329)
- 동부 역병지대 (Eastern Plaguelands) SpiderZones에 등록 (uiMapID 1423)
- `NS.SpiderNames` — 전체 NPC ID → 이름(영문/한국어) 매핑 테이블 추가
- `NS.SpiderZoneNPCs` — 지역별 거미 NPC 매핑 (27개 야외 지역)
- `NS.SpiderDungeonTooltips` — 던전/레이드 이름 → NPC ID 목록 매핑
- `NS.SpiderDungeonDisplayNames` — 던전 이름 영한 번역 테이블
- `NS.SpiderDungeonPinData` — 던전 입구 좌표 폴백 데이터 (7개 지역)
- 던전/레이드 NPC 이름 데이터 추가 (검은바위 나락, 첨탑, 가시덩굴 구릉, 줄구룹, 안퀴라즈, 낙스라마스, 카라잔)

#### 설정 패널 전면 개편
- **AceConfig-3.0 / AceGUI-3.0 도입** — 기존 수동 UI를 Ace3 프레임워크로 교체
- 4개 탭 구성: 일반 / 경고 / 월드맵 / 오버레이
- 히트맵 해상도를 드롭다운으로 변경
- 색상 선택을 AceConfig 내장 color picker 사용
- 배너 위치 초기화, NPC 목록 위치 초기화 버튼 추가
- Blizzard Interface Options 통합

#### UI/UX 개선
- **월드맵 버튼 Krowi_WorldMapButtons 라이브러리 전환**
  - Questie 등 다른 애드온과 자동 정렬되는 미니맵 스타일 아이콘 버튼
  - 좌클릭: 히트맵 토글 (아이콘 주황↔회색 상태 표시)
  - 우클릭: 설정 드롭다운 메뉴 (해상도, NPC 목록, 설정 창)
  - 툴팁에 현재 히트맵/NPC 목록 ON/OFF 상태 표시
- **옵션 패널 설명 보강** — 모든 토글/슬라이더/색상 설정에 `desc` 툴팁 추가 (22개 항목)
- **`/ns help` 구조 개선** — 카테고리별 그룹핑(일반/오버레이/경고/NPC 관리/맵/개발자) + 색상 구분
  - 개발자 명령어를 회색으로 시각 분리
- **경고 배너 색상 사용자 설정** — 지역 경고/접근 경고 배너 배경색을 옵션 패널에서 커스텀 가능 (알파 포함)
- **히트맵 색상 커스텀** — 저밀도/고밀도 색상을 옵션 패널에서 변경 가능 (색맹 대응)

#### 코드 품질 개선
- `Util.lua` 신규 — 공통 상수 및 유틸리티 모듈
  - `NS.C` 색상 상수 테이블 (PREFIX, GREEN, ORANGE 등 11개 + LIGHTGREEN)
  - `NS.FONT_KR` 폰트 경로 상수
  - `NS.GRAN_LABELS` 히트맵 해상도 레이블 (중복 제거)
  - `NS.MakeMovable()` 드래그 이동 공용 함수
  - `NS.RestorePosition()` 저장된 위치 복원 함수
- Core.lua, MapOverlay.lua, SlashCommands.lua, OptionsPanel.lua 전체에서 하드코딩된 색상 코드, 폰트 경로, 채팅 접두사를 상수로 교체
- `NS.RefreshMapPins` → `NS.RefreshMapOverlay`로 통합 (에일리어스 제거, 전체 호출부 교체)
- `/ns debugpins` 제거 → `/ns debug` 통합 (월드맵 열림 시 핀 디버그 자동 포함)
- 월드맵 드롭다운 메뉴에 NPC 목록 토글 추가

### [1.3.2] - 2026-03-20

#### 데이터 추가
- NPC 8555 (Crypt Stalker / 지하추적자) 추가 — 동부 역병지대 (Eastern Plaguelands)
- `fetch_spawns.py` NPC 목록 및 존 매핑 동기화
- 스폰 좌표: 27개 지역 13,043좌표 → 28개 지역 13,091좌표

### [1.3.1] - 2026-03-19

#### 데이터 정확도 개선
- **거미 미출몰 지역 2곳 제거**
  - 서부 몰락지대 (Westfall) — NPC 120 (Forest Stalker)은 월드에 배치되지 않은 미사용 NPC
  - 불모의 땅 (The Barrens) — 잿빛 골짜기 경계선 좌표 3개만 존재하는 아티팩트
- **유령의 땅 (Ghostlands) 신규 추가**
  - Spindleweb Spider/Lurker/Giant (16350-16352)가 카라잔이 아닌 유령의 땅 소속으로 확인
  - SpiderZones, SpiderNPCs, SpiderSpawnData 모두 반영
- NPC 120 (Forest Stalker / 긴다리숲거미) 삭제 — 스폰 데이터 없는 미사용 NPC
- `fetch_spawns.py` NPC 목록 동기화 (NPC 120 제거, Spindleweb 3종 추가, The Barrens 제거, Ghostlands 추가)
- 스폰 좌표: 26개 지역 12,096좌표 → 27개 지역 13,043좌표

### [1.3.0] - 2026-03-17

#### 신규 기능
- **스폰 좌표 접근 경고** (서브존 경고 대체)
  - 기존 서브존 이름 기반 경고를 스폰 좌표 근접 감지로 전면 교체
  - `SpiderSpawnData` 좌표를 그리드 기반 공간 인덱스로 분할하여 O(1) 성능으로 실시간 검사
  - 플레이어 위치를 1.5초 간격으로 확인, 반경 내 스폰 좌표 접근 시 적색 배너 표시
  - 접근 경고 반경 조절 가능 (3%~15%, 기본 8%) — 설정 패널 슬라이더 또는 `/ns proximity`
  - 서브존 이름/언어 의존성 완전 제거
- **대륙 지도 히트맵 수정**
  - `C_Map.GetMapChildrenInfo` 기반으로 대륙 자식 존 탐색 방식 변경
  - SpiderZones uiMapId 의존 제거 → 클라이언트 API 기반 자동 매칭
  - `GetMapChildrenInfo` 실패 시 SpiderSpawnData 전체 키 폴백
- **슬래시 커맨드 변경**
  - `/ns proximity` — 스폰 좌표 접근 경고 토글 (신규)
  - `/ns zone` — 현재 위치의 스폰 좌표 접근 상태 표시로 변경
  - `/ns addzone`, `/ns removezone`, `/ns listzones` 제거

#### 데이터
- **스폰 좌표 데이터베이스 전면 재수집** (`SpiderSpawnData.lua`)
  - Wowhead zoneId 기준 분류로 전환 (uiMapId 오분류 해결)
  - 102개 NPC 수집 (기존 77개), 26개 지역, 12,096 스폰 좌표
  - 신규 지역: 서부 역병지대, 아라시 고원, 동부 내륙지, 슬픔의 늪, 잿빛 골짜기, 아즈샤라, 핏빛안개 섬
  - uiMapId 오매핑 수정: 1447 (Felwood→Azshara), 1950 (Zangarmarsh→Bloodmyst Isle), 1425 (Alterac→Hinterlands)
- **NPC 데이터 정리** (`SpiderNPCs.lua`)
  - Wowhead TBC 한국어 데이터 기반 NPC 이름 전수 검증 (128개 → 129개, 한국어 100%)
  - 37건 지역 오분류 수정 (Wowhead zoneId/tooltip API 대조)
  - WotLK 아즈조네룹 NPC 9개 제거 (TBC 미지원)
  - NPC 7355 (투텐카쉬) 추가
  - 영문명 정정: Mist Spider→Myst Spinner, Deathweb Spider→Deathskitter 등
- **한국어 지역명 전수 검증** (Wowhead TBC/ko 대조)
  - 8건 수정: 저습지, 잿빛 골짜기, 붉은마루 산맥, 서부 몰락지대, 악령의 숲, 장가르→장가르 습지대 삭제, 모단 호수, 검은바위 첨탑
  - 신규 지역 추가: 핏빛안개 섬, 아즈샤라, 동부 내륙지, 아라시 고원
- `SpiderZones.lua` Retail uiMapId 제거, TBC Classic 전용으로 정리
- `fetch_spawns.py` zoneId 기준 분류 전환, TBC 엔드포인트 통합

#### 구조 변경
- `Core.lua`: `GetCurrentSubZone()`, `IsSpiderSubZone()` 제거 → `GetSpawnGrid()`, `IsNearSpiderSpawn()` 추가
- `MapOverlay.lua`: 대륙 히트맵 `CollectContinentCoords` → `C_Map.GetMapChildrenInfo` 기반으로 변경
- 설정 키 변경: `subZoneWarning` → `spawnProximityWarning` + `spawnProximityRadius`
- `customSubZones` 설정 항목 제거

### [1.2.0] - 2026-03-17

#### 신규 기능
- **월드맵 거미 출몰 히트맵 오버레이**
  - 월드맵에 스폰 좌표 기반 밀도 히트맵 표시 (주황→빨강 그라데이션)
  - 히트맵 해상도 4단계 설정 (25/50/75/100 그리드)
  - 월드맵 우측 상단 [ManyCrabs] 드롭다운 메뉴로 즉시 토글/해상도 변경
  - 설정 패널 체크박스 + 해상도 슬라이더
- **슬래시 커맨드 추가**
  - `/ns mappins` — 월드맵 오버레이 토글
  - `/ns heatmap 1~4` — 히트맵 해상도 변경
  - `/ns pincoord` — 현재 위치 좌표를 Lua 테이블 형식으로 출력 (개발자용)

#### 데이터
- **스폰 좌표 데이터베이스 추가** (`SpiderSpawnData.lua`)
  - Wowhead `g_mapperData` 기반 77개 야외 NPC 좌표 자동 수집
  - 24개 지역, 10,300+ 스폰 좌표
  - 신규 지역 발견: 서부 역병지대, 잿빛 골짜기, 슬픔의 늪, 악령의 숲, 장가르 습지대, 칼날 산맥
- **SpiderZones.lua 포맷 변경**: 야외 지역 `true` → `{ pin = true }` (역호환 유지)
- **SpiderSubZones.lua 확장**: 좌표 테이블 + 한국어 별명 테이블 추가, 붉은마루 삼거리 추가

#### 구조 변경
- Core.lua 분할: 슬래시 커맨드 → `SlashCommands.lua`, 설정 패널 → `OptionsPanel.lua`
- `MapOverlay.lua` 신규: DeathLog 방식 `WorldMapFrame:GetCanvas()` 기반 오버레이 렌더링
- `tools/fetch_spawns.py`: Wowhead 좌표 자동 수집 스크립트

### [1.1.0] - 2026-03-17

#### 신규 기능
- **지역(Zone) 2단계 경고 시스템**: uiMapID 기반 지역 단위 사전 경고 추가
  - 서브존 경고 (적색 배너 + 소리): 거미 서식 서브존 진입 시
  - 지역 경고 (호박색 배너): 거미 출몰 지역 진입 시 (소리 없음)
  - 로케일(언어) 무관하게 숫자 ID로 동작
- **설정 패널 대폭 확장** (스크롤 프레임 추가)
  - 경고 설정: 지역/서브존 경고 토글, 지역 경고 소리, 전투 로그 감지, 죽은 거미 경고
  - 쿨다운/성능: 경고 쿨다운, 동일 거미 재경고 쿨다운, 리스캔 주기 조절
  - 오버레이 색상 선택 (ColorPicker 연동)
- **슬래시 커맨드 추가**
  - `/ns mapid` — 현재 위치 uiMapID 확인
  - `/ns addregion` / `/ns removeregion` — 커스텀 거미 출몰 지역 관리
  - `/ns listregions` — 커스텀 지역 목록
- `/ns zone` 진단에 지역 레벨 정보(mapID, 지역/서브존 상태) 추가
- `ZONE_CHANGED_INDOORS` 이벤트 등록 (던전 진입 감지)

#### 데이터
- **Classic uiMapID 추가**: Retail/Classic 양쪽 uiMapID 등록 (동부왕국 14개, 칼림도어 7개)
- **NPC 데이터 검증**: Wowhead TBC 거미 목록과 대조, 오등록 22개 제거
  - 삭제된 NPC: 31, 32, 446, 448, 534, 535, 536, 672, 673, 931, 1689, 3126, 3127, 4041, 5489, 8934, 10505, 10506, 16486, 20925, 21300, 21302
  - (들창코, 펄볼그, 워겐, 바실리스크, 전갈 등 거미가 아닌 NPC)

#### 구조 변경
- 데이터 파일 3분할: `SpiderDB.lua` → `SpiderNPCs.lua` + `SpiderSubZones.lua` + `SpiderZones.lua`

### [1.0.0] - 2026-03-14
최초 릴리스
- 네임플레이트 기반 거미/벌레형 몬스터 오버레이 가리기
- 오버레이에 거리 실시간 표시 (IsItemInRange 기반, 미터 단위)
- 전투 로그 기반 사전 경고 (네임플레이트 밖 ~50yd 거리 감지)
- 서브존 기반 거미 서식 구역 경고 배너
- 타겟/포커스 초상화 오버레이 가리기
- 죽은 거미 마우스오버 시 경고
- NPC ID 데이터베이스: 거미, 실리시드(고리쉬, 센티파), 네루비안 등 150+종
- 이름 패턴 자동 매칭 (spider, 거미, gorishi, centipaar 등)
- 커스텀 NPC ID 추가/제거 (/ns add, remove)
- 커스텀 서브존 관리 (/ns addzone, removezone, listzones)
- 오버레이 크기, 색상, 불투명도, 위치 조절
- 적 네임플레이트 자동 활성화
- 경고음 토글