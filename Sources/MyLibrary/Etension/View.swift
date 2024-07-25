import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension View {
    /// このViewにカスタムな影を追加
    ///
    /// このメソッドを使用すると、Viewに影を簡単に追加できる
    /// 影の色、ぼかし半径、オフセットのXとYをカスタマイズすることが可能
    ///
    /// - Parameters:
    ///   - color: 影の色を指定
    ///   - radius: 影のぼかしの半径を指定
    ///   - x: 影のオフセットのX値を指定
    ///   - y: 影のオフセットのY値を指定
    ///
    /// - Returns: 影が追加されたView
    ///
    /// - Example:
    /// ```
    /// Text("Hello, SwiftUI!")
    ///     .customShadow(color: .gray, radius: 5, x: 5, y: 5)
    /// ```
    public func addShadow(color: Color = .black, radius: CGFloat = 4, x: CGFloat = 0, y: CGFloat = 2) -> some View {
        self.shadow(color: color, radius: radius, x: x, y: y)
    }

    /// タブバーの表示状態を変更する
    ///
    /// このメソッドを利用することで、タブバーを隠すか表示するかを制御することがで可能
    /// `isHidden`パラメータに`true`を設定すると、タブバーが非表示になる
    /// `false`を設定すると、タブバーが表示される
    ///
    /// - Parameters:
    ///   - isHidden: タブバーを隠すかどうか
    ///
    /// - Returns: タブバーの表示状態が変更されたView
    ///
    /// - Example:
    /// 以下の例では、`HomeView`を表示する際にタブバーを非表示にしている
    /// ```
    /// HomeView()
    ///     .hideTabBar()
    /// ```
    ///
    /// - SeeAlso: `HideTabBarModifier`
    public func hideTabBar(_ isHidden: Bool = true) -> some View {
        self.modifier(HideTabBarModifier(isHidden: isHidden))
    }

    /// このViewにカスタムな区切り線（Divider）を追加
    ///
    /// このメソッドを使用することで、Viewに区切り線を簡単に追加
    /// 区切り線の色、幅、およびオプションで高さをカスタマイズすることが可能
    /// 高さを指定しない場合は、区切り線の高さは自動的に設定
    ///
    /// - Parameters:
    ///   - color: 区切り線の色を指定
    ///   - width: 区切り線の幅を指定
    ///   - height: 区切り線の高さを指定
    ///
    /// - Returns: 区切り線が追加されたView
    ///
    /// - Example:
    ///   以下の例では、幅が100、高さが1の灰色の区切り線をViewに追加
    /// ```
    /// Text("Hello, SwiftUI!")
    ///     .addDivider(color: .gray, width: 100, height: 1)
    /// ```
    public func addDivider(color: Color, width: CGFloat, height: CGFloat? = nil)  -> some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
    }

#if canImport(UIKit)
    /// 特定の角を丸くする
    ///
    /// このメソッドにより、Viewの特定の角にのみ丸みを加えることが可能
    ///
    /// - Parameters:
    ///   - radius: 丸みを適用する半径
    ///   - corners: 丸みを適用する角を指定するUIRectCorner
    ///
    /// - Returns: 指定された角が丸くなったView
    ///
    /// - Example:
    /// ```
    /// Text("Hello, SwiftUI!")
    ///     .cornerRadius(10, corners: [.topLeft, .topRight])
    /// ```
    func customCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
#endif
}


