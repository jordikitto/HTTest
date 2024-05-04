//
//  LaunchableState.swift
//
//
//  Created by Jordi Kitto on 15/3/2024.
//

import Foundation

/// Defines state that can be provided to a ``LaunchableEnvironment``.
public protocol LaunchableState: Codable {}

public extension LaunchableState {
    static var environmentVariable: String { "UITEST_LAUNCH_STATE" }
    
    func encoded() -> String {
        try! String(data: JSONEncoder().encode(self), encoding: .utf8)!
    }
    
    static func from(string: String) -> Self {
        try! JSONDecoder().decode(self.self, from: string.data(using: .utf8)!)
    }
}
