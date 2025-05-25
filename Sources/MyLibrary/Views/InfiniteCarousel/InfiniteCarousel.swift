import SwiftUI
#if canImport(UIKit)
import UIKit

/// SwiftUI から利用可能な汎用カルーセルビュー（UIKit ベース）
///
/// `InfiniteCarousel` は、内部で `UICollectionView` を利用して構築された
/// 横スクロール型のカルーセル UI を SwiftUI 上で簡単に利用するためのラッパーです。
///
/// 無限スクロール風の挙動、中央スナップ表示、カード間の余白調整などを標準で備えており、
/// 表示するセルは任意の SwiftUI View として自由にカスタマイズ可能です。
///
/// - Note: 内部的には UIHostingConfiguration（iOS 16 以降）
///         もしくはUIHostingController（iOS 13〜15）を用いて、
///         SwiftUI View を UICollectionViewCell に表示している
///
/// ## 利用例
/// ```swift
/// InfiniteCarousel(items: myData, selection: $selectedItem) { item in
///     MyCardView(item: item)
/// }
/// ```
///
public struct InfiniteCarousel<Item, Cell: View>: UIViewControllerRepresentable {

    // MARK: - プロパティー

    /// 表示するアイテム一覧
    private let items: [Item]

    /// 選択中のアイテム（中央に表示されている要素）
    @Binding private(set) public var selection: Item

    /// 表示するカードの幅（0.0〜1.0、例：0.75 = 画面幅の75%）
    private let cardWidthRatio: CGFloat

    /// スクロールの挙動（ページング、フリースクロール等）
    private let scrollMode: UICollectionLayoutSectionOrthogonalScrollingBehavior

    private let cellViewProvider: (Item) -> Cell

    /// カードの高さ
    private var cardHeight: CGFloat = 0

    // MARK: - ライフサイクル

    public init(
        items: [Item],
        selection: Binding<Item>,
        cardWidthRatio: CGFloat = 0.75,
        cardHeight: CGFloat = 200,
        scrollMode: UICollectionLayoutSectionOrthogonalScrollingBehavior = .groupPagingCentered,
        @ViewBuilder cellView: @escaping (Item) -> Cell
    ) {
        self.items = items
        self._selection = selection
        self.cardWidthRatio = cardWidthRatio
        self.scrollMode = scrollMode
        self.cellViewProvider = cellView
        self.cardHeight = cardHeight
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
            cellView: cellViewProvider
        )
    }

    /// UIViewController の更新処理（今回は不要なため未実装）
    /// - Parameters:
    ///   - vc: 対象のビューコントローラ
    ///   - context: SwiftUI からの更新情報
    public func updateUIViewController(_ vc: UIViewController, context: Context) {
        guard let controller = vc as? InfiniteCarouselController<Item> else { return }
        controller.updateSelection(selection)
    }
}
#endif
