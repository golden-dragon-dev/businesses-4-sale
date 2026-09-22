"""Businesses 4 Sale — Brand System v3 (Atelier).

Modern · elegant · sophisticated marketplace mark.
Informed by traits shared across strong logo systems:
geometric reduction, optical balance, limited palette,
type-led personality, and clarity at small sizes.
"""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(r"c:/Projects/Project_3")
OUT = ROOT / "assets" / "brand"
IMG = ROOT / "assets" / "images"
OUT.mkdir(parents=True, exist_ok=True)
IMG.mkdir(parents=True, exist_ok=True)

# Palette — warm auction-house restraint (not retail signal red/yellow)
CLARET = (107, 24, 38)  # #6B1826
CHAMPAGNE = (197, 165, 114)  # #C5A572
IVORY = (245, 240, 232)  # #F5F0E8
INK = (26, 20, 18)  # #1A1412
STONE = (222, 212, 196)  # #DED4C4
WHITE = (255, 255, 255)


def font_geo(size: int, bold: bool = True) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    """Heavy geometric faces for wordmark (client asked larger + bolder)."""
    candidates = [
        r"C:\Windows\Fonts\arialbd.ttf" if bold else r"C:\Windows\Fonts\arial.ttf",
        r"C:\Windows\Fonts\segoeuib.ttf" if bold else r"C:\Windows\Fonts\segoeui.ttf",
        r"C:\Windows\Fonts\bahnschrift.ttf",
        r"C:\Windows\Fonts\impact.ttf",
    ]
    for p in candidates:
        if Path(p).exists():
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def font_serif(size: int, italic: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        r"C:\Windows\Fonts\georgiai.ttf" if italic else r"C:\Windows\Fonts\georgia.ttf",
        r"C:\Windows\Fonts\georgiab.ttf",
    ]
    for p in candidates:
        if Path(p).exists():
            return ImageFont.truetype(p, size)
    return font_geo(size, False)


def draw_geometric_four(
    d: ImageDraw.ImageDraw,
    cx: float,
    cy: float,
    h: float,
    fill: tuple[int, int, int],
) -> None:
    """Closed open-counter '4' — must read as a numeral at 24px and up.

    Construction (classic display 4):
      • filled left triangle into the stem (closed apex)
      • full-height stem on the right
      • crossbar through the junction, longer to the left
    """
    stroke = h * 0.118
    top = cy - h * 0.50
    bottom = cy + h * 0.50
    stem_x = cx + h * 0.10
    cross_y = cy + h * 0.08
    left = cx - h * 0.40
    # Crossbar overshoot past stem (optical, short)
    right = stem_x + h * 0.26

    # Left triangle of the 4 (apex at top of stem, base along crossbar)
    triangle = [
        (stem_x - stroke * 0.48, top + h * 0.02),
        (left, cross_y + stroke * 0.48),
        (stem_x - stroke * 0.48, cross_y + stroke * 0.48),
    ]
    d.polygon(triangle, fill=fill)

    # Crossbar
    d.rounded_rectangle(
        [left, cross_y - stroke * 0.48, right, cross_y + stroke * 0.48],
        radius=stroke * 0.08,
        fill=fill,
    )

    # Stem — extends above apex for the open-top look of a modern 4
    d.rounded_rectangle(
        [stem_x - stroke * 0.48, top, stem_x + stroke * 0.48, bottom],
        radius=stroke * 0.08,
        fill=fill,
    )


