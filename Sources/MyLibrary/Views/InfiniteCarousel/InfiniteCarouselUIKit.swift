import SwiftUI
#if canImport(UIKit)
import UIKit
/// SwiftUI から UIKit セルを使って構成する汎用カルーセルビュー
///
/// InfiniteCarouselUIKit は、SwiftUI 上から UIKit の UICollectionViewCell を利用した
/// 横スクロール形式のカルーセル UI を表示できるラッパービュー
///
/// 内部的には UIKit の UICollectionView を使用しており、
/// セルは UICollectionViewCellをベースに構築されるため、
///
/// - UIKit セルを使いたい場合は、cellProvider を指定して初期化する
///
/// ## 利用例（UIKit セルを使用）
/// ```swift
/// InfiniteCarouselUIKit(items: myData, selection: $currentItem) { collectionView, indexPath, item in
///     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
///     cell.configure(with: item)
///     return cell
/// }
/// ```
///
/// - Note: 内部では InfiniteCarouselController<Item> を用いて、
///         無限スクロール風の動きやスナップ挙動、中心アイテムの自動検知などを実現している
public struct InfiniteCarouselUIKit<Item>: UIViewControllerRepresentable {

    // MARK: - プロパティー

    /// 表示するアイテム一覧
    private let items: [Item]

    /// 選択中のアイテム（中央に表示されている要素）
    @Binding private var selection: Item

    /// 表示するカードの幅（0.0〜1.0、例：0.75 = 画面幅の75%）
    private let cardWidthRatio: CGFloat

    /// スクロールの挙動（ページング、フリースクロール等）
    private let scrollMode: UICollectionLayoutSectionOrthogonalScrollingBehavior

    /// UIKit ベースのセルを構成するクロージャ（UICollectionView を使用）
    private let cellProvider: (UICollectionView, IndexPath, Item) -> UICollectionViewCell

    // MARK: - ライフサイクル

    /// 初期化処理（UIKit セル向け）
    ///
    /// - Parameters:
    ///   - items: カルーセルに表示する要素の配列
    ///   - selection: 現在選択されているアイテム（中央表示）
    ///   - cardWidthRatio: 各カードの幅比率（例：0.8 = 画面の80%）
    ///   - scrollMode: スクロール形式（例：.groupPagingCentered）
    ///   - cellProvider: セル構成クロージャ（UICollectionViewCell を返す）
    public init(
        items: [Item],
        selection: Binding<Item>,
        cardWidthRatio: CGFloat = 0.75,
        scrollMode: UICollectionLayoutSectionOrthogonalScrollingBehavior = .groupPagingCentered,
        cellProvider: @escaping (UICollectionView, IndexPath, Item) -> UICollectionViewCell
    ) {
        self.items = items
        self._selection = selection
        self.cardWidthRatio = cardWidthRatio
        self.scrollMode = scrollMode
        self.cellProvider = cellProvider
    }

    // MARK: - UIViewControllerRepresentable

    /// カルーセル用の UIViewController を構築
    /// - Parameter context: 表示コンテキスト
    /// - Returns: カルーセル表示用のコントローラ
    public func makeUIViewController(context: Context) -> UIViewController {
        InfiniteCarouselController(
            items: items,
            cardWidthRatio: cardWidthRatio,
            scrollMode: scrollMode,
            onPageChanged: { selection = $0 },
            cellProvider: cellProvider
        )
    }

    /// UIViewController の更新処理（今回は不要なため未実装）
    /// - Parameters:
    ///   - vc: 対象のビューコントローラ
    ///   - context: SwiftUI からの更新情報
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
#endif
