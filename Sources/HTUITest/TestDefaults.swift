//
//  TestDefaults.swift
//
//
//  Created by Jordi Kitto on 15/3/2024.
//

import Foundation

public enum TestDefaults {
    /// 80 seconds
    public static let massiveWaitTimeoutValue: TimeInterval = 80.0
    /// 40 seconds
    public static let extraLongWaitTimeoutValue: TimeInterval = 40.0
    /// 20 seconds
    public static let longWaitTimeoutValue: TimeInterval = 20.0
    /// 10 seconds
    public static let mediumWaitTimeoutValue: TimeInterval = 10
    /// 5 seconds
    public static let shortWaitTimeoutValue: TimeInterval = 5.0
    /// 2 seconds
    public static let invertedExpectationTimeoutValue: TimeInterval = 2.0
}
