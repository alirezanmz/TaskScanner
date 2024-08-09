//
//  UIColor+Hex.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        var hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.count == 6 {
            hex = "FF" + hex  // Add alpha if not provided
        } else if hex.count != 8 {
            return nil
        }

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        a = (int & 0xFF000000) >> 24
        r = (int & 0x00FF0000) >> 16
        g = (int & 0x0000FF00) >> 8
        b = int & 0x000000FF
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
