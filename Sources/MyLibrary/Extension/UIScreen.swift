#if canImport(UIKit)
import UIKit

extension UIScreen {

    /// 今アクティブなウィンドウ（WindowScene）から実際に表示されてる画面を取得
    /// iPadのマルチウィンドウにも対応できる
    static var current: UIScreen? {
        UIApplication.shared.connectedScenes
            /// UIWindowScene だけ抜き出す（AppExtension対策も兼ねて）
            .compactMap { $0 as? UIWindowScene }
            /// 今前面でアクティブな画面だけに絞る
            .first(where: { $0.activationState == .foregroundActive })?
            .screen
    }

    /// 画面の横幅
    static var width: CGFloat {
        current?.bounds.width ?? 0
    }

    /// 画面の高さ
    static var height: CGFloat {
        current?.bounds.height ?? 0
    }
}

#endif

