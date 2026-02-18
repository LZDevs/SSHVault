import SwiftUI

// MARK: - Color hex helper

extension Color {
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}

// MARK: - App Theme

struct AppTheme: Identifiable, Equatable {
    let id: String
    let name: String
    let isDark: Bool

    let background: Color
    let sidebar: Color
    let surface: Color
    let foreground: Color
    let secondary: Color

    let accent: Color
    let cyan: Color
    let green: Color
    let orange: Color
    let pink: Color
    let red: Color
    let yellow: Color

    static func == (lhs: AppTheme, rhs: AppTheme) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Premade Themes

extension AppTheme {

    static let all: [AppTheme] = [
        // Dark — classic
        .dracula, .oneDark, .tokyoNight, .nord,
        .catppuccinMocha, .gruvboxDark, .rosePine,
        // Dark — daisyUI
        .dark, .synthwave, .halloween, .forest, .aqua,
        .luxury, .draculaDaisy, .business, .night, .coffee,
        .dim, .sunset, .abyss,
        // Light — classic
        .githubLight, .solarizedLight, .catppuccinLatte,
        // Light — daisyUI
        .light, .cupcake, .bumblebee, .emerald, .corporate,
        .retro, .cyberpunk, .valentine, .garden, .lofi,
        .pastel, .fantasy, .cmyk, .autumn, .acid,
        .lemonade, .winter, .nordLight, .caramelLatte, .silk,
    ]

    // ── Dark Themes ──

    static let dracula = AppTheme(
        id: "dracula", name: "Dracula", isDark: true,
        background: Color(hex: 0x282A36),
        sidebar:    Color(hex: 0x21222C),
        surface:    Color(hex: 0x44475A),
        foreground: Color(hex: 0xF8F8F2),
        secondary:  Color(hex: 0x6272A4),
        accent:     Color(hex: 0xBD93F9),
        cyan:       Color(hex: 0x8BE9FD),
        green:      Color(hex: 0x50FA7B),
        orange:     Color(hex: 0xFFB86C),
        pink:       Color(hex: 0xFF79C6),
        red:        Color(hex: 0xFF5555),
        yellow:     Color(hex: 0xF1FA8C)
    )

    static let oneDark = AppTheme(
        id: "one-dark", name: "One Dark", isDark: true,
        background: Color(hex: 0x282C34),
        sidebar:    Color(hex: 0x21252B),
        surface:    Color(hex: 0x2C313A),
        foreground: Color(hex: 0xABB2BF),
        secondary:  Color(hex: 0x5C6370),
        accent:     Color(hex: 0x61AFEF),
        cyan:       Color(hex: 0x56B6C2),
        green:      Color(hex: 0x98C379),
        orange:     Color(hex: 0xD19A66),
        pink:       Color(hex: 0xC678DD),
        red:        Color(hex: 0xE06C75),
        yellow:     Color(hex: 0xE5C07B)
    )

    static let tokyoNight = AppTheme(
        id: "tokyo-night", name: "Tokyo Night", isDark: true,
        background: Color(hex: 0x1A1B26),
        sidebar:    Color(hex: 0x16161E),
        surface:    Color(hex: 0x24283B),
        foreground: Color(hex: 0xA9B1D6),
        secondary:  Color(hex: 0x565F89),
        accent:     Color(hex: 0x7AA2F7),
        cyan:       Color(hex: 0x7DCFFF),
        green:      Color(hex: 0x9ECE6A),
        orange:     Color(hex: 0xFF9E64),
        pink:       Color(hex: 0xBB9AF7),
        red:        Color(hex: 0xF7768E),
        yellow:     Color(hex: 0xE0AF68)
    )

    static let nord = AppTheme(
        id: "nord", name: "Nord", isDark: true,
        background: Color(hex: 0x2E3440),
        sidebar:    Color(hex: 0x272C36),
        surface:    Color(hex: 0x3B4252),
        foreground: Color(hex: 0xECEFF4),
        secondary:  Color(hex: 0x4C566A),
        accent:     Color(hex: 0x88C0D0),
        cyan:       Color(hex: 0x8FBCBB),
        green:      Color(hex: 0xA3BE8C),
        orange:     Color(hex: 0xD08770),
        pink:       Color(hex: 0xB48EAD),
        red:        Color(hex: 0xBF616A),
        yellow:     Color(hex: 0xEBCB8B)
    )

