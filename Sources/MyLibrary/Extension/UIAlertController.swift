import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if canImport(UIKit)
public extension UIAlertController {
    /// UIAlertActionを追加する拡張メソッド
    /// - Parameters:
    ///   - title: ボタンのタイトル
    ///   - style: ボタンのスタイル
    ///   - action: ボタンが押された時のアクション
    /// - Returns: UIAlertController自身
    func addAction(title: String, style: UIAlertAction.Style, action: (() -> Void)? = nil) -> Self {
        addAction(UIAlertAction(title: title, style: style, handler: { _ in action?() }))
        return self
    }
}
#endif
