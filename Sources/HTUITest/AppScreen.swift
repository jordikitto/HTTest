//
//  AppScreen.swift
//
//
//  Created by Jordi Kitto on 14/3/2024.
//

import Foundation
import XCTest

/// Defines a screen in the app.
public protocol AppScreen {
    associatedtype App: LaunchableApp
    
    /// Reference to the app being tested
    var app: App { get }
    
    /// Elements unique to this screen, used to identify that the screen has appeared
    var commonState: [State] { get }
    
    init(app: App)
}

// MARK: - Additional Behaviour

public extension AppScreen {
    typealias State = ScreenState<Self>
    
    /// Taps on `element` and returns the next screen that appears.
    func expectNextScreen<NextScreen: AppScreen>(
        file: StaticString = #file,
        line: UInt = #line
    ) -> NextScreen where NextScreen.App == App {
        let nextScreen = NextScreen(app: app)
        AssertScreenState(nextScreen, \.commonState, file: file, line: line)
        return nextScreen
    }
}

// MARK: - Querying Helpers

public extension AppScreen {
    func tab(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.tabBars.buttons.matching(identifier: identifier).element(atIndex: index)
    }
    
    func button(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.buttons.matching(identifier: identifier).element(atIndex: index)
    }
    
    func textField(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.textFields.matching(identifier: identifier).element(atIndex: index)
    }
    
    func textView(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.textViews.matching(identifier: identifier).element(atIndex: index)
    }
    
    func scrollView(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.scrollViews.matching(identifier: identifier).element(atIndex: index)
    }
    
    func table(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.tables.matching(identifier: identifier).element(atIndex: index)
    }
    
    func collectionView(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.collectionViews.matching(identifier: identifier).element(atIndex: index)
    }

    func staticText(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.staticTexts.matching(identifier: identifier).element(atIndex: index)
    }
    
    func webViews(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.webViews.matching(identifier: identifier).element(atIndex: index)
    }
    
    func other(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.otherElements.matching(identifier: identifier).element(atIndex: index)
    }
    
    func image(_ identifier: String, atIndex index: Int = 0) -> XCUIElement {
        app.app.images.matching(identifier: identifier).element(atIndex: index)
    }
}

extension XCUIElementQuery {
    func element(atIndex index: Int) -> XCUIElement {
        if index == 0 {
            // In theory, firstMatch *could* be faster
            return firstMatch
        } else {
            return element(boundBy: index)
        }
    }
}
