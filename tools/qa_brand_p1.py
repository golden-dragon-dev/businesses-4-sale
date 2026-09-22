"""QA for Pack p1 BUS.SALE logo — Codex / review gate."""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

ROOT = Path(r"c:/Projects/Project_3")
BRAND = ROOT / "assets" / "brand"
IMG = ROOT / "assets" / "images"

RED = (227, 6, 19)
YELLOW = (255, 210, 0)

REQUIRED = [
    IMG / "bus_sale_badge.png",
    IMG / "bus_sale_logo.png",
    BRAND / "bus_sale_p1_badge_1024.png",
    BRAND / "bus_sale_p1_logo_splash.png",
    BRAND / "bus_sale_badge.svg",
    BRAND / "bus_sale_logo.svg",
]


def approx(a: tuple[int, ...], b: tuple[int, ...], tol: int = 28) -> bool:
    return all(abs(x - y) <= tol for x, y in zip(a[:3], b[:3]))


def check_badge(path: Path) -> list[str]:
    errors: list[str] = []
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    if w != h:
        errors.append(f"{path.name}: not square {w}x{h}")
    for xy in [(0, 0), (w - 1, 0), (0, h - 1)]:
        if im.getpixel(xy)[3] > 15:
            errors.append(f"{path.name}: corner not transparent {xy}")
            break

    top = im.getpixel((w // 2, int(h * 0.18)))
    if top[3] < 200 or not approx(top, RED, 40):
        errors.append(f"{path.name}: top not Pack red (got {top})")

    bot = im.getpixel((w // 2, int(h * 0.82)))
    if bot[3] < 200 or not approx(bot, YELLOW, 45):
        errors.append(f"{path.name}: bottom not Pack yellow (got {bot})")

    # Centre band must be white field or black letter (not red/yellow)
    mid = im.getpixel((w // 2, h // 2))
    if mid[3] < 200 or approx(mid, RED, 40) or approx(mid, YELLOW, 40):
        errors.append(f"{path.name}: centre band still red/yellow (got {mid})")

    ink_hits = 0
    y = h // 2
    for x in range(int(w * 0.25), int(w * 0.75), max(1, w // 40)):
        p = im.getpixel((x, y))
        if p[3] > 200 and p[0] < 60 and p[1] < 60 and p[2] < 60:
            ink_hits += 1
    if ink_hits < 3:
        errors.append(f"{path.name}: BUS.SALE letters not detected in band")

    tiny = im.resize((32, 32), Image.Resampling.LANCZOS)
    if tiny.getpixel((16, 6))[3] < 150:
        errors.append(f"{path.name}: empty at 32px")
    return errors


def main() -> int:
    errors: list[str] = []
    for p in REQUIRED:
        if not p.exists():
            errors.append(f"missing {p}")
    if errors:
        print("FAIL")
        for e in errors:
            print(" -", e)
        return 1

    errors += check_badge(IMG / "bus_sale_badge.png")
    errors += check_badge(BRAND / "bus_sale_p1_badge_1024.png")

    svg = (BRAND / "bus_sale_badge.svg").read_text(encoding="utf-8")
    for token in ("#E30613", "#FFD200", "BUS.SALE"):
        if token not in svg:
            errors.append(f"SVG missing {token}")

    splash = Image.open(BRAND / "bus_sale_p1_logo_splash.png").convert("RGBA")
    if splash.size[1] < splash.size[0] * 0.9:
        errors.append("splash lockup should be taller than wide")

    if errors:
        print("FAIL")
        for e in errors:
            print(" -", e)
        return 1

    print("PASS")
    print(" Pack p1 mark: red/yellow circle, white band, bold BUS.SALE")
    return 0


if __name__ == "__main__":
    sys.exit(main())
