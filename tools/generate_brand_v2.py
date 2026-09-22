"""Businesses 4 Sale — Brand System v2 (Modern)."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

OUT = Path(r"c:/Projects/Project_3/assets/brand")
OUT.mkdir(parents=True, exist_ok=True)
IMG = Path(r"c:/Projects/Project_3/assets/images")

RED = (214, 24, 38)
GOLD = (242, 186, 0)
INK = (22, 22, 24)
CREAM = (255, 252, 248)


def font(size: int, bold: bool = True):
    paths = [
        r"C:\Windows\Fonts\arialbd.ttf" if bold else r"C:\Windows\Fonts\arial.ttf",
        r"C:\Windows\Fonts\segoeuib.ttf" if bold else r"C:\Windows\Fonts\segoeui.ttf",
    ]
    for p in paths:
        if Path(p).exists():
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def draw_modern_badge(img: Image.Image, S: int) -> None:
    d = ImageDraw.Draw(img)
    pad = int(S * 0.04)
    box = [pad, pad, S - pad, S - pad]
    cx = cy = S / 2
    r = (S - 2 * pad) / 2

    d.ellipse(box, fill=RED + (255,))
    d.pieslice(box, 0, 180, fill=GOLD + (255,))

    band_h = r * 2 * 0.30
    band_w = r * 2 * 0.92
    rx = cx - band_w / 2
    ry = cy - band_h / 2
    d.rounded_rectangle(
        [rx, ry, rx + band_w, ry + band_h],
        radius=band_h / 2,
        fill=CREAM + (255,),
    )

    text = "BUS.SALE"
    target = band_w * 0.82
    fs = int(S * 0.105)
    f = font(fs, True)
    for _ in range(30):
        bbox = d.textbbox((0, 0), text, font=f)
        tw = bbox[2] - bbox[0]
        if abs(tw - target) < S * 0.01:
            break
        fs = int(fs * (target / max(tw, 1)))
        f = font(max(8, fs), True)
    bbox = d.textbbox((0, 0), text, font=f)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    d.text(
        (cx - tw / 2 - bbox[0], cy - th / 2 - bbox[1] - S * 0.008),
        text,
        font=f,
        fill=INK + (255,),
    )

    alpha = Image.new("L", (S, S), 0)
    ImageDraw.Draw(alpha).ellipse(box, fill=255)
    rim = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    ImageDraw.Draw(rim).ellipse(
        box, outline=INK + (40,), width=max(2, S // 180)
    )
    img.putalpha(alpha)
    img.alpha_composite(rim)


def make_badge(size: int = 1024) -> Image.Image:
    scale = 3
    big = size * scale
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    draw_modern_badge(img, big)
    return img.resize((size, size), Image.Resampling.LANCZOS)


def make_app_icon_symbol(size: int = 1024) -> Image.Image:
    scale = 3
    S = size * scale
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, S, S], fill=CREAM + (255,))
    r = S * 0.28
    d.ellipse([S * 0.18, S * 0.22, S * 0.18 + 2 * r, S * 0.22 + 2 * r], fill=RED + (255,))
    d.ellipse([S * 0.34, S * 0.34, S * 0.34 + 2 * r, S * 0.34 + 2 * r], fill=GOLD + (255,))
    rr = S * 0.145
    d.ellipse([S * 0.5 - rr, S * 0.5 - rr, S * 0.5 + rr, S * 0.5 + rr], fill=CREAM + (255,))
    f = font(int(S * 0.34), True)
    t = "4"
    bbox = d.textbbox((0, 0), t, font=f)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    d.text(
        (S / 2 - tw / 2 - bbox[0], S / 2 - th / 2 - bbox[1] - S * 0.02),
        t,
        font=f,
        fill=INK + (255,),
    )
    return img.resize((size, size), Image.Resampling.LANCZOS)


def make_lockup(width: int = 1600) -> Image.Image:
    badge = make_badge(int(width * 0.42))
    word = "BUSINESSES 4 SALE"
    f = font(int(width * 0.048), True)
    tmp = ImageDraw.Draw(Image.new("RGBA", (10, 10)))
    bbox = tmp.textbbox((0, 0), word, font=f)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    gap = int(width * 0.035)
    h = badge.height + gap + th + int(width * 0.02)
    canvas = Image.new("RGBA", (width, h), (0, 0, 0, 0))
    canvas.alpha_composite(badge, ((width - badge.width) // 2, 0))
    d = ImageDraw.Draw(canvas)
    tracking = int(width * 0.004)
    x = (width - (tw + tracking * (len(word) - 1))) / 2
    y = badge.height + gap - bbox[1]
    for ch in word:
        cb = d.textbbox((0, 0), ch, font=f)
        cw = cb[2] - cb[0]
        d.text((x - cb[0], y), ch, font=f, fill=INK + (255,))
        x += cw + tracking
    return canvas


def write_svgs() -> None:
    (OUT / "bus_sale_v2_badge.svg").write_text(
        """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" role="img" aria-label="BUS.SALE">
  <defs><clipPath id="c"><circle cx="256" cy="256" r="248"/></clipPath></defs>
  <g clip-path="url(#c)">
    <rect width="512" height="256" fill="#D61826"/>
    <rect y="256" width="512" height="256" fill="#F2BA00"/>
    <rect x="36" y="178" width="440" height="156" rx="78" ry="78" fill="#FFFCFA"/>
  </g>
  <text x="256" y="274" text-anchor="middle"
        font-family="Arial Black, Arial, Helvetica, sans-serif"
        font-size="58" font-weight="800" fill="#161618" letter-spacing="1.5">BUS.SALE</text>
