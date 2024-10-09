//
//  File.swift
//  MyLibrary
//
//  Created by SHIRAISHI HIROYUKI on 2024/10/08.
//

import SwiftUI

/// SwiftUIビューに指定された種類のグラデーションを適用するためのViewModifier
/// 線形、放射状、または角度のグラデーションをビューの背景に適用することが可能
///
/// 使用例:
/// ```swift
/// Text("Hello, World!")
///     .gradientBackground(type: .linear, colors: [.red, .blue])
///     .frame(width: 200, height: 100)
/// ```
public struct GradientModifier: ViewModifier {
    /// グラデーションの種類を定義する列挙型
    public enum GradientType {
        case linear, radial, angular
    }

    /// グラデーションに使用する色
    private var colors: [Color]

    /// グラデーションのタイプ
    private var type: GradientType

    /// グラデーションを適用するための初期化メソッド
    /// - Parameters:
    ///   - type: グラデーションのタイプ (`linear`, `radial`, `angular`)
    ///   - colors: グラデーションに使用する色の配列
    public init(type: GradientType, colors: [Color]) {
        self.type = type
        self.colors = colors
    }

    /// ViewModifierの本体を構築
    /// - Parameter content: このModifierが適用される元のView
    /// - Returns: Modifierが適用された後のView
    public func body(content: Content) -> some View {
        switch type {
        case .linear:
            return AnyView(content.background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)))
        case .radial:
            return AnyView(content.background(RadialGradient(gradient: Gradient(colors: colors), center: .center, startRadius: 0, endRadius: 200)))
        case .angular:
            return AnyView(content.background(AngularGradient(gradient: Gradient(colors: colors), center: .center)))
        }
    }
}

