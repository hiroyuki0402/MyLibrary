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

    /// 設定値関連
    private var startPoint: UnitPoint = .top
    private var endPoint: UnitPoint = .bottom
    private var center: UnitPoint = .center
    private var startRadius: CGFloat = 0
    private var endRadius: CGFloat = 200

    /// グラデーションを適用するための初期化メソッド
    /// - Parameters:
    ///   - colors: グラデーションに使用する色の配列
    ///   - type: グラデーションのタイプ (`linear`, `radial`, `angular`)
    ///   - startPoint: グラデーションの開始点（線形グラデーション用）
    ///   - center: グラデーションの中心点（放射状および角度グラデーション用）
    ///   - startRadius: グラデーションの開始半径（放射状グラデーション用）
    ///   - endRadius: グラデーションの終了半径（放射状グラデーション用）
    ///   - endPoint: グラデーションの終了点（線形グラデーション用）
    public init(colors: [Color], type: GradientType, startPoint: UnitPoint = .top, center: UnitPoint = .center, startRadius: CGFloat = 0, endRadius: CGFloat = 200, endPoint: UnitPoint = .bottom) {
        self.colors = colors
        self.type = type
        self.startPoint = startPoint
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }


    /// ViewModifierの本体を構築
    /// - Parameter content: このModifierが適用される元のView
    /// - Returns: Modifierが適用された後のView
    public func body(content: Content) -> some View {
        switch type {
        case .linear:
            return AnyView(content.background(LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)))
        case .radial:
            return AnyView(content.background(RadialGradient(gradient: Gradient(colors: colors), center: center, startRadius: startRadius, endRadius: endRadius)))
        case .angular:
            return AnyView(content.background(AngularGradient(gradient: Gradient(colors: colors), center: center)))
        }
    }
}

