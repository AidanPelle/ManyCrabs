# NoSpider - Arachnophobia Mode

An addon for players who are afraid of spiders, silithids, and other bug-type monsters. It places an overlay on nameplates to hide their 3D models.

⚠️ **Important Notice** This addon uses a **nameplate overlay** method, not a model swap. Spider models may still be visible when nameplates are not shown (long distance, corpses, cutscenes, right after loading, etc.). Please be cautious if you have severe arachnophobia.

## Features

*   **Nameplate Overlay** – Automatically covers spider-type monster nameplates to hide their 3D models
*   **Distance Display** – Shows real-time distance to the target on the overlay (in meters)
*   **Early Warning** – Alerts you when spiders approach from beyond nameplate range, based on combat log
*   **Spawn Proximity Warning** – Displays a warning banner when approaching spider spawn coordinates (radius adjustable 30~300m)
*   **Zone Warning** – Displays a warning banner when entering spider-inhabited zones
*   **World Map Heatmap** – Shows spider spawn density on zone and continent maps (orange→red gradient)
*   **Portrait Cover** – Hides spider images on target/focus unit frame portraits
*   **Corpse Warning** – Shows a warning on mouseover of dead spiders (corpses have no nameplates, so overlay is not possible)

## Detection Methods

*   **NPC ID Database** – 129 species including Classic/TBC spiders, silithids (Gorishi, Centipaar, etc.)
*   **Spawn Coordinate Database** – 12,000+ spawn coordinates across 26 zones (Wowhead data)
*   **Name Pattern Matching** – Auto-detects spiders not in the DB if their name contains keywords like "spider", "거미", etc.
*   **Custom Registration** – Add any NPC manually with `/ns add`

## Slash Commands (/ns)

| Command                     |Description                              |
| --------------------------- |---------------------------------------- |
| <code>/ns</code>            |Toggle addon on/off                      |
| <code>/ns alpha 0.0~1.0</code> |Adjust overlay opacity                   |
| <code>/ns width / height</code> |Adjust overlay size                      |
| <code>/ns portrait</code>   |Toggle target/focus portrait cover       |
| <code>/ns sound</code>      |Toggle warning sound                     |
| <code>/ns name</code>       |Toggle name pattern matching             |
| <code>/ns add [ID]</code>   |Add current target or specified NPC ID   |
| <code>/ns remove ID</code>  |Remove an NPC ID                         |
| <code>/ns check</code>      |Check if current target is a spider      |
| <code>/ns zone</code>       |Show current zone and spawn proximity    |
| <code>/ns proximity</code>  |Toggle spawn proximity warning           |
| <code>/ns mappins</code>    |Toggle world map heatmap overlay         |
| <code>/ns heatmap 1~4</code>|Set heatmap resolution (1=low, 4=max)    |
| <code>/ns debug</code>      |Print diagnostic info                    |
| <code>/ns config</code>     |Open settings panel                      |
| <code>/ns reset</code>      |Reset all settings                       |

## Supported Environments

*   WoW Classic TBC Anniversary server
*   Supports both Korean and English clients

## Notes

*   Enemy nameplates must be enabled (V key). The addon will attempt to enable them automatically.
*   Missing spiders can be added with `/ns add` or covered by name pattern matching.
*   Spider zones can be added with `/ns addregion` for zone-level warnings.

***

# NoSpider - 거미 공포증 모드

거미, 실리시드 등 벌레형 몬스터가 무서운 분들을 위한 애드온입니다. 네임플레이트 위에 오버레이를 씌워 거미 3D 모델을 가려줍니다.

⚠️ **주의사항** 이 애드온은 모델링 대체(Model Swap) 방식이 아닌 **네임플레이트 오버레이** 방식입니다. 네임플레이트가 표시되지 않는 상황(먼 거리, 시체, 컷신, 로딩 직후 등)에서는 거미 모델이 그대로 노출될 수 있습니다. 심한 공포증이 있는 분은 주의해 주세요.

## 주요 기능

*   **네임플레이트 오버레이** – 거미형 몬스터의 네임플레이트에 자동으로 커버를 씌워 3D 모델을 가림
*   **거리 표시** – 오버레이 위에 대상까지의 거리를 실시간 표시 (미터 단위)
*   **사전 경고** – 전투 로그 기반으로 네임플레이트 밖의 먼 거리에서도 거미 접근을 사전 알림
*   **스폰 좌표 접근 경고** – 거미 스폰 좌표에 접근하면 경고 배너 표시 (반경 30~300m 조절 가능)
*   **지역 경고** – 거미 출몰 지역 진입 시 화면 상단에 경고 배너 표시
*   **월드맵 히트맵** – 지역/대륙 지도에 거미 스폰 밀도 히트맵 표시 (주황→빨강 그라데이션)
*   **초상화 가리기** – 타겟/포커스 초상화의 거미 이미지도 오버레이로 가림
*   **시체 경고** – 죽은 거미에 마우스오버 시 경고 (시체는 네임플레이트가 없어 오버레이 불가)

## 감지 방식

*   **NPC ID 데이터베이스** – 클래식/TBC 거미, 실리시드(고리쉬, 센티파르 등) 129종 수록
*   **스폰 좌표 데이터베이스** – 26개 지역, 12,000+ 스폰 좌표 (Wowhead 데이터)
*   **이름 패턴 매칭** – DB에 없는 거미도 이름에 "spider", "거미" 등 키워드가 포함되면 자동 감지
*   **커스텀 등록** – `/ns add`로 원하는 NPC를 직접 추가 가능

## 슬래시 커맨드 (/ns)

| 커맨드                         |설명                          |
| ------------------------------ |---------------------------- |
| <code>/ns</code>               |애드온 활성화/비활성화 토글      |
| <code>/ns alpha 0.0~1.0</code> |오버레이 불투명도 조절           |
| <code>/ns width / height</code>|오버레이 크기 조절              |
| <code>/ns portrait</code>      |타겟/포커스 초상화 가리기 토글   |
| <code>/ns sound</code>         |경고음 토글                    |
| <code>/ns name</code>          |이름 패턴 매칭 토글             |
| <code>/ns add [ID]</code>      |타겟 또는 지정 NPC ID 추가     |
| <code>/ns remove ID</code>     |NPC ID 제거                   |
| <code>/ns check</code>         |현재 타겟이 거미인지 확인        |
| <code>/ns zone</code>          |현재 위치 거미 접근 확인         |
| <code>/ns proximity</code>     |스폰 좌표 접근 경고 토글         |
| <code>/ns mappins</code>       |월드맵 히트맵 오버레이 토글       |
| <code>/ns heatmap 1~4</code>   |히트맵 해상도 (1=낮음, 4=최고)   |
| <code>/ns debug</code>         |진단 정보 출력                  |
| <code>/ns config</code>        |설정 창 열기                    |
| <code>/ns reset</code>         |설정 초기화                     |

## 지원 환경

*   WoW 클래식 TBC 기념 서버 (Anniversary)
*   한국어/영어 클라이언트 모두 지원

## 참고

*   적 네임플레이트가 켜져 있어야 합니다 (V키). 애드온이 자동으로 활성화를 시도합니다.
*   거미 DB에 빠진 몬스터는 `/ns add`로 직접 추가하거나, 이름 패턴 매칭으로 보완됩니다.
*   거미 출몰 지역은 `/ns addregion`으로 직접 등록할 수 있습니다.
