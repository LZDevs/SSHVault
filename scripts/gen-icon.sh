#!/bin/bash
# Generates AppIcon.icns for SSHMan
# Uses Swift + CoreGraphics (always available on macOS) to draw the icon

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ICONSET_DIR="$PROJECT_DIR/build/AppIcon.iconset"
ICNS_OUT="$PROJECT_DIR/build/AppIcon.icns"

rm -rf "$ICONSET_DIR"
mkdir -p "$ICONSET_DIR"

# Generate icon PNGs with a Swift script using CoreGraphics
swift - "$ICONSET_DIR" << 'SWIFT_SCRIPT'
import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

func createIcon(size: Int, outputPath: String) {
    let s = CGFloat(size)
    let cs = CGColorSpaceCreateDeviceRGB()
    guard let ctx = CGContext(
        data: nil, width: size, height: size,
        bitsPerComponent: 8, bytesPerRow: size * 4,
        space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else { return }

    // Background: dark rounded rectangle
    let corner = s * 0.18
    let rect = CGRect(x: 0, y: 0, width: s, height: s)
    let bgPath = CGPath(roundedRect: rect, cornerWidth: corner, cornerHeight: corner, transform: nil)

    ctx.setFillColor(red: 0.13, green: 0.13, blue: 0.16, alpha: 1.0)
    ctx.addPath(bgPath)
    ctx.fillPath()

    // Gradient overlay on top half
    ctx.saveGState()
    ctx.addPath(bgPath)
    ctx.clip()
    let gradientColors = [
        CGColor(red: 0.22, green: 0.22, blue: 0.28, alpha: 0.5),
        CGColor(red: 0.13, green: 0.13, blue: 0.16, alpha: 0.0)
    ] as CFArray
    if let gradient = CGGradient(colorsSpace: cs, colors: gradientColors, locations: [0.0, 1.0]) {
        ctx.drawLinearGradient(
            gradient,
            start: CGPoint(x: s/2, y: s),
            end: CGPoint(x: s/2, y: s * 0.4),
            options: []
        )
    }
    ctx.restoreGState()

    // Drawing settings
    ctx.setLineCap(.round)
    ctx.setLineJoin(.round)
    let lw = max(s * 0.06, 1.0)

    // Chevron ">"
    ctx.setLineWidth(lw)
    ctx.setStrokeColor(red: 0.34, green: 0.80, blue: 0.54, alpha: 1.0)
    let cx = s * 0.28, cy = s * 0.52
    let arm = s * 0.12
    ctx.beginPath()
    ctx.move(to: CGPoint(x: cx, y: cy + arm))
    ctx.addLine(to: CGPoint(x: cx + arm, y: cy))
    ctx.addLine(to: CGPoint(x: cx, y: cy - arm))
    ctx.strokePath()

    // Underscore cursor
    ctx.setStrokeColor(red: 0.90, green: 0.90, blue: 0.95, alpha: 0.9)
    let ux = s * 0.48
    let uy = cy - arm
    ctx.beginPath()
    ctx.move(to: CGPoint(x: ux, y: uy))
    ctx.addLine(to: CGPoint(x: ux + s * 0.14, y: uy))
    ctx.strokePath()

    // Key ring (circle)
    ctx.setStrokeColor(red: 0.55, green: 0.70, blue: 1.0, alpha: 0.85)
    ctx.setLineWidth(lw * 0.85)
    let kr = s * 0.07
    let kcx = s * 0.68, kcy = s * 0.55
    ctx.beginPath()
    ctx.addArc(center: CGPoint(x: kcx, y: kcy), radius: kr, startAngle: 0, endAngle: .pi * 2, clockwise: false)
    ctx.strokePath()

    // Key shaft
    let shaftLen = s * 0.16
    ctx.beginPath()
    ctx.move(to: CGPoint(x: kcx + kr, y: kcy))
    ctx.addLine(to: CGPoint(x: kcx + kr + shaftLen, y: kcy))
    ctx.strokePath()

    // Key teeth
    let tooth = s * 0.04
    for i in 0..<2 {
        let tx = kcx + kr + shaftLen * (0.55 + CGFloat(i) * 0.3)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: tx, y: kcy))
        ctx.addLine(to: CGPoint(x: tx, y: kcy - tooth))
        ctx.strokePath()
    }

    // Save PNG
    guard let image = ctx.makeImage(),
          let dest = CGImageDestinationCreateWithURL(
              URL(fileURLWithPath: outputPath) as CFURL,
              UTType.png.identifier as CFString, 1, nil
          ) else { return }
    CGImageDestinationAddImage(dest, image, nil)
    CGImageDestinationFinalize(dest)
}

let iconsetDir = CommandLine.arguments[1]

let sizes: [(String, Int)] = [
    ("16x16",       16),
    ("16x16@2x",    32),
    ("32x32",       32),
    ("32x32@2x",    64),
    ("128x128",    128),
    ("128x128@2x", 256),
    ("256x256",    256),
    ("256x256@2x", 512),
    ("512x512",    512),
    ("512x512@2x",1024),
]

for (name, px) in sizes {
    let path = "\(iconsetDir)/icon_\(name).png"
    createIcon(size: px, outputPath: path)
    print("  Generated \(name) (\(px)x\(px))")
}

print("  Icon PNGs generated successfully.")
SWIFT_SCRIPT

# Convert .iconset to .icns
iconutil --convert icns "$ICONSET_DIR" --output "$ICNS_OUT"
echo "  AppIcon.icns created at $ICNS_OUT"
