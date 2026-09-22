"""Businesses 4 Sale — Client-aligned brand (Atelier system + Pack p1 lockup).

David approved the current elegant system (colours, circle clarity).
Requirements applied:
  • Pack p1 logo structure: BUS.SALE in the circle band + BUSINESSES 4 SALE under
  • Letters larger and bolder
  • Home (p2) keeps p1 purpose copy on top

Palette stays Atelier (claret / champagne / ivory) so the mark he liked stays,
while the lockup matches Pack p1.
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

CLARET = (107, 24, 38)  # #6B1826
CHAMPAGNE = (197, 165, 114)  # #C5A572
IVORY = (245, 240, 232)  # #F5F0E8
INK = (26, 20, 18)  # #1A1412
STONE = (222, 212, 196)
WHITE = (255, 255, 255)


def font_heavy(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    for p in (
        r"C:\Windows\Fonts\arialbd.ttf",
        r"C:\Windows\Fonts\segoeuib.ttf",
        r"C:\Windows\Fonts\bahnschrift.ttf",
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


def draw_badge(img: Image.Image, S: int, *, mono: bool = False) -> None:
    """p1 lockup on Atelier palette: split circle + bold BUS.SALE band."""
    d = ImageDraw.Draw(img)
    pad = int(S * 0.035)
    box = [pad, pad, S - pad, S - pad]
    cx = cy = S / 2
    diam = S - 2 * pad

    top = INK if mono else CLARET
    bottom = (160, 160, 160) if mono else CHAMPAGNE
    band = WHITE if mono else IVORY
    text_c = INK
    rim = INK if mono else CLARET

    d.ellipse(box, fill=top + (255,))
    d.pieslice(box, 0, 180, fill=bottom + (255,))

    # Wide band for large type (David: letters bigger / bolder)
    band_h = diam * 0.36
    band_w = diam * 0.98
    rx = cx - band_w / 2
    ry = cy - band_h / 2
    d.rectangle([rx, ry, rx + band_w, ry + band_h], fill=band + (255,))

    text = "BUS.SALE"
    target = band_w * 0.96
    f, bbox = fit_text(d, text, target, int(S * 0.175))
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    d.text(
        (cx - tw / 2 - bbox[0], cy - th / 2 - bbox[1] - S * 0.012),
        text,
        font=f,
        fill=text_c + (255,),
    )

    # Double ring: soft champagne outer, claret hairline (atelier polish)
    outer_w = max(3, int(S * 0.022))
    inner_w = max(2, int(S * 0.01))
    alpha = Image.new("L", (S, S), 0)
    ImageDraw.Draw(alpha).ellipse(box, fill=255)
    rim_layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    rd = ImageDraw.Draw(rim_layer)
    if not mono:
        rd.ellipse(box, outline=CHAMPAGNE + (255,), width=outer_w)
        inset = int(S * 0.012)
        rd.ellipse(
            [pad + inset, pad + inset, S - pad - inset, S - pad - inset],
            outline=rim + (255,),
            width=inner_w,
        )
    else:
        rd.ellipse(box, outline=INK + (255,), width=outer_w)
    img.putalpha(alpha)
    img.alpha_composite(rim_layer)


def make_badge(size: int = 1024, *, mono: bool = False) -> Image.Image:
    scale = 3
    big = size * scale
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    draw_badge(img, big, mono=mono)
    return img.resize((size, size), Image.Resampling.LANCZOS)


def make_logo_vertical(size: int = 1024, *, on_ivory: bool = True) -> Image.Image:
    scale = 3
    W = int(size * 1.08 * scale)
    H = int(size * 1.42 * scale)
    bg = IVORY + (255,) if on_ivory else (0, 0, 0, 0)
    img = Image.new("RGBA", (W, H), bg)
    d = ImageDraw.Draw(img)

    seal_s = int(size * 0.82 * scale)
    seal = make_badge(seal_s)
    sx = (W - seal_s) // 2
    sy = int(H * 0.04)
    img.alpha_composite(seal, (sx, sy))

    # Pack p1 underlock wording
    sub = "BUSINESSES 4 SALE"
    f, bbox = fit_text(d, sub, W * 0.82, int(size * 0.078 * scale))
    tw = bbox[2] - bbox[0]
    d.text(
        ((W - tw) / 2 - bbox[0], sy + seal_s + H * 0.04 - bbox[1]),
        sub,
        font=f,
        fill=INK + (255,),
    )
    return img.resize((int(size * 1.08), int(size * 1.42)), Image.Resampling.LANCZOS)


def make_logo_horizontal(size: int = 512, *, on_ivory: bool = True) -> Image.Image:
    scale = 3
    H = size * scale
    W = int(size * 2.45 * scale)
    bg = IVORY + (255,) if on_ivory else (0, 0, 0, 0)
    img = Image.new("RGBA", (W, H), bg)
    d = ImageDraw.Draw(img)

    seal_s = int(H * 0.9)
    seal = make_badge(seal_s)
    sy = (H - seal_s) // 2
    sx = int(H * 0.04)
    img.alpha_composite(seal, (sx, sy))

    left = sx + seal_s + H * 0.08
    mark = "BUS.SALE"
    f, bbox = fit_text(d, mark, (W - left) * 0.9, int(H * 0.28))
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    tx = left - bbox[0]
    ty = H / 2 - th / 2 - bbox[1] - H * 0.08
    d.text((tx, ty), mark, font=f, fill=INK + (255,))

    sub = "BUSINESSES 4 SALE"
    f2, b2 = fit_text(d, sub, (W - left) * 0.85, int(H * 0.12))
    d.text((tx, ty + th + H * 0.05 - b2[1]), sub, font=f2, fill=CLARET + (255,))
    return img.resize((int(size * 2.45), size), Image.Resampling.LANCZOS)


def make_app_icon(size: int = 1024) -> Image.Image:
    scale = 3
    S = size * scale
    img = Image.new("RGBA", (S, S), IVORY + (255,))
    seal_s = int(S * 0.84)
    seal = make_badge(seal_s)
    ox = oy = (S - seal_s) // 2
    img.alpha_composite(seal, (ox, oy))
    return img.resize((size, size), Image.Resampling.LANCZOS)


def write_svgs() -> None:
    badge = """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" fill="none">
  <defs><clipPath id="c"><circle cx="120" cy="120" r="112"/></clipPath></defs>
  <g clip-path="url(#c)">
    <circle cx="120" cy="120" r="112" fill="#6B1826"/>
    <path d="M8 120 A112 112 0 0 0 232 120 L232 232 L8 232 Z" fill="#C5A572"/>
    <rect x="10" y="80" width="220" height="80" fill="#F5F0E8"/>
  </g>
  <circle cx="120" cy="120" r="112" stroke="#C5A572" stroke-width="6" fill="none"/>
  <circle cx="120" cy="120" r="106" stroke="#6B1826" stroke-width="2.5" fill="none"/>
  <text x="120" y="130" text-anchor="middle"
        font-family="Arial Black, Arial, sans-serif"
        font-size="44" font-weight="800" fill="#1A1412">BUS.SALE</text>