</svg>
""",
        encoding="utf-8",
    )
    (OUT / "bus_sale_v2_logo.svg").write_text(
        """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 640" role="img" aria-label="Businesses 4 Sale">
  <defs><clipPath id="c"><circle cx="256" cy="256" r="248"/></clipPath></defs>
  <g clip-path="url(#c)">
    <rect width="512" height="256" fill="#D61826"/>
    <rect y="256" width="512" height="256" fill="#F2BA00"/>
    <rect x="36" y="178" width="440" height="156" rx="78" ry="78" fill="#FFFCFA"/>
  </g>
  <text x="256" y="274" text-anchor="middle"
        font-family="Arial Black, Arial, Helvetica, sans-serif"
        font-size="58" font-weight="800" fill="#161618" letter-spacing="1.5">BUS.SALE</text>
  <text x="256" y="580" text-anchor="middle"
        font-family="Arial, Helvetica, sans-serif"
        font-size="32" font-weight="700" fill="#161618" letter-spacing="4">BUSINESSES 4 SALE</text>
</svg>
""",
        encoding="utf-8",
    )
    (OUT / "bus_sale_v2_icon_mark.svg").write_text(
        """<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" role="img" aria-label="Businesses 4 Sale mark">
  <rect width="512" height="512" fill="#FFFCFA"/>
  <circle cx="200" cy="210" r="118" fill="#D61826"/>
  <circle cx="300" cy="290" r="118" fill="#F2BA00"/>
  <circle cx="256" cy="256" r="62" fill="#FFFCFA"/>
  <text x="256" y="286" text-anchor="middle"
        font-family="Arial Black, Arial, Helvetica, sans-serif"
        font-size="120" font-weight="800" fill="#161618">4</text>
</svg>
""",
        encoding="utf-8",
    )


def main() -> None:
    badge = make_badge(1024)
    badge.save(OUT / "bus_sale_v2_badge_1024.png")

    store = Image.new("RGB", (1024, 1024), CREAM)
    b = make_badge(820)
    store.paste(b, ((1024 - 820) // 2, (1024 - 820) // 2), b)
    store.save(OUT / "bus_sale_v2_icon_1024.png")

    icon_mark = make_app_icon_symbol(1024)
    icon_mark.convert("RGB").save(OUT / "bus_sale_v2_icon_mark_1024.png")

    lockup = make_lockup(1600)
    lockup.save(OUT / "bus_sale_v2_logo_splash.png")

    splash = Image.new("RGB", (1242, 2688), (255, 255, 255))
    scale = 560 / lockup.width
    lw, lh = int(lockup.width * scale), int(lockup.height * scale)
    lr = lockup.resize((lw, lh), Image.Resampling.LANCZOS)
    splash.paste(lr, ((1242 - lw) // 2, int(2688 * 0.20)), lr)
    splash.save(OUT / "bus_sale_v2_splash_mock.png")

    badge.resize((256, 256), Image.Resampling.LANCZOS).save(
        OUT / "bus_sale_v2_preview_256.png"
    )
    icon_mark.resize((256, 256), Image.Resampling.LANCZOS).save(
        OUT / "bus_sale_v2_mark_preview_256.png"
    )

    write_svgs()

    IMG.mkdir(parents=True, exist_ok=True)
    badge.save(IMG / "bus_sale_badge.png")
    lockup.save(IMG / "bus_sale_logo.png")

    print("v2 complete")
    print("colors", badge.getpixel((512, 180)), badge.getpixel((512, 512)), badge.getpixel((512, 820)))


if __name__ == "__main__":
    main()
