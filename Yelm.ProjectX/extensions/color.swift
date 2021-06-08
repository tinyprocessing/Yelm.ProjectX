//
//  color.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 28.04.2021.
//


import Foundation
import SwiftUI
import UIKit

//BLWH-r
extension Color {
    static let neuBackground = Color("Background")
    static let theme_black_change = Color("BLWH")
    static let theme_black_change_reverse = Color("BLWH-r")
    static let dropShadow = Color("Dark")
    static let dropLight = Color("Light")
    static var theme = Color.init(hex: "5DC837")
    static var theme_foreground = Color.white
    static var theme_tooltips = Color.black
    static var tooltips = Color.init(hex: "E5E7E9")
    static var theme_catalog = Color.init(hex: "FFFFFF")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}


extension Color {
    
    func uiColor() -> UIColor {
        
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }
        
        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
    
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
