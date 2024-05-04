//
//  ScreenStateBuilder.swift
//  
//
//  Created by Jordi Kitto on 15/3/2024.
//

import Foundation

@resultBuilder
/// Makes `ScreenState` definitions composable. Example usage within an `AppScreen`:
/// ```
/// @ScreenStateBuilder
/// var successState: [State] {
///     commonState
///     State.isEqual(\.statusLabel.label, "Success")
/// }
///
/// @ScreenStateBuilder
/// var errorState: [State] {
///     commonState
///     State.isEqual(\.statusLabel.label, "Error")
/// }
///
/// @ScreenStateBuilder
/// var commonState: [State] {
///     State.isEqual(\.navigationBar.label, "My Content")
///     State.willBeHittable(\.statusLabel)
/// }
/// ```
public struct ScreenStateBuilder {
    public static func buildBlock<Screen: AppScreen>(_ components: [ScreenState<Screen>]...) -> [ScreenState<Screen>] {
        components.flatMap { $0 }
    }
    
    public static func buildExpression<Screen: AppScreen>(_ expression: ScreenState<Screen>) -> [ScreenState<Screen>] {
        [expression]
    }
    
    public static func buildExpression<Screen: AppScreen>(_ expression: [ScreenState<Screen>]) -> [ScreenState<Screen>] {
        expression
    }
}
