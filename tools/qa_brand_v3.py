"""QA checks for Brand Atelier v3 — run before external review (e.g. Codex)."""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

ROOT = Path(r"c:/Projects/Project_3")
BRAND = ROOT / "assets" / "brand"
IMG = ROOT / "assets" / "images"

CLARET = (107, 24, 38)
IVORY = (245, 240, 232)

REQUIRED = [
    BRAND / "bus_sale_v3_badge_1024.png",
    BRAND / "bus_sale_v3_badge_mono_1024.png",
    BRAND / "bus_sale_v3_logo_splash.png",
    BRAND / "bus_sale_v3_logo_horizontal.png",
    BRAND / "bus_sale_v3_icon_1024.png",
    BRAND / "bus_sale_v3_badge.svg",
    BRAND / "bus_sale_v3_logo.svg",
    IMG / "bus_sale_badge.png",
    IMG / "bus_sale_logo.png",
]


def approx(a: tuple[int, ...], b: tuple[int, ...], tol: int = 18) -> bool:
    return all(abs(x - y) <= tol for x, y in zip(a[:3], b[:3]))


def contrast_ratio(c1: tuple[int, int, int], c2: tuple[int, int, int]) -> float:
    def lin(c: int) -> float:
        x = c / 255.0
        return x / 12.92 if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4

    def L(rgb: tuple[int, int, int]) -> float:
        r, g, b = (lin(v) for v in rgb)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b

    l1, l2 = L(c1), L(c2)
    hi, lo = max(l1, l2), min(l1, l2)
    return (hi + 0.05) / (lo + 0.05)


def check_seal(path: Path, expect_size: int | None = None) -> list[str]:
    errors: list[str] = []
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    if expect_size and (w != expect_size or h != expect_size):
        errors.append(f"{path.name}: expected {expect_size}x{expect_size}, got {w}x{h}")
    if w != h:
        errors.append(f"{path.name}: seal should be square, got {w}x{h}")

    # Corners should be transparent (circular mask)
    for xy in [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)]:
        if im.getpixel(xy)[3] > 10:
            errors.append(f"{path.name}: corner {xy} not transparent")
            break

    # Center should be claret (the 4) OR very near — sample a band of the stem
    cx, cy = w // 2, h // 2
    # Stem sits slightly right of center in our construction
    stem = im.getpixel((int(cx + w * 0.05), cy))
    if stem[3] < 200 or not approx(stem, CLARET, 30):
        errors.append(f"{path.name}: stem pixel not claret (got {stem})")

    # Field (upper left of center, inside seal) should be ivory
    field = im.getpixel((int(cx - w * 0.18), int(cy - h * 0.18)))
    if field[3] < 200 or not approx(field, IVORY, 25):
        errors.append(f"{path.name}: field not ivory (got {field})")

    # Contrast claret on ivory
    cr = contrast_ratio(CLARET, IVORY)
    if cr < 4.5:
        errors.append(f"{path.name}: claret/ivory contrast {cr:.2f} < 4.5")

    # Small-size sanity: 24px resize still has opaque center
    tiny = im.resize((24, 24), Image.Resampling.LANCZOS)
    if tiny.getpixel((12, 12))[3] < 180:
        errors.append(f"{path.name}: center empty at 24px")

    # Shape cue for "4": more ink on right half of glyph box than far-left open counter
    # Sample rows around mid-crossbar
    y = int(cy + h * 0.04)
    left_band = sum(1 for x in range(int(cx - w * 0.22), int(cx - w * 0.10)) if im.getpixel((x, y))[3] > 200 and approx(im.getpixel((x, y)), CLARET, 40))
    right_band = sum(1 for x in range(int(cx + w * 0.02), int(cx + w * 0.14)) if im.getpixel((x, y))[3] > 200 and approx(im.getpixel((x, y)), CLARET, 40))
    if right_band < left_band * 0.5:
        errors.append(f"{path.name}: glyph mass not stem-heavy (may not read as 4)")

    return errors


def check_lockup(path: Path) -> list[str]:
    errors: list[str] = []
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    if w < 200 or h < 200:
        errors.append(f"{path.name}: unexpectedly small {w}x{h}")
    opaque = 0
    darkish = 0
    # Sample a coarse grid (avoids deprecated getdata)
    step = max(1, min(w, h) // 64)
    for y in range(0, h, step):
        for x in range(0, w, step):
            p = im.getpixel((x, y))
            if p[3] > 200:
                opaque += 1
                if p[0] < 90 and p[1] < 70:
                    darkish += 1
    total = ((h - 1) // step + 1) * ((w - 1) // step + 1)
    if opaque / max(total, 1) < 0.35:
        errors.append(f"{path.name}: too much transparency for wordmark lockup")
    if darkish < 3:
        errors.append(f"{path.name}: could not find dark wordmark pixels")
    return errors


def main() -> int:
    errors: list[str] = []
    for p in REQUIRED:
        if not p.exists():
            errors.append(f"missing: {p}")

    if errors:
        print("FAIL")
        for e in errors:
            print(" -", e)
        return 1

    errors += check_seal(BRAND / "bus_sale_v3_badge_1024.png", 1024)
    errors += check_seal(IMG / "bus_sale_badge.png")
    errors += check_lockup(BRAND / "bus_sale_v3_logo_splash.png")
    errors += check_lockup(BRAND / "bus_sale_v3_logo_horizontal.png")
    # App logo may be transparent; only require file + reasonable size
    app_logo = Image.open(IMG / "bus_sale_logo.png")
    if min(app_logo.size) < 200:
        errors.append("app bus_sale_logo.png too small")

    # App icon should be fully opaque (store)
    icon = Image.open(BRAND / "bus_sale_v3_icon_1024.png").convert("RGBA")
    if icon.size != (1024, 1024):
        errors.append(f"icon size {icon.size}")
    if icon.getpixel((10, 10))[3] < 250:
        errors.append("app icon corner should be opaque ivory")

    # SVG must mention claret + champagne + geometric 4 path
    svg = (BRAND / "bus_sale_v3_badge.svg").read_text(encoding="utf-8")
    for token in ("#6B1826", "#C5A572", "#F5F0E8", "<path"):
        if token not in svg:
            errors.append(f"badge SVG missing {token}")

    if errors:
        print("FAIL")
        for e in errors:
            print(" -", e)
        return 1

    print("PASS")
    print(f" contrast claret/ivory: {contrast_ratio(CLARET, IVORY):.2f}")
    print(" files:", len(REQUIRED))
    return 0


if __name__ == "__main__":
    sys.exit(main())
