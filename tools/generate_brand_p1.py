"""Businesses 4 Sale — Pack p1 logo system (client-approved mark).

Faithful to Developer Pack page 1:
  red top / yellow bottom circle, white centre band, BUS.SALE, black rim,
  BUSINESSES 4 SALE underlock.

Refined with circular-badge best practices: construction grid proportions,
optical type centering, max letter fill for bold readability at small sizes,
high-contrast palette, flat vector-clean edges (no shadow / glow).
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(r"c:/Projects/Project_3")
OUT = ROOT / "assets" / "brand"
IMG = ROOT / "assets" / "images"
WEB = ROOT / "web"
OUT.mkdir(parents=True, exist_ok=True)
IMG.mkdir(parents=True, exist_ok=True)

# Pack p1 palette (Developer Pack / client mark)
RED = (227, 6, 19)  # #E30613
YELLOW = (255, 210, 0)  # #FFD200
INK = (17, 17, 17)  # #111111
WHITE = (255, 255, 255)
CREAM = (255, 255, 255)


def font_heavy(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    for p in (
        r"C:\Windows\Fonts\arialbd.ttf",
        r"C:\Windows\Fonts\segoeuib.ttf",
        r"C:\Windows\Fonts\arial.ttf",
    ):
        if Path(p).exists():
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def fit_text(
    d: ImageDraw.ImageDraw,
    text: str,
    target_w: float,
    start_fs: int,
) -> tuple[ImageFont.ImageFont, tuple[int, int, int, int]]:
    fs = start_fs
    for _ in range(48):
        f = font_heavy(max(8, fs))
        bbox = d.textbbox((0, 0), text, font=f)
        tw = bbox[2] - bbox[0]
        if abs(tw - target_w) < max(2, target_w * 0.015):
            return f, bbox
        fs = int(fs * (target_w / max(tw, 1)))
    f = font_heavy(max(8, fs))
    return f, d.textbbox((0, 0), text, font=f)


def draw_p1_badge(img: Image.Image, S: int, *, mono: bool = False) -> None:
    """Pack p1 circle: red / yellow split, full white band, bold BUS.SALE."""
    d = ImageDraw.Draw(img)
    # Construction pad ~4% clearspace inside square
    pad = int(S * 0.035)
    box = [pad, pad, S - pad, S - pad]
    cx = cy = S / 2
    diam = S - 2 * pad

    red = INK if mono else RED
    yellow = (180, 180, 180) if mono else YELLOW
    band_fill = WHITE
    text_fill = INK

    d.ellipse(box, fill=red + (255,))
    d.pieslice(box, 0, 180, fill=yellow + (255,))

    # Full-width rectangular band (Pack p1), ~32% of diameter for larger type
    band_h = diam * 0.32
    band_w = diam * 0.98
    rx = cx - band_w / 2
    ry = cy - band_h / 2
    d.rectangle([rx, ry, rx + band_w, ry + band_h], fill=band_fill + (255,))

    # BUS.SALE — fill ~94% of band width (client: larger + bolder)
    text = "BUS.SALE"
    target = band_w * 0.94
    f, bbox = fit_text(d, text, target, int(S * 0.16))
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    # Optical lift: heavy caps sit slightly high if mathematically centred
    d.text(
        (cx - tw / 2 - bbox[0], cy - th / 2 - bbox[1] - S * 0.012),
        text,
        font=f,
        fill=text_fill + (255,),
    )

    # Black rim (Pack outline)
    rim_w = max(2, int(S * 0.018))
    alpha = Image.new("L", (S, S), 0)
    ImageDraw.Draw(alpha).ellipse(box, fill=255)
    rim = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    ImageDraw.Draw(rim).ellipse(box, outline=INK + (255,), width=rim_w)
    img.putalpha(alpha)
    img.alpha_composite(rim)


def make_badge(size: int = 1024, *, mono: bool = False) -> Image.Image:
    scale = 3
    big = size * scale
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    draw_p1_badge(img, big, mono=mono)
    return img.resize((size, size), Image.Resampling.LANCZOS)


def make_logo_vertical(size: int = 1024, *, on_white: bool = True) -> Image.Image:
    """Badge + BUSINESSES 4 SALE (Pack p1 lockup)."""
    scale = 3
    W = int(size * 1.05 * scale)
    H = int(size * 1.38 * scale)
    bg = WHITE + (255,) if on_white else (0, 0, 0, 0)
    img = Image.new("RGBA", (W, H), bg)
    d = ImageDraw.Draw(img)

    seal_s = int(size * 0.82 * scale)
    seal = make_badge(seal_s)
    sx = (W - seal_s) // 2
    sy = int(H * 0.04)
    img.alpha_composite(seal, (sx, sy))

    sub = "BUSINESSES 4 SALE"
    target = W * 0.78
    f, bbox = fit_text(d, sub, target, int(size * 0.072 * scale))
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    d.text(
        ((W - tw) / 2 - bbox[0], sy + seal_s + H * 0.045 - bbox[1]),
        sub,
        font=f,
        fill=INK + (255,),
    )
    return img.resize((int(size * 1.05), int(size * 1.38)), Image.Resampling.LANCZOS)


def make_logo_horizontal(size: int = 512, *, on_white: bool = True) -> Image.Image:
    scale = 3
    H = size * scale
    W = int(size * 2.4 * scale)
    bg = WHITE + (255,) if on_white else (0, 0, 0, 0)
    img = Image.new("RGBA", (W, H), bg)
    d = ImageDraw.Draw(img)

    seal_s = int(H * 0.92)
    seal = make_badge(seal_s)
    sy = (H - seal_s) // 2
    sx = int(H * 0.04)
    img.alpha_composite(seal, (sx, sy))

    mark = "BUS.SALE"
    left = sx + seal_s + H * 0.08
    f, bbox = fit_text(d, mark, (W - left) * 0.88, int(H * 0.28))
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    tx = left - bbox[0]
    ty = H / 2 - th / 2 - bbox[1] - H * 0.08
    d.text((tx, ty), mark, font=f, fill=INK + (255,))

    sub = "BUSINESSES 4 SALE"
    f2, b2 = fit_text(d, sub, (W - left) * 0.82, int(H * 0.12))
    d.text((tx, ty + th + H * 0.05 - b2[1]), sub, font=f2, fill=INK + (255,))
    return img.resize((int(size * 2.4), size), Image.Resampling.LANCZOS)


def make_app_icon(size: int = 1024) -> Image.Image:
    scale = 3
    S = size * scale
    img = Image.new("RGBA", (S, S), WHITE + (255,))
    seal_s = int(S * 0.86)
    seal = make_badge(seal_s)
    ox = (S - seal_s) // 2
    oy = (S - seal_s) // 2
    img.alpha_composite(seal, (ox, oy))
    return img.resize((size, size), Image.Resampling.LANCZOS)


def write_svgs() -> None:
    badge = """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" fill="none">
  <defs>
    <clipPath id="c"><circle cx="120" cy="120" r="112"/></clipPath>
  </defs>
  <g clip-path="url(#c)">
    <circle cx="120" cy="120" r="112" fill="#E30613"/>
    <path d="M8 120 A112 112 0 0 0 232 120 L232 232 L8 232 Z" fill="#FFD200"/>
    <rect x="10" y="82" width="220" height="76" fill="#FFFFFF"/>
  </g>
  <circle cx="120" cy="120" r="112" stroke="#111111" stroke-width="5" fill="none"/>
  <text x="120" y="128" text-anchor="middle"
        font-family="Arial Black, Arial, Helvetica, sans-serif"
        font-size="42" font-weight="800" fill="#111111">BUS.SALE</text>
