//
//  ScreenState.swift
//
//
//  Created by Jordi Kitto on 14/3/2024.
//

import Foundation
import XCTest

/// Defines the state of an element on a screen
public struct ScreenState<Screen: AppScreen> {
    let validator: (Screen, StaticString, UInt) -> Void
    
    /// Ensures the screen contains the given component.
    public static func containsComponent<S: AppScreen>(_ keyPath: KeyPath<Screen, S>) -> ScreenState {
        .init { screen, file, line in
            let componentScreen = screen[keyPath: keyPath]
            AssertScreenState(componentScreen, \.commonState)
        }
    }
    
    /// Ensures the value at `keyPath` is equal to `value`.
    public static func isEqual<T: Equatable>(_ keyPath: KeyPath<Screen, T>, _ value: @autoclosure @escaping () -> T) -> ScreenState {
        .init { screen, file, line in
            XCTAssertEqual(screen[keyPath: keyPath], value(), file: file, line: line)
        }
    }
    
    /// Ensures the `Any?` value at `keyPath` is equal to `value`.
    ///
    /// Primarly used to support testing against `XCUIElement.value`, which is of `Any?` type.
    public static func isEqual<T: Equatable>(_ keyPath: KeyPath<Screen, Any?>, _ value: @autoclosure @escaping () -> T) -> ScreenState {
        .init { screen, file, line in
            let screenValue = screen[keyPath: keyPath]
            guard let typedScreenValue = screenValue as? T else {
                XCTFail("Unable to convert \(String(describing: screenValue)) to same type as \(value())")
                return
            }
            XCTAssertEqual(typedScreenValue, value(), file: file, line: line)
        }
    }
    
    public static func isMatching<T: XCUIElement>(_ keyPath: KeyPath<Screen, T>, _ predicate: @autoclosure @escaping () -> NSPredicate) -> ScreenState {
        .init { screen, file, line in
            let result = predicate().evaluate(with: screen[keyPath: keyPath])
            XCTAssertTrue(result, file: file, line: line)
        }
    }
    
    /// Ensures the value at `keyPath` is current hittable.
    public static func isHittable(_ keyPath: KeyPath<Screen, XCUIElement>) -> ScreenState {
        .init { screen, file, line in
            let element = screen[keyPath: keyPath]
            XCTAssertTrue(element.isHittable, "\(element.identifier) was not hittable", file: file, line: line)
        }
    }
    
    /// Ensures the value at `keyPath` becomes hittable before `timeout` seconds passes.
    public static func willBeHittable(_ keyPath: KeyPath<Screen, XCUIElement>, timeout: TimeInterval = TestDefaults.shortWaitTimeoutValue) -> ScreenState {
        .init { screen, file, line in
            screen[keyPath: keyPath].wait(for: \.isHittable, timeout: timeout, file: file, line: line)
        }
    }
    
    /// Ensures the value at `keyPath` exists before `timeout` seconds passes.
    public static func willExist(_ keyPath: KeyPath<Screen, XCUIElement>, timeout: TimeInterval = TestDefaults.shortWaitTimeoutValue) -> ScreenState {
        .init { screen, file, line in
            screen[keyPath: keyPath].wait(for: \.exists, timeout: timeout, file: file, line: line)
        }
    }
    
    /// Ensures the value at `keyPath` gets removed before `timeout` seconds passes.
    public static func willNotExist(_ keyPath: KeyPath<Screen, XCUIElement>, timeout: TimeInterval = TestDefaults.shortWaitTimeoutValue) -> ScreenState {
        .init { screen, file, line in
            screen[keyPath: keyPath].wait(for: \.doesNotExist, timeout: timeout, file: file, line: line)
        }
    }
    
    public static func isEnabled(_ keyPath: KeyPath<Screen, XCUIElement>, timeout: TimeInterval = TestDefaults.immediateTimeOutValue) -> ScreenState {
        .init { screen, file, line in
            screen[keyPath: keyPath].wait(for: \.isEnabled, timeout: timeout, file: file, line: line)
        }
    }
    
    public static func isDisabled(_ keyPath: KeyPath<Screen, XCUIElement>) -> ScreenState {
        .init { screen, file, line in
            let element = screen[keyPath: keyPath]
            XCTAssertFalse(element.isEnabled, "\(element.identifier) was not disabled", file: file, line: line)
        }
    }
    
    /// Ensures the value at `keyPath` is `true`.
    public static func isTrue(_ keyPath: KeyPath<Screen, Bool>) -> ScreenState {
        .init { screen, file, line in
            XCTAssertTrue(screen[keyPath: keyPath], "\(keyPath) was not 'true'", file: file, line: line)
        }
    }
    
    /// Ensures the value at `keyPath` is `false`.
    public static func isFalse(_ keyPath: KeyPath<Screen, Bool>) -> ScreenState {
        .init { screen, file, line in
            XCTAssertFalse(screen[keyPath: keyPath], "\(keyPath) was not 'false'", file: file, line: line)
        }
    }
    
    public static func willHaveKeyboardFocus(_ keyPath: KeyPath<Screen, XCUIElement>) -> ScreenState {
        .init { screen, file, line in
            screen[keyPath: keyPath].wait(for: \.hasKeyboardFocus, timeout: TestDefaults.shortWaitTimeoutValue, file: file, line: line)
        }
    }
    
    public static func doesNotExist(_ keyPath: KeyPath<Screen, XCUIElement>) -> ScreenState {
        .init { screen, file, line in
            XCTAssertFalse(screen[keyPath: keyPath].exists, "\(keyPath) exists", file: file, line: line)
        }
    }
    
    // When we eventually want to do Snapshot Testing, we can define another function here!
}

/// Asserts that a `screen` matches it's state definition defined at the path `state`.
public func AssertScreenState<Screen: AppScreen>(
    _ screen: Screen,
    _ state: KeyPath<Screen, [ScreenState<Screen>]>,
    file: StaticString = #file,
    line: UInt = #line
) {
    screen[keyPath: state].forEach {
        $0.validator(screen, file, line)
    }
}
