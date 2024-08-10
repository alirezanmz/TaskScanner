//
//  CodingUserInfoKey+Context.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Foundation

// Extension to add a custom key for passing context information in JSON decoding.
extension CodingUserInfoKey {
    // Custom key to store and retrieve the Core Data context or other context information.
    static let context = CodingUserInfoKey(rawValue: "context")
}
