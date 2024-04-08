import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct HideTabBarModifier: ViewModifier {
    // MARK: - プロパティ
    
    var isHidden: Bool
    
    /// ViewModifierの本体を構築
    ///
    /// `body`関数内で、このModifierが適用されたViewのタブバー表示を設定
    /// Viewが表示される際（`.onAppear`）、
    /// アプリケーションのキーウィンドウの`tabBarController`のタブバーの表示状態を
    /// `isHidden`プロパティに基づいて設定する
    ///
    /// - Parameter content: このModifierが適用される元のView
    /// - Returns: Modifierが適用された後のView
    /// - SeeAlso: `View.hideTabBar(_:)`
    func body(content: Content) -> some View {
        content
            .onAppear {
#if canImport(UIKit)
                /// アクティブなウィンドウシーンを取得し、キーウィンドウを探す
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .compactMap { $0 as? UIWindowScene }
                    .first?.windows
                    .filter { $0.isKeyWindow }.first
                /// キーウィンドウのrootViewControllerがtabBarControllerであれば、
                /// そのタブバーの表示状態を変更する
                keyWindow?.rootViewController?.tabBarController?.tabBar.isHidden = isHidden
#endif
            }
        
    }
}
