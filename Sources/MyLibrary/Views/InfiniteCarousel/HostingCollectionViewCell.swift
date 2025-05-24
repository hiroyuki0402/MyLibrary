import SwiftUI
#if canImport(UIKit)
import UIKit

/// SwiftUI View を UICollectionView のセル内に表示するための汎用セルクラス
///
/// このクラスは、SwiftUI で構築した UI コンポーネントをUICollectionViewのセルとして表示する際に使用する
///
/// セルの再利用にも対応しており、複数回のrootView差し替えにも動作するよう設計していて
/// contentView全体に SwiftUI Viewを配置し、マージンのないフルサイズ表示を行う
public final class HostingCollectionViewCell: UICollectionViewCell {

    public static let reuseIdentifier: String = "HostingCollectionViewCell"

    /// セルが再利用されるたびに毎回追加されることを防ぐため、
    /// 初回追加時にインスタンスを保持しておき、次回以降はrootViewの差し替えのみ行う
    private var legacyHost: UIHostingController<AnyView>?

    /// SwiftUI View をセルのコンテンツとして表示する
    ///
    /// 指定されたSwiftUI ViewをこのセルのcontentView全体に対して表示する
    /// iOS のバージョンに応じて表示方法が異なる
    ///
    /// - iOS16以降はUIHostingConfigurationを使用してコンテンツを設定(マージンはすべて 0 に設定される)
    /// - iOS13〜15はUIHostingControllerを使用し、AutoLayout を使って四辺をピン留めする
    ///
    /// すでにホストが存在する場合には、それを使いまわしrootViewのみを差し替える
    ///
    /// - Parameter rootView: セルに表示したい SwiftUI の View を指定
    public func set<Content: View>(rootView: Content) {
        if #available(iOS 16.0, *) {
            /// iOS16以降:  UIHostingConfigurationを使用し、余白なしで表示
            let config = UIHostingConfiguration {
                rootView
            }
            .margins(.all, 0)
            contentConfiguration = config

            /// fallback用に保持していたホストを解放
            legacyHost = nil
        } else {
            /// iOS13〜15はUIHostingControllerを使用して表示
            if let host = legacyHost {
                /// 既にホストが存在する場合は再利用してrootViewを差し替え
                host.rootView = AnyView(rootView)
            } else {
                /// 初回の場合はUIHostingController を生成しAutoLayoutで四辺を固定
                let host = UIHostingController(rootView: AnyView(rootView))
                host.view.translatesAutoresizingMaskIntoConstraints = false
                host.view.backgroundColor = .clear

                contentView.addSubview(host.view)

                NSLayoutConstraint.activate([
                    host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                    host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                ])

                legacyHost = host
            }
        }
    }
}
#endif
