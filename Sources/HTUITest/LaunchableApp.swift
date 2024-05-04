//
//  LaunchableApp.swift
//
//
//  Created by Jordi Kitto on 3/5/2024.
//

import Foundation
import XCTest
import HTUITestShared

/// Defines an app that can be launch in UI testing.
///
/// Manages launching the app into a specific ``LaunchableState``.
public protocol LaunchableApp {
    associatedtype State: LaunchableState
    
    var app: XCUIApplication { get }
    
    func launch<Screen: AppScreen>(
        in testCase: XCTestCase,
        state: State,
        file: StaticString,
        line: UInt
    ) -> Screen where Screen.App == Self
}

public extension LaunchableApp {
    func launch<Screen: AppScreen>(
        in testCase: XCTestCase,
        state: State,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Screen where Screen.App == Self {
        // Fail fast, if needed
        testCase.continueAfterFailure = false
        
        // Prepare the environment and launch host app
        app.launchEnvironment[State.environmentVariable] = state.encoded()
        app.launch()
        
        // Allow the caller of #function to expect a specific starting screen (based on `state`)
        let screen = Screen(app: self)
        AssertScreenState(screen, \.commonState, file: file, line: line)
        return screen
    }
}
