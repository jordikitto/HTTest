//
//  LaunchableEnvironment.swift
//
//
//  Created by Jordi Kitto on 26/3/2024.
//

import Foundation

/// Defines a configurable launch environment that is based on a specific ``LaunchState``.
protocol LaunchableEnvironment {
    associatedtype State: LaunchableState
    
    func apply(_ state: State)
}

extension LaunchableEnvironment {
    static var isRunningUITests: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment.keys.contains(State.environmentVariable)
        #else
        return false
        #endif
    }
    
    func prepareForUITestsIfNeeded() {
        #if DEBUG
        guard Self.isRunningUITests,
              let stateString = ProcessInfo.processInfo.environment[State.environmentVariable]
        else { return }
        
        let launchState = State.from(string: stateString)
        apply(launchState)
        #endif
    }
}
