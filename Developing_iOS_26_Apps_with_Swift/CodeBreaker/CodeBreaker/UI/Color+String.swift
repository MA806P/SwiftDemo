//
//  Color+String.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/25.
//

import SwiftUI

extension Color {
    
    
    init?(hex: String) {
        let hexStr = hex.trimmingCharacters(in:.whitespacesAndNewlines).uppercased()
        guard hexStr.hasPrefix("#") && hexStr.count == 9 else { return nil }
        let scanner = Scanner(string: String(hexStr.dropFirst()))
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        let red = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
        let green = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
        let blue = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
        let opacity = CGFloat(hexNumber & 0x000000FF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0
        
        let uiColor = UIColor(self)
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &opacity)
            
        let intRed = Int(red * 255)
        let intGreen = Int(green * 255)
        let intBlue = Int(blue * 255)
        let intOpacity = Int(opacity * 255)
        return String(format: "#%02X%02X%02X%02X", intRed, intGreen, intBlue, intOpacity)
    }
    
    
}