</svg>
"""
    logo = """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 420" fill="none">
  <rect width="320" height="420" fill="#F5F0E8"/>
  <g transform="translate(40,24) scale(1)">
    <defs><clipPath id="c"><circle cx="120" cy="120" r="112"/></clipPath></defs>
    <g clip-path="url(#c)">
      <circle cx="120" cy="120" r="112" fill="#6B1826"/>
      <path d="M8 120 A112 112 0 0 0 232 120 L232 232 L8 232 Z" fill="#C5A572"/>
      <rect x="10" y="80" width="220" height="80" fill="#F5F0E8"/>
    </g>
    <circle cx="120" cy="120" r="112" stroke="#C5A572" stroke-width="6" fill="none"/>
    <circle cx="120" cy="120" r="106" stroke="#6B1826" stroke-width="2.5" fill="none"/>
    <text x="120" y="130" text-anchor="middle"
          font-family="Arial Black, Arial, sans-serif"
          font-size="44" font-weight="800" fill="#1A1412">BUS.SALE</text>
  </g>
  <text x="160" y="320" text-anchor="middle"
        font-family="Arial, Helvetica, sans-serif"
        font-size="24" font-weight="800" letter-spacing="1.2" fill="#1A1412">BUSINESSES 4 SALE</text>
</svg>
"""
    (OUT / "bus_sale_badge.svg").write_text(badge, encoding="utf-8")
    (OUT / "bus_sale_logo.svg").write_text(logo, encoding="utf-8")
    (OUT / "bus_sale_v3_badge.svg").write_text(badge, encoding="utf-8")
    (OUT / "bus_sale_v3_logo.svg").write_text(logo, encoding="utf-8")


def update_web_icons(icon: Image.Image) -> None:
    icons = WEB / "icons"
    icons.mkdir(parents=True, exist_ok=True)
    for name, s in (("Icon-192.png", 192), ("Icon-512.png", 512),
                    ("Icon-maskable-192.png", 192), ("Icon-maskable-512.png", 512)):
        icon.resize((s, s), Image.Resampling.LANCZOS).save(icons / name)
    icon.resize((32, 32), Image.Resampling.LANCZOS).save(WEB / "favicon.png")


def make_board() -> Image.Image:
    W, H = 1200, 700
    img = Image.new("RGBA", (W, H), IVORY + (255,))
    d = ImageDraw.Draw(img)
    d.text((40, 28), "Client-aligned mark", font=font_heavy(30), fill=INK)
    d.text(
        (40, 70),
        "Atelier colours David liked  +  Pack p1 BUS.SALE lockup  +  larger bold letters",
        font=font_heavy(16),
        fill=CLARET,
    )
    img.alpha_composite(make_badge(260), (50, 140))
    img.alpha_composite(make_logo_vertical(200), (380, 120))
    img.alpha_composite(make_app_icon(180), (780, 160))
    img.alpha_composite(make_badge(160, mono=True), (820, 420))
    return img


def main() -> None:
    write_svgs()
    badge = make_badge(1024)
    badge.save(OUT / "bus_sale_v3_badge_1024.png")
    badge.save(OUT / "bus_sale_icon_1024.png")
    badge.save(IMG / "bus_sale_badge.png")
    badge.resize((256, 256), Image.Resampling.LANCZOS).save(OUT / "bus_sale_v3_preview_256.png")

    make_badge(1024, mono=True).save(OUT / "bus_sale_v3_badge_mono_1024.png")

    vertical = make_logo_vertical(1024, on_ivory=True)
    vertical.save(OUT / "bus_sale_v3_logo_splash.png")
    vertical.save(OUT / "bus_sale_logo_splash.png")
    make_logo_vertical(1024, on_ivory=False).save(IMG / "bus_sale_logo.png")

    make_logo_horizontal(512).save(OUT / "bus_sale_v3_logo_horizontal.png")

    icon = make_app_icon(1024)
    icon.save(OUT / "bus_sale_v3_icon_1024.png")
    white = Image.new("RGB", (1024, 1024), WHITE)
    white.paste(icon, mask=icon.split()[-1])
    white.save(OUT / "bus_sale_v3_icon_1024_white_bg.png")
    white.save(OUT / "bus_sale_icon_1024_white_bg.png")
    update_web_icons(icon)

    board = make_board()
    board.save(OUT / "bus_sale_v3_board.png")
    board.resize((700, 410), Image.Resampling.LANCZOS).save(OUT / "bus_sale_v3_board_preview.png")

    print("Client-aligned brand written (Atelier + p1 lockup)")


if __name__ == "__main__":
    main()