def draw_seal(img: Image.Image, S: int, *, mono: bool = False) -> None:
    """Double-ring atelier seal with geometric 4."""
    d = ImageDraw.Draw(img)
    pad = int(S * 0.03)
    box = [pad, pad, S - pad, S - pad]
    cx = cy = S / 2

    field = IVORY if not mono else WHITE
    ring = CLARET if not mono else INK
    accent = CHAMPAGNE if not mono else INK
    four = CLARET if not mono else INK

    # Outer field disc
    d.ellipse(box, fill=field + (255,))

    # Outer champagne / ink ring (luxury weight)
    outer_w = max(3, int(S * 0.028))
    d.ellipse(box, outline=accent + (255,), width=outer_w)

    # Inner hairline ring
    inset = int(S * 0.055)
    inner = [pad + inset, pad + inset, S - pad - inset, S - pad - inset]
    d.ellipse(inner, outline=ring + (255,), width=max(2, int(S * 0.012)))

    # Soft inner breathing ring
    inset2 = int(S * 0.085)
    breath = [pad + inset2, pad + inset2, S - pad - inset2, S - pad - inset2]
    d.ellipse(breath, outline=STONE + (180,) if not mono else (200, 200, 200, 120), width=max(1, S // 220))

    draw_geometric_four(d, cx, cy - S * 0.01, S * 0.42, four)

    # Alpha mask to circle
    alpha = Image.new("L", (S, S), 0)
    ImageDraw.Draw(alpha).ellipse(box, fill=255)
    img.putalpha(alpha)


def spaced_wordmark(text: str, tracking_em: float = 0.22) -> str:
    """Insert thin spaces for luxury tracking when native tracking is unavailable."""
    gap = "\u2009"  # thin space
    # Extra gap for mid-dot already in text
    return gap.join(list(text.replace(" ", "")))


def fit_text(
    d: ImageDraw.ImageDraw,
    text: str,
    target_w: float,
    start_fs: int,
    *,
    bold: bool = True,
    serif: bool = False,
    italic: bool = False,
) -> tuple[ImageFont.ImageFont, tuple[int, int, int, int]]:
    fs = start_fs
    for _ in range(40):
        f = font_serif(fs, italic) if serif else font_geo(fs, bold)
        bbox = d.textbbox((0, 0), text, font=f)
        tw = bbox[2] - bbox[0]
        if abs(tw - target_w) < target_w * 0.02:
            return f, bbox
        fs = max(8, int(fs * (target_w / max(tw, 1))))
    f = font_serif(fs, italic) if serif else font_geo(fs, bold)
    return f, d.textbbox((0, 0), text, font=f)


def make_badge(size: int = 1024, mono: bool = False) -> Image.Image:
    scale = 3
    big = size * scale
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    draw_seal(img, big, mono=mono)
    return img.resize((size, size), Image.Resampling.LANCZOS)


def text_metrics(bbox: tuple[int, int, int, int]) -> tuple[int, int]:
    """Return (width, height) from a PIL textbbox."""
    return bbox[2] - bbox[0], bbox[3] - bbox[1]


def draw_text_top(
    d: ImageDraw.ImageDraw,
    xy_top_left: tuple[float, float],
    text: str,
    font: ImageFont.ImageFont,
    fill: tuple[int, int, int, int],
    bbox: tuple[int, int, int, int],
) -> float:
    """Draw text so its visual top is at xy_top_left[1]. Returns visual bottom y."""
    x, top = xy_top_left
    d.text((x - bbox[0], top - bbox[1]), text, font=font, fill=fill)
    return top + (bbox[3] - bbox[1])


def make_logo_vertical(size: int = 1024, *, on_ivory: bool = True) -> Image.Image:
    """Seal + bold BUS · SALE + full name — clear vertical gaps, no overlap."""
    scale = 3
    W = int(size * 1.12 * scale)
    H = int(size * 1.95 * scale)
    bg = IVORY + (255,) if on_ivory else (0, 0, 0, 0)
    img = Image.new("RGBA", (W, H), bg)
    d = ImageDraw.Draw(img)

    seal_s = int(size * 0.52 * scale)
    seal = make_badge(seal_s)
    sx = (W - seal_s) // 2
    sy = int(H * 0.03)
    img.alpha_composite(seal, (sx, sy))

    gap_seal = int(H * 0.04)
    gap_rule = int(H * 0.024)
    gap_sub = int(H * 0.03)
    rule_h = max(3, H // 280)

    mark = "BUS · SALE"
    f, bbox = fit_text(d, mark, W * 0.96, int(size * 0.175 * scale), bold=True)
    tw, _ = text_metrics(bbox)
    mark_top = sy + seal_s + gap_seal
    mark_bottom = draw_text_top(
        d, ((W - tw) / 2, mark_top), mark, f, INK + (255,), bbox
    )

    rule_y = mark_bottom + gap_rule
    rw = W * 0.20
    d.rectangle(
        [(W - rw) / 2, rule_y, (W + rw) / 2, rule_y + rule_h],
        fill=CHAMPAGNE + (255,),
    )

    sub = "BUSINESSES FOR SALE"
    f2, b2 = fit_text(
        d, sub, W * 0.78, int(size * 0.055 * scale), bold=True, serif=False, italic=False
    )
    tw2, _ = text_metrics(b2)
    sub_top = rule_y + rule_h + gap_sub
    draw_text_top(d, ((W - tw2) / 2, sub_top), sub, f2, CLARET + (255,), b2)

    return img.resize((int(size * 1.12), int(size * 1.85)), Image.Resampling.LANCZOS)


def make_logo_horizontal(size: int = 1024, *, on_ivory: bool = True) -> Image.Image:
    """Seal left + wordmark right — clear gap between title and subtitle."""
    scale = 3
    H = size * scale
    W = int(size * 2.7 * scale)
    bg = IVORY + (255,) if on_ivory else (0, 0, 0, 0)
    img = Image.new("RGBA", (W, H), bg)
    d = ImageDraw.Draw(img)

    seal_s = int(H * 0.82)
    seal = make_badge(seal_s)
    sy = (H - seal_s) // 2
    sx = int(H * 0.05)
    img.alpha_composite(seal, (sx, sy))

    left = sx + seal_s + H * 0.08
    target = W - left - H * 0.06
    mark = "BUS · SALE"
    f, bbox = fit_text(d, mark, target * 0.95, int(H * 0.26), bold=True)
    tw, th = text_metrics(bbox)

    sub = "BUSINESSES FOR SALE"
    f2, b2 = fit_text(d, sub, target * 0.88, int(H * 0.095), bold=True, serif=False)
    tw2, th2 = text_metrics(b2)

    gap = int(H * 0.09)
    block_h = th + gap + th2
    block_top = (H - block_h) / 2

    draw_text_top(d, (left, block_top), mark, f, INK + (255,), bbox)
    draw_text_top(
        d, (left, block_top + th + gap), sub, f2, CLARET + (255,), b2
    )

    return img.resize((int(size * 2.7), size), Image.Resampling.LANCZOS)


def make_app_icon(size: int = 1024) -> Image.Image:
    """Fully opaque ivory app icon with centered seal (store-safe)."""
    scale = 3
    S = size * scale
    img = Image.new("RGBA", (S, S), IVORY + (255,))
    seal_s = int(S * 0.72)
    seal = make_badge(seal_s)
    ox = (S - seal_s) // 2
    oy = (S - seal_s) // 2
    img.alpha_composite(seal, (ox, oy))
    return img.resize((size, size), Image.Resampling.LANCZOS)


def make_wordmark_only(width: int = 1200) -> Image.Image:
    H = int(width * 0.28)
    img = Image.new("RGBA", (width, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    mark = "BUS · SALE"
    f, bbox = fit_text(d, mark, width * 0.9, int(H * 0.45), bold=True)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    d.text(((width - tw) / 2 - bbox[0], (H - th) / 2 - bbox[1]), mark, font=f, fill=INK + (255,))
    return img


def make_preview_board() -> Image.Image:
    """Side-by-side study board for review."""
    W, H = 1400, 900
    img = Image.new("RGBA", (W, H), IVORY + (255,))
    d = ImageDraw.Draw(img)

    title_f = font_geo(36, True)
    d.text((48, 36), "BUSINESSES 4 SALE  ·  Brand Atelier v3", font=title_f, fill=INK)

    sub_f = font_serif(20, True)
    d.text(
        (48, 88),
        "Modern · elegant · sophisticated  —  geometric seal, champagne & claret, type-led lockups",
        font=sub_f,
        fill=CLARET,
    )

    # Colour chips
    chips = [
        ("Claret", CLARET),
        ("Champagne", CHAMPAGNE),
        ("Ivory", IVORY),
        ("Ink", INK),
        ("Stone", STONE),
    ]
    x = 48
    for name, col in chips:
        d.rounded_rectangle([x, 140, x + 72, 212], radius=8, fill=col + (255,))
        d.rounded_rectangle([x, 140, x + 72, 212], radius=8, outline=STONE + (255,), width=1)
        nf = font_geo(14, False)
        d.text((x, 220), name, font=nf, fill=INK)
        x += 100

    badge = make_badge(280)
    logo = make_logo_vertical(220)
    horiz = make_logo_horizontal(160)
    icon = make_app_icon(200)
    mono = make_badge(200, mono=True)

    img.alpha_composite(badge, (80, 280))
    img.alpha_composite(logo, (420, 260))
    img.alpha_composite(horiz, (80, 620))
    img.alpha_composite(icon, (1100, 300))
    img.alpha_composite(mono, (1120, 560))

    lf = font_geo(14, False)
    d.text((80, 570), "Primary seal", font=lf, fill=CLARET)
    d.text((420, 600), "Vertical lockup", font=lf, fill=CLARET)
    d.text((80, 800), "Horizontal lockup", font=lf, fill=CLARET)
    d.text((1100, 510), "App icon", font=lf, fill=CLARET)
    d.text((1120, 770), "Mono seal", font=lf, fill=CLARET)

    return img


def write_svgs() -> None:
    badge_svg = """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" fill="none">
  <circle cx="120" cy="120" r="112" fill="#F5F0E8"/>
  <circle cx="120" cy="120" r="112" stroke="#C5A572" stroke-width="7"/>
  <circle cx="120" cy="120" r="98" stroke="#6B1826" stroke-width="3.2"/>
  <circle cx="120" cy="120" r="90" stroke="#DED4C4" stroke-width="1.2" opacity="0.7"/>
  <!-- Closed-counter geometric 4 -->
  <path d="M126 48 L52 138 L126 138 Z" fill="#6B1826"/>
  <rect x="52" y="126" width="128" height="20" rx="2" fill="#6B1826"/>
  <rect x="126" y="48" width="20" height="144" rx="2" fill="#6B1826"/>
</svg>
"""
    logo_svg = """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 420 560" fill="none">
  <rect width="420" height="560" fill="#F5F0E8"/>
  <g transform="translate(90,40)">
    <circle cx="120" cy="120" r="112" fill="#F5F0E8"/>
    <circle cx="120" cy="120" r="112" stroke="#C5A572" stroke-width="7"/>
    <circle cx="120" cy="120" r="98" stroke="#6B1826" stroke-width="3.2"/>
    <path d="M126 48 L52 138 L126 138 Z" fill="#6B1826"/>
    <rect x="52" y="126" width="128" height="20" rx="2" fill="#6B1826"/>
    <rect x="126" y="48" width="20" height="144" rx="2" fill="#6B1826"/>
  </g>
  <text x="210" y="340" text-anchor="middle"
        font-family="Arial Black, Arial, sans-serif"
        font-size="48" font-weight="800" letter-spacing="4" fill="#1A1412">BUS · SALE</text>
  <line x1="160" y1="360" x2="260" y2="360" stroke="#C5A572" stroke-width="3"/>
  <text x="210" y="400" text-anchor="middle"
        font-family="Arial, Helvetica, sans-serif"
        font-size="18" font-weight="700" letter-spacing="2" fill="#6B1826">BUSINESSES FOR SALE</text>
</svg>
"""
    (OUT / "bus_sale_v3_badge.svg").write_text(badge_svg, encoding="utf-8")
    (OUT / "bus_sale_v3_logo.svg").write_text(logo_svg, encoding="utf-8")


def main() -> None:
    write_svgs()

    badge = make_badge(1024)
    badge.save(OUT / "bus_sale_v3_badge_1024.png")
    badge.save(IMG / "bus_sale_badge.png")

    mono = make_badge(1024, mono=True)
    mono.save(OUT / "bus_sale_v3_badge_mono_1024.png")

    vertical = make_logo_vertical(1024, on_ivory=True)
    vertical.save(OUT / "bus_sale_v3_logo_splash.png")
    # App asset: transparent so it sits on theme ivory without a hard rectangle
    make_logo_vertical(1024, on_ivory=False).save(IMG / "bus_sale_logo.png")

    horiz = make_logo_horizontal(512, on_ivory=True)
    horiz.save(OUT / "bus_sale_v3_logo_horizontal.png")

    icon = make_app_icon(1024)
    icon.save(OUT / "bus_sale_v3_icon_1024.png")
    white_bg = Image.new("RGBA", (1024, 1024), WHITE + (255,))
    white_bg.alpha_composite(icon)
    white_bg.convert("RGB").save(OUT / "bus_sale_v3_icon_1024_white_bg.png")

    # Also refresh legacy-named store files
    badge.save(OUT / "bus_sale_icon_1024.png")
    white_bg.convert("RGB").save(OUT / "bus_sale_icon_1024_white_bg.png")
    vertical.save(OUT / "bus_sale_logo_splash.png")

    word = make_wordmark_only()
    word.save(OUT / "bus_sale_v3_wordmark.png")

    board = make_preview_board()
    board.save(OUT / "bus_sale_v3_board.png")
    board.resize((700, 450), Image.Resampling.LANCZOS).save(OUT / "bus_sale_v3_board_preview.png")

    make_badge(256).save(OUT / "bus_sale_v3_preview_256.png")

    print("v3 brand system written to", OUT)
    print("App assets updated in", IMG)


if __name__ == "__main__":
    main()
