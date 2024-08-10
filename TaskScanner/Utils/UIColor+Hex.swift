//
//  UIColor+Hex.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Foundation
import UIKit

// Extension to initialize UIColor with a hexadecimal color code string.
extension UIColor {
    // Initializes UIColor from a hex string with optional alpha.
    convenience init?(hexString: String) {
        var hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        // Ensure hex string is either 6 or 8 characters long, adding alpha if needed.
        if hex.count == 6 {
            hex = "FF" + hex  // Default alpha to 1.0 if not provided.
        } else if hex.count != 8 {
            return nil  // Invalid hex string length.
        }

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)  // Convert hex string to UInt64.
        
        // Extract color components.
        let a = (int & 0xFF000000) >> 24
        let r = (int & 0x00FF0000) >> 16
        let g = (int & 0x0000FF00) >> 8
        let b = int & 0x000000FF
        
        // Initialize UIColor with extracted components.
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
