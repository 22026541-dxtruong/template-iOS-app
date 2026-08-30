import SwiftUI
import UIKit

extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }

    init(rgb: UInt32, alpha: Double = 1.0) {
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }

    // MARK: - App Theme Colors
    static let primary = Color(light: .blue, dark: .blue)
    static let secondary = Color(light: .gray, dark: Color(uiColor: .lightGray))
    static let background = Color(light: .white, dark: .black)
    static let surface = Color(light: Color(uiColor: .lightGray), dark: Color(uiColor: .darkGray))

}