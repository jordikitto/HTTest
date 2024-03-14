//
//  TestDefaults.swift
//
//
//  Created by Jordi Kitto on 15/3/2024.
//

import Foundation

enum TestDefaults {
    /// 80 seconds
    static let massiveWaitTimeoutValue: TimeInterval = 80.0
    /// 40 seconds
    static let extraLongWaitTimeoutValue: TimeInterval = 40.0
    /// 20 seconds
    static let longWaitTimeoutValue: TimeInterval = 20.0
    /// 10 seconds
    static let mediumWaitTimeoutValue: TimeInterval = 10
    /// 5 seconds
    static let shortWaitTimeoutValue: TimeInterval = 5.0
    static let invertedExpectationTimeoutValue: TimeInterval = 2.0
}
