//
//  NSPredicate+Extensions.swift
//
//
//  Created by Jordi Kitto on 15/3/2024.
//

import Foundation

extension NSPredicate {
    static func beginsWith(_ prefix: String, field: String = "label") -> NSPredicate {
        .init(format: "\(field) BEGINSWITH %@", prefix)
    }
    
    static var isEnabled: NSPredicate {
        .init(format: "isEnabled == true")
    }
}