    static let catppuccinMocha = AppTheme(
        id: "catppuccin-mocha", name: "Catppuccin Mocha", isDark: true,
        background: Color(hex: 0x1E1E2E),
        sidebar:    Color(hex: 0x181825),
        surface:    Color(hex: 0x313244),
        foreground: Color(hex: 0xCDD6F4),
        secondary:  Color(hex: 0x6C7086),
        accent:     Color(hex: 0xCBA6F7),
        cyan:       Color(hex: 0x89DCEB),
        green:      Color(hex: 0xA6E3A1),
        orange:     Color(hex: 0xFAB387),
        pink:       Color(hex: 0xF5C2E7),
        red:        Color(hex: 0xF38BA8),
        yellow:     Color(hex: 0xF9E2AF)
    )

    static let gruvboxDark = AppTheme(
        id: "gruvbox-dark", name: "Gruvbox Dark", isDark: true,
        background: Color(hex: 0x282828),
        sidebar:    Color(hex: 0x1D2021),
        surface:    Color(hex: 0x3C3836),
        foreground: Color(hex: 0xEBDBB2),
        secondary:  Color(hex: 0x928374),
        accent:     Color(hex: 0xFE8019),
        cyan:       Color(hex: 0x8EC07C),
        green:      Color(hex: 0xB8BB26),
        orange:     Color(hex: 0xFE8019),
        pink:       Color(hex: 0xD3869B),
        red:        Color(hex: 0xFB4934),
        yellow:     Color(hex: 0xFABD2F)
    )

    static let rosePine = AppTheme(
        id: "rose-pine", name: "Rosé Pine", isDark: true,
        background: Color(hex: 0x191724),
        sidebar:    Color(hex: 0x13111E),
        surface:    Color(hex: 0x26233A),
        foreground: Color(hex: 0xE0DEF4),
        secondary:  Color(hex: 0x6E6A86),
        accent:     Color(hex: 0xC4A7E7),
        cyan:       Color(hex: 0x9CCFD8),
        green:      Color(hex: 0x31748F),
        orange:     Color(hex: 0xF6C177),
        pink:       Color(hex: 0xEBBCBA),
        red:        Color(hex: 0xEB6F92),
        yellow:     Color(hex: 0xF6C177)
    )

    // ── Light Themes ──

    static let githubLight = AppTheme(
        id: "github-light", name: "GitHub Light", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xF6F8FA),
        surface:    Color(hex: 0xF6F8FA),
        foreground: Color(hex: 0x24292F),
        secondary:  Color(hex: 0x57606A),
        accent:     Color(hex: 0x0969DA),
        cyan:       Color(hex: 0x0550AE),
        green:      Color(hex: 0x1A7F37),
        orange:     Color(hex: 0xBC4C00),
        pink:       Color(hex: 0x8250DF),
        red:        Color(hex: 0xCF222E),
        yellow:     Color(hex: 0x9A6700)
    )

    static let solarizedLight = AppTheme(
        id: "solarized-light", name: "Solarized Light", isDark: false,
        background: Color(hex: 0xFDF6E3),
        sidebar:    Color(hex: 0xEEE8D5),
        surface:    Color(hex: 0xEEE8D5),
        foreground: Color(hex: 0x657B83),
        secondary:  Color(hex: 0x93A1A1),
        accent:     Color(hex: 0x268BD2),
        cyan:       Color(hex: 0x2AA198),
        green:      Color(hex: 0x859900),
        orange:     Color(hex: 0xCB4B16),
        pink:       Color(hex: 0xD33682),
        red:        Color(hex: 0xDC322F),
        yellow:     Color(hex: 0xB58900)
    )