</svg>
"""
    logo = """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 420" fill="none">
  <rect width="320" height="420" fill="#FFFFFF"/>
  <g transform="translate(40,20)">
    <defs>
      <clipPath id="c"><circle cx="120" cy="120" r="112"/></clipPath>
    </defs>
    <g clip-path="url(#c)">
      <circle cx="120" cy="120" r="112" fill="#E30613"/>
      <path d="M8 120 A112 112 0 0 0 232 120 L232 232 L8 232 Z" fill="#FFD200"/>
      <rect x="10" y="82" width="220" height="76" fill="#FFFFFF"/>
    </g>
    <circle cx="120" cy="120" r="112" stroke="#111111" stroke-width="5" fill="none"/>
    <text x="120" y="128" text-anchor="middle"
          font-family="Arial Black, Arial, Helvetica, sans-serif"
          font-size="42" font-weight="800" fill="#111111">BUS.SALE</text>
  </g>
  <text x="160" y="310" text-anchor="middle"
        font-family="Arial, Helvetica, sans-serif"
        font-size="22" font-weight="700" letter-spacing="1.5" fill="#111111">BUSINESSES 4 SALE</text>
</svg>
"""
    (OUT / "bus_sale_badge.svg").write_text(badge, encoding="utf-8")
    (OUT / "bus_sale_logo.svg").write_text(logo, encoding="utf-8")
    (OUT / "bus_sale_p1_badge.svg").write_text(badge, encoding="utf-8")
    (OUT / "bus_sale_p1_logo.svg").write_text(logo, encoding="utf-8")


def make_board() -> Image.Image:
    W, H = 1200, 720
    img = Image.new("RGBA", (W, H), WHITE + (255,))
    d = ImageDraw.Draw(img)
    title = font_heavy(32)
    d.text((40, 28), "BUS.SALE  —  Pack p1 logo (client mark)", font=title, fill=INK)
    note = font_heavy(18)
    d.text(
        (40, 72),
        "Red / yellow circle + bold BUS.SALE band + BUSINESSES 4 SALE  |  larger letters per David",
        font=note,
        fill=RED,
    )
    badge = make_badge(280)
    splash = make_logo_vertical(220)
    icon = make_app_icon(200)
    mono = make_badge(180, mono=True)
    img.alpha_composite(badge, (60, 140))
    img.alpha_composite(splash, (400, 120))
    img.alpha_composite(icon, (820, 160))
    img.alpha_composite(mono, (860, 420))
    small = font_heavy(14)
    d.text((60, 440), "Primary badge", font=small, fill=INK)
    d.text((400, 520), "Splash lockup", font=small, fill=INK)
    d.text((820, 380), "App icon", font=small, fill=INK)
    d.text((860, 620), "Mono", font=small, fill=INK)
    return img


def update_web_icons(icon: Image.Image) -> None:
    icons = WEB / "icons"
    icons.mkdir(parents=True, exist_ok=True)
    icon.resize((192, 192), Image.Resampling.LANCZOS).save(icons / "Icon-192.png")
    icon.resize((512, 512), Image.Resampling.LANCZOS).save(icons / "Icon-512.png")
    icon.resize((192, 192), Image.Resampling.LANCZOS).save(icons / "Icon-maskable-192.png")
    icon.resize((512, 512), Image.Resampling.LANCZOS).save(icons / "Icon-maskable-512.png")
    icon.resize((32, 32), Image.Resampling.LANCZOS).save(WEB / "favicon.png")


def main() -> None:
    write_svgs()

    badge = make_badge(1024)
    badge.save(OUT / "bus_sale_p1_badge_1024.png")
    badge.save(OUT / "bus_sale_icon_1024.png")
    badge.save(IMG / "bus_sale_badge.png")
    # Keep v3 filename aliases pointing at Pack mark so old paths still work
    badge.save(OUT / "bus_sale_v3_badge_1024.png")
    badge.resize((256, 256), Image.Resampling.LANCZOS).save(OUT / "bus_sale_v3_preview_256.png")
    badge.resize((256, 256), Image.Resampling.LANCZOS).save(OUT / "bus_sale_preview_256.png")

    mono = make_badge(1024, mono=True)
    mono.save(OUT / "bus_sale_p1_badge_mono_1024.png")
    mono.save(OUT / "bus_sale_v3_badge_mono_1024.png")

    vertical = make_logo_vertical(1024, on_white=True)
    vertical.save(OUT / "bus_sale_p1_logo_splash.png")
    vertical.save(OUT / "bus_sale_logo_splash.png")
    vertical.save(OUT / "bus_sale_v3_logo_splash.png")
    make_logo_vertical(1024, on_white=False).save(IMG / "bus_sale_logo.png")

    horiz = make_logo_horizontal(512)
    horiz.save(OUT / "bus_sale_p1_logo_horizontal.png")
    horiz.save(OUT / "bus_sale_v3_logo_horizontal.png")

    icon = make_app_icon(1024)
    icon.save(OUT / "bus_sale_p1_icon_1024.png")
    icon.save(OUT / "bus_sale_v3_icon_1024.png")
    white = Image.new("RGB", (1024, 1024), WHITE)
    white.paste(icon, mask=icon.split()[-1])
    white.save(OUT / "bus_sale_p1_icon_1024_white_bg.png")
    white.save(OUT / "bus_sale_icon_1024_white_bg.png")
    white.save(OUT / "bus_sale_v3_icon_1024_white_bg.png")
    update_web_icons(icon)

    board = make_board()
    board.save(OUT / "bus_sale_p1_board.png")
    board.resize((700, 420), Image.Resampling.LANCZOS).save(OUT / "bus_sale_p1_board_preview.png")

    print("Pack p1 logo system written")
    print("App assets:", IMG)


if __name__ == "__main__":
    main()
