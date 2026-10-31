#!/usr/bin/env python3
"""Generate channel icon + splash PNGs. Usage: gen_assets.py <images_dir>"""
import sys
from PIL import Image, ImageDraw, ImageFont

FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

def make(path, w, h, fontsize):
    img = Image.new("RGB", (w, h), (11, 11, 18))
    d = ImageDraw.Draw(img)
    for y in range(h):  # subtle vertical gradient
        t = y / h
        d.line([(0, y), (w, y)], fill=(int(11 + 30 * t), int(11 + 14 * t), int(18 + 60 * t)))
    f = ImageFont.truetype(FONT, fontsize)
    text = "VibeOS"
    bbox = d.textbbox((0, 0), text, font=f)
    d.text(((w - (bbox[2] - bbox[0])) / 2 - bbox[0], (h - (bbox[3] - bbox[1])) / 2 - bbox[1]),
           text, font=f, fill=(255, 255, 255))
    img.save(path)

out = sys.argv[1]
make(f"{out}/icon_focus_hd.png", 290, 218, 44)
make(f"{out}/icon_focus_sd.png", 246, 140, 36)
make(f"{out}/splash_hd.png", 1280, 720, 120)
make(f"{out}/splash_fhd.png", 1920, 1080, 180)
