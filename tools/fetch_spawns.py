"""
Wowhead에서 거미 NPC 스폰 좌표를 수집하여 SpiderSpawnData.lua를 생성합니다.
사용법: python tools/fetch_spawns.py
"""
import re, json, urllib.request, time, sys, os

# NPC ID -> zone label (for comments only)
NPCS_CLASSIC = [
    # Teldrassil
    1986, 1998, 1999, 2001, 2000, 1994, 7319,
    # Elwynn Forest
    30, 43, 471,
    # Tirisfal Glades
    1688, 1504, 1505, 1555, 10359,
    # Silverpine Forest
    1780, 1781, 12433,
    # Western Plaguelands
    1821, 1822, 1824,
    # Eastern Plaguelands
    8555, 8556, 8557, 8558,
    # Razorfen Downs
    7349, 7351,
    # Loch Modan
    1184, 1185, 1195, 14266,
    # Wetlands
    1111, 1112, 4040,
    # Redridge Mountains
    442, 505, 616,
    # Duskwood
    217, 539, 569, 574, 930, 949,
    # Hillsbrad Foothills
    2348, 2349, 2350, 14279,
    # The Hinterlands
    2686,
    # Stonetalon Mountains
    4005, 4006, 4007, 4263, 4264, 11921,
    # Arathi Highlands
    2563, 2565,
    # Dustwallow Marsh
    4376, 4377, 4378, 4379, 4380, 4411, 4412, 4413, 4414, 4415,
    # Tanaris
    5455, 5456, 5457, 5458, 5459, 5460,
    # Un'Goro Crater
    6551, 6552, 6553, 6554, 6555, 9496, 9498, 10040, 10041,
    # Searing Gorge / Burning Steppes
    5856, 5857, 5858, 8277, 9699,
    # Blackrock Depths
    8932,
    # Dire Maul
    13160,
    # Azshara
    8762,
    # Silithus
    11738, 11739, 14472,
    # Swamp of Sorrows
    769, 858,
    # Ashenvale
    3819, 3820, 3821,
]

NPCS_TBC = [
    # Terokkar Forest
    18466, 18467, 18647,
    # Bloodmyst Isle
    17522, 17523, 17683,
    # Blade's Edge Mountains
    20714, 20998, 22044, 22132,
    # The Hinterlands
    17236,
    # Ghostlands
    16350, 16351, 16352,
    # Cave Beetle (no known location)
    22047,
    # The Shattered Halls (Fire Beetle)
    # 9699 is already in NPCS_CLASSIC
    # Outland misc (outdoor)
    18983, 20027,
    # Stratholme
    10412, 10413,
    # Scholomance
    11551,
    # AQ (Beetle)
    15475,
    # Naxxramas
    15978, 16573, 16698,
    # Hyjal Summit
    17897,
]

# Wowhead zoneId → 지역명 (g_mapperData 최상위 키 기준)
ZONE_NAMES_BY_ZONEID = {
    8:    "Swamp of Sorrows",
    10:   "Duskwood",
    11:   "Wetlands",
    12:   "Elwynn Forest",
    15:   "Dustwallow Marsh",
    16:   "Azshara",
    28:   "Western Plaguelands",
    139:  "Eastern Plaguelands",
    36:   "Alterac Mountains",
    38:   "Loch Modan",
    44:   "Redridge Mountains",
    45:   "Arathi Highlands",
    46:   "Burning Steppes",
    47:   "The Hinterlands",
    51:   "Searing Gorge",
    85:   "Tirisfal Glades",
    130:  "Silverpine Forest",
    141:  "Teldrassil",
    267:  "Hillsbrad Foothills",
    331:  "Ashenvale",
    406:  "Stonetalon Mountains",
    440:  "Tanaris",
    490:  "Un'Goro Crater",
    1377: "Silithus",
    3519: "Terokkar Forest",
    3522: "Blade's Edge Mountains",
    3433: "Ghostlands",
    3525: "Bloodmyst Isle",
}

g_mapper_re = re.compile(r'var g_mapperData\s*=\s*(\{.+?\})\s*;', re.DOTALL)

