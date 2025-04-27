#if canImport(UIKit)
extension UIApplication {
    /// SafeAreaのinsets
    static var safeAreaInsets: UIEdgeInsets {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        return keyWindow?.safeAreaInsets ?? .zero
    }

    /// 下部（ホームインジケータ部のSafeArea高さ
    static var safeAreaBottom: CGFloat {
        safeAreaInsets.bottom
    }

    /// 上部（ノッチやステータスバー部のSafeArea高さ
    static var safeAreaTop: CGFloat {
        safeAreaInsets.top
    }

    /// ステータスバーの高さ
    static var statusBarHeight: CGFloat {
        if let statusBarFrame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame {
            return statusBarFrame.height
        } else {
            /// iOS13未満用
            return UIApplication.shared.statusBarFrame.height
        }
    }

    /// ホームバー（インジケータ）があるかどうか（iPhone X以降判定）
    static var hasHomeIndicator: Bool {
        safeAreaInsets.bottom > 0
    }
}
#endif