    static let catppuccinLatte = AppTheme(
        id: "catppuccin-latte", name: "Catppuccin Latte", isDark: false,
        background: Color(hex: 0xEFF1F5),
        sidebar:    Color(hex: 0xE6E9EF),
        surface:    Color(hex: 0xDCE0E8),
        foreground: Color(hex: 0x4C4F69),
        secondary:  Color(hex: 0x9CA0B0),
        accent:     Color(hex: 0x8839EF),
        cyan:       Color(hex: 0x04A5E5),
        green:      Color(hex: 0x40A02B),
        orange:     Color(hex: 0xFE640B),
        pink:       Color(hex: 0xEA76CB),
        red:        Color(hex: 0xD20F39),
        yellow:     Color(hex: 0xDF8E1D)
    )

    // ── daisyUI Themes ──

    static let light = AppTheme(
        id: "light", name: "Light", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xF8F8F8),
        surface:    Color(hex: 0xEEEEEE),
        foreground: Color(hex: 0x18181B),
        secondary:  Color(hex: 0x09090B),
        accent:     Color(hex: 0x422AD5),
        cyan:       Color(hex: 0x00B9FA),
        green:      Color(hex: 0x00D093),
        orange:     Color(hex: 0xF6B900),
        pink:       Color(hex: 0xF43098),
        red:        Color(hex: 0xFF667F),
        yellow:     Color(hex: 0x00D0BB)
    )

    static let dark = AppTheme(
        id: "dark", name: "Dark", isDark: true,
        background: Color(hex: 0x1D232A),
        sidebar:    Color(hex: 0x191E24),
        surface:    Color(hex: 0x15191E),
        foreground: Color(hex: 0xF3F8FF),
        secondary:  Color(hex: 0x09090B),
        accent:     Color(hex: 0x605DFF),
        cyan:       Color(hex: 0x00B9FA),
        green:      Color(hex: 0x00D093),
        orange:     Color(hex: 0xF6B900),
        pink:       Color(hex: 0xF43098),
        red:        Color(hex: 0xFF667F),
        yellow:     Color(hex: 0x00D0BB)
    )

    static let cupcake = AppTheme(
        id: "cupcake", name: "Cupcake", isDark: false,
        background: Color(hex: 0xFAF7F5),
        sidebar:    Color(hex: 0xEFEAE6),
        surface:    Color(hex: 0xE7E2DF),
        foreground: Color(hex: 0x291334),
        secondary:  Color(hex: 0x262629),
        accent:     Color(hex: 0x44EBD3),
        cyan:       Color(hex: 0x00A4E8),
        green:      Color(hex: 0x00B77F),
        orange:     Color(hex: 0xE8B100),
        pink:       Color(hex: 0xF9CBE5),
        red:        Color(hex: 0xFE1C55),
        yellow:     Color(hex: 0xFFD6A7)
    )

    static let bumblebee = AppTheme(
        id: "bumblebee", name: "Bumblebee", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xF5F5F5),
        surface:    Color(hex: 0xE4E4E4),
        foreground: Color(hex: 0x161616),
        secondary:  Color(hex: 0x433F3A),
        accent:     Color(hex: 0xF7C800),
        cyan:       Color(hex: 0x00B9FA),
        green:      Color(hex: 0x00D093),
        orange:     Color(hex: 0xF6B900),
        pink:       Color(hex: 0xFF8B1F),
        red:        Color(hex: 0xFF6266),
        yellow:     Color(hex: 0x000000)
    )

    static let emerald = AppTheme(
        id: "emerald", name: "Emerald", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xE8E8E8),
        surface:    Color(hex: 0xD1D1D1),
        foreground: Color(hex: 0x333C4D),
        secondary:  Color(hex: 0x333C4D),
        accent:     Color(hex: 0x66CC8A),
        cyan:       Color(hex: 0x00B3F0),
        green:      Color(hex: 0x00A96F),
        orange:     Color(hex: 0xFFC22D),
        pink:       Color(hex: 0x377CFB),
        red:        Color(hex: 0xFF6F70),
        yellow:     Color(hex: 0xF68067)
    )

    static let corporate = AppTheme(
        id: "corporate", name: "Corporate", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xE8E8E8),
        surface:    Color(hex: 0xD1D1D1),
        foreground: Color(hex: 0x181A2A),
        secondary:  Color(hex: 0x000000),
        accent:     Color(hex: 0x0082C4),
        cyan:       Color(hex: 0x008EAF),
        green:      Color(hex: 0x00A146),
        orange:     Color(hex: 0xF7C800),
        pink:       Color(hex: 0x61738D),
        red:        Color(hex: 0xFF6266),
        yellow:     Color(hex: 0x009488)
    )

    static let synthwave = AppTheme(
        id: "synthwave", name: "Synthwave", isDark: true,
        background: Color(hex: 0x09002F),
        sidebar:    Color(hex: 0x120B3D),
        surface:    Color(hex: 0x1C184B),
        foreground: Color(hex: 0xA2B2FF),
        secondary:  Color(hex: 0x422AD5),
        accent:     Color(hex: 0xF861B4),
        cyan:       Color(hex: 0x00B9FA),
        green:      Color(hex: 0x00D0BB),
        orange:     Color(hex: 0xFEDE1C),
        pink:       Color(hex: 0x71D1FE),
        red:        Color(hex: 0xEC8C78),
        yellow:     Color(hex: 0xFF8B1F)
    )

    static let retro = AppTheme(
        id: "retro", name: "Retro", isDark: false,
        background: Color(hex: 0xECE3CA),
        sidebar:    Color(hex: 0xE4D8B4),
        surface:    Color(hex: 0xDBCA9B),
        foreground: Color(hex: 0x793205),
        secondary:  Color(hex: 0x56524C),
        accent:     Color(hex: 0xFF9FA0),
        cyan:       Color(hex: 0x0082C4),
        green:      Color(hex: 0x00766E),
        orange:     Color(hex: 0xE95500),
        pink:       Color(hex: 0xB7F6CD),
        red:        Color(hex: 0xFF6266),
        yellow:     Color(hex: 0xCA8A00)
    )

    static let cyberpunk = AppTheme(
        id: "cyberpunk", name: "Cyberpunk", isDark: false,
        background: Color(hex: 0xFFF25E),
        sidebar:    Color(hex: 0xF7E83A),
        surface:    Color(hex: 0xE3D40E),
        foreground: Color(hex: 0x000000),
        secondary:  Color(hex: 0x111A3B),
        accent:     Color(hex: 0xFF7A9B),
        cyan:       Color(hex: 0x00B3F0),
        green:      Color(hex: 0x00A96F),
        orange:     Color(hex: 0xFFC22D),
        pink:       Color(hex: 0x00E2F4),
        red:        Color(hex: 0xFF6F70),
        yellow:     Color(hex: 0xCB7AFF)
    )

    static let valentine = AppTheme(
        id: "valentine", name: "Valentine", isDark: false,
        background: Color(hex: 0xFCF2F8),
        sidebar:    Color(hex: 0xF9E4F0),
        surface:    Color(hex: 0xF9CBE5),
        foreground: Color(hex: 0xC0005B),
        secondary:  Color(hex: 0x830C41),
        accent:     Color(hex: 0xF43098),
        cyan:       Color(hex: 0x51E8FB),
        green:      Color(hex: 0x5CE8B3),
        orange:     Color(hex: 0xFF8B1F),
        pink:       Color(hex: 0xA949FF),
        red:        Color(hex: 0xF82834),
        yellow:     Color(hex: 0x71D1FE)
    )

    static let halloween = AppTheme(
        id: "halloween", name: "Halloween", isDark: true,
        background: Color(hex: 0x1B1816),
        sidebar:    Color(hex: 0x0B0908),
        surface:    Color(hex: 0x000000),
        foreground: Color(hex: 0xCDCDCD),
        secondary:  Color(hex: 0x2F1B05),
        accent:     Color(hex: 0xFF9A33),
        cyan:       Color(hex: 0x2563EB),
        green:      Color(hex: 0x18A34A),
        orange:     Color(hex: 0xD97708),
        pink:       Color(hex: 0x7900BE),
        red:        Color(hex: 0xF35248),
        yellow:     Color(hex: 0x50A700)
    )

    static let garden = AppTheme(
        id: "garden", name: "Garden", isDark: false,
        background: Color(hex: 0xE9E7E7),
        sidebar:    Color(hex: 0xD4D2D2),
        surface:    Color(hex: 0xBEBDBD),
        foreground: Color(hex: 0x100F0F),
        secondary:  Color(hex: 0x291E00),
        accent:     Color(hex: 0xF50076),
        cyan:       Color(hex: 0x00B3F0),
        green:      Color(hex: 0x00A96F),
        orange:     Color(hex: 0xFFC22D),
        pink:       Color(hex: 0x8E4162),
        red:        Color(hex: 0xFF6F70),
        yellow:     Color(hex: 0x5C7F67)
    )

    static let forest = AppTheme(
        id: "forest", name: "Forest", isDark: true,
        background: Color(hex: 0x1B1717),
        sidebar:    Color(hex: 0x161212),
        surface:    Color(hex: 0x110D0D),
        foreground: Color(hex: 0xCAC9C9),
        secondary:  Color(hex: 0x19362D),
        accent:     Color(hex: 0x1FB854),
        cyan:       Color(hex: 0x00B3F0),
        green:      Color(hex: 0x00A96F),
        orange:     Color(hex: 0xFFC22D),
        pink:       Color(hex: 0x1EB88E),
        red:        Color(hex: 0xFF6F70),
        yellow:     Color(hex: 0x1FB8AB)
    )

    static let aqua = AppTheme(
        id: "aqua", name: "Aqua", isDark: true,
        background: Color(hex: 0x1A368B),
        sidebar:    Color(hex: 0x162455),
        surface:    Color(hex: 0x091444),
        foreground: Color(hex: 0xB8E6FE),
        secondary:  Color(hex: 0x05176C),
        accent:     Color(hex: 0x13ECF3),
        cyan:       Color(hex: 0x2563EB),
        green:      Color(hex: 0x18A34A),
        orange:     Color(hex: 0xD97708),
        pink:       Color(hex: 0x966FB3),
        red:        Color(hex: 0xFF7F72),
        yellow:     Color(hex: 0xFFE999)
    )

    static let lofi = AppTheme(
        id: "lofi", name: "Lo-Fi", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xF5F5F5),
        surface:    Color(hex: 0xEBEBEB),
        foreground: Color(hex: 0x000000),
        secondary:  Color(hex: 0x000000),
        accent:     Color(hex: 0x0D0D0D),
        cyan:       Color(hex: 0x5FCFDD),
        green:      Color(hex: 0x69FEC3),
        orange:     Color(hex: 0xFFD182),
        pink:       Color(hex: 0x1A1919),
        red:        Color(hex: 0xFF9A8C),
        yellow:     Color(hex: 0x262626)
    )

    static let pastel = AppTheme(
        id: "pastel", name: "Pastel", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xF9FAFB),
        surface:    Color(hex: 0xE5E6E7),
        foreground: Color(hex: 0x161616),
        secondary:  Color(hex: 0x61738D),
        accent:     Color(hex: 0xE8D4FF),
        cyan:       Color(hex: 0x51E8FB),
        green:      Color(hex: 0x7AF1A7),
        orange:     Color(hex: 0xFFB668),
        pink:       Color(hex: 0xFECCD2),
        red:        Color(hex: 0xFF9FA0),
        yellow:     Color(hex: 0xA3F2CE)
    )

    static let fantasy = AppTheme(
        id: "fantasy", name: "Fantasy", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xE8E8E8),
        surface:    Color(hex: 0xD1D1D1),
        foreground: Color(hex: 0x1F2937),
        secondary:  Color(hex: 0x1F2937),
        accent:     Color(hex: 0x6B0072),
        cyan:       Color(hex: 0x00B3F0),
        green:      Color(hex: 0x00A96F),
        orange:     Color(hex: 0xFFC22D),
        pink:       Color(hex: 0x0075B1),
        red:        Color(hex: 0xFF6F70),
        yellow:     Color(hex: 0xFF912E)
    )

    static let luxury = AppTheme(
        id: "luxury", name: "Luxury", isDark: true,
        background: Color(hex: 0x09090B),
        sidebar:    Color(hex: 0x171618),
        surface:    Color(hex: 0x1E1D1F),
        foreground: Color(hex: 0xDCA54D),
        secondary:  Color(hex: 0x331800),
        accent:     Color(hex: 0xFFFFFF),
        cyan:       Color(hex: 0x67C6FF),
        green:      Color(hex: 0x87D03A),
        orange:     Color(hex: 0xE2D563),
        pink:       Color(hex: 0x152747),
        red:        Color(hex: 0xFF6F6F),
        yellow:     Color(hex: 0x513448)
    )

    static let draculaDaisy = AppTheme(
        id: "dracula-daisy", name: "Dracula II", isDark: true,
        background: Color(hex: 0x282A36),
        sidebar:    Color(hex: 0x232530),
        surface:    Color(hex: 0x1F202A),
        foreground: Color(hex: 0xF8F8F3),
        secondary:  Color(hex: 0x414558),
        accent:     Color(hex: 0xFF79C6),
        cyan:       Color(hex: 0x8BE9FD),
        green:      Color(hex: 0x51FA7B),
        orange:     Color(hex: 0xF1FA8C),
        pink:       Color(hex: 0xBD93F9),
        red:        Color(hex: 0xFF5555),
        yellow:     Color(hex: 0xFFB86C)
    )

    static let cmyk = AppTheme(
        id: "cmyk", name: "CMYK", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xEEEEEE),
        surface:    Color(hex: 0xDEDEDE),
        foreground: Color(hex: 0x161616),
        secondary:  Color(hex: 0x1A1A1A),
        accent:     Color(hex: 0x45AEEE),
        cyan:       Color(hex: 0x4BA8C0),
        green:      Color(hex: 0x823290),
        orange:     Color(hex: 0xEE8134),
        pink:       Color(hex: 0xE8488A),
        red:        Color(hex: 0xE93F33),
        yellow:     Color(hex: 0xFFF234)
    )

    static let autumn = AppTheme(
        id: "autumn", name: "Autumn", isDark: false,
        background: Color(hex: 0xF1F1F1),
        sidebar:    Color(hex: 0xDBDBDB),
        surface:    Color(hex: 0xC5C5C5),
        foreground: Color(hex: 0x141414),
        secondary:  Color(hex: 0x826A5C),
        accent:     Color(hex: 0x8C0327),
        cyan:       Color(hex: 0x44ADBB),
        green:      Color(hex: 0x499380),
        orange:     Color(hex: 0xE97F16),
        pink:       Color(hex: 0xD85251),
        red:        Color(hex: 0xCB0024),
        yellow:     Color(hex: 0xD59B6B)
    )

    static let business = AppTheme(
        id: "business", name: "Business", isDark: true,
        background: Color(hex: 0x202020),
        sidebar:    Color(hex: 0x1C1C1C),
        surface:    Color(hex: 0x181818),
        foreground: Color(hex: 0xCDCDCD),
        secondary:  Color(hex: 0x23282E),
        accent:     Color(hex: 0x1C4E80),
        cyan:       Color(hex: 0x0291D5),
        green:      Color(hex: 0x6BB187),
        orange:     Color(hex: 0xDBAE5A),
        pink:       Color(hex: 0x7C909A),
        red:        Color(hex: 0xAC3E31),
        yellow:     Color(hex: 0xEA6947)
    )

    static let acid = AppTheme(
        id: "acid", name: "Acid", isDark: false,
        background: Color(hex: 0xF8F8F8),
        sidebar:    Color(hex: 0xEEEEEE),
        surface:    Color(hex: 0xE1E1E1),
        foreground: Color(hex: 0x000000),
        secondary:  Color(hex: 0x140151),
        accent:     Color(hex: 0xFF42F4),
        cyan:       Color(hex: 0x0083EB),
        green:      Color(hex: 0x00F69E),
        orange:     Color(hex: 0xFEE300),
        pink:       Color(hex: 0xFF8031),
        red:        Color(hex: 0xFF3426),
        yellow:     Color(hex: 0xCCFE00)
    )

    static let lemonade = AppTheme(
        id: "lemonade", name: "Lemonade", isDark: false,
        background: Color(hex: 0xF8FDEF),
        sidebar:    Color(hex: 0xE1E6D9),
        surface:    Color(hex: 0xCBCFC3),
        foreground: Color(hex: 0x151614),
        secondary:  Color(hex: 0x333200),
        accent:     Color(hex: 0x4C9100),
        cyan:       Color(hex: 0xB1D9E9),
        green:      Color(hex: 0xB9DBC6),
        orange:     Color(hex: 0xD7D3B0),
        pink:       Color(hex: 0xBCC000),
        red:        Color(hex: 0xEFC6C2),
        yellow:     Color(hex: 0xE9D100)
    )

    static let night = AppTheme(
        id: "night", name: "Night", isDark: true,
        background: Color(hex: 0x0F172A),
        sidebar:    Color(hex: 0x0C1425),
        surface:    Color(hex: 0x0A1120),
        foreground: Color(hex: 0xC9CBD0),
        secondary:  Color(hex: 0x1E293B),
        accent:     Color(hex: 0x3ABDF7),
        cyan:       Color(hex: 0x0CA5E9),
        green:      Color(hex: 0x2FD4BF),
        orange:     Color(hex: 0xF4BF51),
        pink:       Color(hex: 0x818CF8),
        red:        Color(hex: 0xFB7085),
        yellow:     Color(hex: 0xF471B5)
    )

    static let coffee = AppTheme(
        id: "coffee", name: "Coffee", isDark: true,
        background: Color(hex: 0x261B25),
        sidebar:    Color(hex: 0x1E151D),
        surface:    Color(hex: 0x120A11),
        foreground: Color(hex: 0xC59F61),
        secondary:  Color(hex: 0x120C12),
        accent:     Color(hex: 0xDB924C),
        cyan:       Color(hex: 0x8ECAC1),
        green:      Color(hex: 0x9DB787),
        orange:     Color(hex: 0xFFD260),
        pink:       Color(hex: 0x273E3F),
        red:        Color(hex: 0xFC9581),
        yellow:     Color(hex: 0x11576D)
    )

    static let winter = AppTheme(
        id: "winter", name: "Winter", isDark: false,
        background: Color(hex: 0xFFFFFF),
        sidebar:    Color(hex: 0xF2F7FE),
        surface:    Color(hex: 0xE3E9F4),
        foreground: Color(hex: 0x394E6A),
        secondary:  Color(hex: 0x021431),
        accent:     Color(hex: 0x0070EF),
        cyan:       Color(hex: 0x94E7FB),
        green:      Color(hex: 0x81CFD1),
        orange:     Color(hex: 0xEFD7BC),
        pink:       Color(hex: 0x463AA2),
        red:        Color(hex: 0xE58B8B),
        yellow:     Color(hex: 0xC148AC)
    )

    static let dim = AppTheme(
        id: "dim", name: "Dim", isDark: true,
        background: Color(hex: 0x2A303C),
        sidebar:    Color(hex: 0x242933),
        surface:    Color(hex: 0x20252E),
        foreground: Color(hex: 0xB2CCD6),
        secondary:  Color(hex: 0x1C212B),
        accent:     Color(hex: 0x9FE88D),
        cyan:       Color(hex: 0x28EBFF),
        green:      Color(hex: 0x62EFBD),
        orange:     Color(hex: 0xEFD057),
        pink:       Color(hex: 0xFF7D5D),
        red:        Color(hex: 0xFFAE9B),
        yellow:     Color(hex: 0xC792E9)
    )

    static let nordLight = AppTheme(
        id: "nord-light", name: "Nord Light", isDark: false,
        background: Color(hex: 0xECEFF4),
        sidebar:    Color(hex: 0xE5E9F0),
        surface:    Color(hex: 0xD8DEE9),
        foreground: Color(hex: 0x2E3440),
        secondary:  Color(hex: 0x4C566A),
        accent:     Color(hex: 0x5E81AC),
        cyan:       Color(hex: 0xB48EAD),
        green:      Color(hex: 0xA3BE8D),
        orange:     Color(hex: 0xEBCB8B),
        pink:       Color(hex: 0x81A1C1),
        red:        Color(hex: 0xBF616A),
        yellow:     Color(hex: 0x88C0D0)
    )

    static let sunset = AppTheme(
        id: "sunset", name: "Sunset", isDark: true,
        background: Color(hex: 0x121C22),
        sidebar:    Color(hex: 0x0E171E),
        surface:    Color(hex: 0x091319),
        foreground: Color(hex: 0x9FB9D0),
        secondary:  Color(hex: 0x1B262C),
        accent:     Color(hex: 0xFF865B),
        cyan:       Color(hex: 0x89E0EB),
        green:      Color(hex: 0xADDFAD),
        orange:     Color(hex: 0xF1C892),
        pink:       Color(hex: 0xFD6F9C),
        red:        Color(hex: 0xFFBBBD),
        yellow:     Color(hex: 0xB387FA)
    )

    static let caramelLatte = AppTheme(
        id: "caramel-latte", name: "Caramel Latte", isDark: false,
        background: Color(hex: 0xFFF7ED),
        sidebar:    Color(hex: 0xFEECD3),
        surface:    Color(hex: 0xFFD6A7),
        foreground: Color(hex: 0x7C2808),
        secondary:  Color(hex: 0xC33D00),
        accent:     Color(hex: 0x000000),
        cyan:       Color(hex: 0x193AB7),
        green:      Color(hex: 0x005F45),
        orange:     Color(hex: 0xF6B900),
        pink:       Color(hex: 0x360A00),
        red:        Color(hex: 0xFF6266),
        yellow:     Color(hex: 0x8C3F27)
    )

    static let abyss = AppTheme(
        id: "abyss", name: "Abyss", isDark: true,
        background: Color(hex: 0x001A1E),
        sidebar:    Color(hex: 0x000E11),
        surface:    Color(hex: 0x000405),
        foreground: Color(hex: 0xFFD6A7),
        secondary:  Color(hex: 0x00353C),
        accent:     Color(hex: 0xC2FD00),
        cyan:       Color(hex: 0x00B9FA),
        green:      Color(hex: 0x01DF72),
        orange:     Color(hex: 0xFFC326),
        pink:       Color(hex: 0xCEBEF4),
        red:        Color(hex: 0xF04E4F),
        yellow:     Color(hex: 0x505050)
    )

    static let silk = AppTheme(
        id: "silk", name: "Silk", isDark: false,
        background: Color(hex: 0xF7F5F3),
        sidebar:    Color(hex: 0xF3EDE9),
        surface:    Color(hex: 0xE2DDD9),
        foreground: Color(hex: 0x4B4743),
        secondary:  Color(hex: 0x161616),
        accent:     Color(hex: 0x1C1C29),
        cyan:       Color(hex: 0x7CC8FF),
        green:      Color(hex: 0xAFD89E),
        orange:     Color(hex: 0xEFC375),
        pink:       Color(hex: 0x1C1C29),
        red:        Color(hex: 0xFF8482),
        yellow:     Color(hex: 0x1C1C29)
    )
}

// MARK: - Theme Manager

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var current: AppTheme {
        didSet {
            UserDefaults.standard.set(current.id, forKey: "selectedTheme")
        }
    }

    private init() {
        let savedID = UserDefaults.standard.string(forKey: "selectedTheme") ?? "dracula"
        current = AppTheme.all.first { $0.id == savedID } ?? .dracula
    }

    func select(_ theme: AppTheme) {
        current = theme
    }
}