def fetch_npc(npc_id, base="classic"):
    url = f"https://www.wowhead.com/{base}/ko/npc={npc_id}"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=15) as resp:
            html = resp.read().decode("utf-8", errors="replace")
    except Exception as e:
        print(f"  [SKIP] NPC {npc_id}: {e}", file=sys.stderr)
        return []

    m = g_mapper_re.search(html)
    if not m:
        print(f"  [SKIP] NPC {npc_id}: no g_mapperData", file=sys.stderr)
        return []

    try:
        data = json.loads(m.group(1))
    except json.JSONDecodeError:
        print(f"  [SKIP] NPC {npc_id}: JSON parse error", file=sys.stderr)
        return []

    # 각 엔트리를 (zoneId, uiMapId, coords) 튜플로 반환
    results = []
    for zone_key, entries in data.items():
        zone_id = int(zone_key)
        for entry in entries:
            uid = entry.get("uiMapId")
            coords = entry.get("coords", [])
            if uid and coords:
                results.append((zone_id, uid, coords))
    return results


def main():
    # zoneId 기준 데이터 수집
    # zone_data[zoneId] = { uiMapId: int, coords: [[x,y],...], npcs: set }
    zone_data = {}

    total = len(NPCS_CLASSIC) + len(NPCS_TBC)
    idx = 0

    for npc_id in NPCS_CLASSIC + NPCS_TBC:
        idx += 1
        print(f"[{idx}/{total}] Fetching NPC {npc_id} (tbc)...", file=sys.stderr)
        entries = fetch_npc(npc_id, "tbc")
        for zone_id, ui_map_id, coords in entries:
            if zone_id not in zone_data:
                zone_data[zone_id] = {
                    "uiMapId": ui_map_id,
                    "coords": [],
                    "npcs": set(),
                }
            zone_data[zone_id]["coords"].extend(coords)
            zone_data[zone_id]["npcs"].add(npc_id)
        time.sleep(0.3)

    # Generate Lua
    out = []
    out.append("-- SpiderSpawnData.lua")
    out.append("-- 거미 NPC 출몰 좌표 데이터 (Wowhead g_mapperData 기반)")
    out.append("-- 좌표 스케일: 0~100 (Wowhead 원본), 렌더링 시 /100으로 정규화")
    out.append("-- 자동 생성: python tools/fetch_spawns.py")
    out.append("")
    out.append("local _, NS = ...")
    out.append("")
    out.append("NS.SpiderSpawnData = {")

    for zone_id in sorted(zone_data.keys()):
        info = zone_data[zone_id]
        ui_map_id = info["uiMapId"]
        coords = info["coords"]

        # Deduplicate
        seen = set()
        unique = []
        for c in coords:
            key = (round(c[0], 1), round(c[1], 1))
            if key not in seen:
                seen.add(key)
                unique.append(key)
        unique.sort()

        zone_name = ZONE_NAMES_BY_ZONEID.get(zone_id, f"Unknown (zoneId: {zone_id})")
        npcs = sorted(info["npcs"])
        npc_str = ", ".join(str(n) for n in npcs)

        out.append("")
        out.append(f"    -- {zone_name} (zoneId: {zone_id}, uiMapId: {ui_map_id})")
        out.append(f"    -- NPC: {npc_str}")
        out.append(f"    [{ui_map_id}] = {{")

        line = "        "
        count = 0
        for x, y in unique:
            entry = "{%.1f,%.1f}," % (x, y)
            if count > 0 and count % 6 == 0:
                out.append(line)
                line = "        "
            line += entry
            count += 1
        if line.strip():
            out.append(line)

        out.append("    },")

    out.append("}")
    out.append("")

    outpath = os.path.join(os.path.dirname(os.path.dirname(__file__)),
                           "SpiderSpawnData.lua")
    with open(outpath, "w", encoding="utf-8") as f:
        f.write("\n".join(out))

    total_coords = sum(len(z["coords"]) for z in zone_data.values())
    print(f"\nDone! {len(zone_data)} zones, {total_coords} total coords -> {outpath}", file=sys.stderr)


if __name__ == "__main__":
    main()
