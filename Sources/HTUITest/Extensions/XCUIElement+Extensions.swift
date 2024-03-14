//
//  XCUIElement+Extensions.swift
//  
//
//  Created by Jordi Kitto on 15/3/2024.
//

import Foundation
import XCTest

extension XCUIElement {
    
    /// .hasFocus refers to to the tvOS focus engine as in invalid to use for iOS testing.
    /// Use this on an XCUIElement of a text field to check if has focus.
    var hasKeyboardFocus: Bool {
        value(forKey: "hasKeyboardFocus") as? Bool ?? false
    }
    
    var doesNotExist: Bool {
        !exists
    }
    
    @discardableResult
    func whenHittable(
        timeout: TimeInterval = TestDefaults.shortWaitTimeoutValue,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        wait(for: \.isHittable, timeout: timeout, file: file, line: line)
        return self
    }
    
    func wait(
        for keyPath: KeyPath<XCUIElement, Bool>,
        timeout: TimeInterval = TestDefaults.shortWaitTimeoutValue,
        function: StaticString = #function,
        file: StaticString,
        line: UInt
    ) {
        guard !self[keyPath: keyPath] else { return } // No need to wait if we don't need to wait!
        let result = XCTWaiter().wait(
            for: [
                XCTNSPredicateExpectation(
                    predicate: NSPredicate { [unowned self] _, _ in self[keyPath: keyPath] },
                    object: nil
                )
            ],
            timeout: timeout
        )
        switch result {
        case .completed: return
        default: XCTFail("\(identifier) failed check \(function)", file: file, line: line)
        }
    }
    
    /// Use this method to clear existing string value
    /// - Warning: should only be used on Textfield element to clear current input value
    func clearText() {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
}
