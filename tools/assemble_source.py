from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PARTS_DIR = ROOT / "source_parts"
OUTPUT = ROOT / "image_paste_v2_3_6.pyw"

parts = sorted(PARTS_DIR.glob("part*.txt"))
if not parts:
    raise SystemExit("No source_parts/part*.txt files found")

expected = [f"part{i:02d}.txt" for i in range(1, 14)]
actual = [p.name for p in parts]
if actual != expected:
    raise SystemExit(
        "Source parts are incomplete or out of order.\n"
        f"Expected: {expected}\nActual: {actual}"
    )

content = "".join(p.read_text(encoding="utf-8") for p in parts)
compile(content, str(OUTPUT), "exec")
OUTPUT.write_text(content, encoding="utf-8")
print(f"Assembled {len(parts)} source parts -> {OUTPUT}")
