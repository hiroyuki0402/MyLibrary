import Foundation
import SwiftUI

/// `WidthSetterModifier`は、SwiftUIのビューの幅を動的に調整するためのViewModifier
/// 指定されたマージンを考慮してビューの幅を調整(タブやメニューアイテムなど、同じ画面内の他の要素のサイズに基づいて動的にサイズを調整する必要がある場面)
///
/// 使用例:
/// ```swift
/// HStack {
///     Text(item.getTitle())
///         .foregroundStyle(.black)
///         .padding(.horizontal, 50)
///         .font(.subheadline)
///         .fontWeight(.bold)
///         /// WidthSetterModifierを適用して、タブの幅を動的に設定
///         .modifier(WidthSetterModifier(width: Binding(
///             get: { self.tabWidths[item, default: 0] },
///             set: { self.tabWidths[item] = $0 }
///         ), margin: 70))
///
///     if selectedTab == item {
///         /// 選択されたタブに下線を表示
///         Rectangle()
///             .foregroundStyle(Color.blue)
///             .frame(width: self.tabWidths[item, default: 0], height: 2)
///     } else {
///         Rectangle()
///             .foregroundStyle(Color.clear)
///             .frame(width: self.tabWidths[item, default: 0], height: 2)
///     }
/// }
/// ```
/// この例では、`WidthSetterModifier`を使用して、タブの幅をユーザーの操作に応じて動的に調整(選択されたタブは青い下線で強調表示され、非選択のタブは透明な下線が表示される)
public struct WidthSetterModifier: ViewModifier {
    /// ViewModifierを使用してビューの幅を動的に調整するためのバインディング変数
    @Binding public var width: CGFloat
    
    /// 幅計算時に考慮するマージン
    public var margin: CGFloat = 0

    // MARK: - ボディ
    /// ViewModifierの本体を構築
    ///
    /// `body`関数内で、GeometryReaderを使用してこのModifierが適用されたViewの幅を取得し、
    /// マージンを引いた値をPreferenceKeyを通じて設定する
    /// Viewが表示される際、PreferenceKeyの値が更新され、バインディング変数`width`に反映される
    ///
    /// - Parameter content: このModifierが適用される元のView
    /// - Returns: Modifierが適用された後のView
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        /// GeometryReaderを使用して取得したViewの幅からマージンを差し引いた値を設定
                        .preference(key: ViewWidthKey.self, value: geometry.size.width - margin)
                }
            )

            /// 新しい幅が計算されたときにバインディング変数`width`を更新
            .onPreferenceChange(ViewWidthKey.self) { newWidth in
                self.width = newWidth
            }

    }
}


public struct ViewWidthKey: PreferenceKey {
    /// PreferenceKeyで管理されるデフォルトの幅
    public static var defaultValue: CGFloat = 0

    /// Viewから送られた幅の値を集約し、最大値を取得
    /// 複数のビューからの値を適切に集約して最大のものを選択する
    ///
    /// - Parameter value: 現在の集約値
    /// - Parameter nextValue: 次の値を提供するクロージャ
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
