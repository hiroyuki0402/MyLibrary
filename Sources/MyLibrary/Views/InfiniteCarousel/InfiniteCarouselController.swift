import SwiftUI
#if canImport(UIKit)
import UIKit

/// 汎用的な UIKit ベースの横スクロールカルーセルコンポーネント
///
/// InfiniteCarouselControllerは、UICollectionViewを利用した横スクロール形式のカルーセル UI を構築するための汎用ビューコントローラ
/// 中央に1枚のカードを常時表示し、左右には前後のカードを部分的に見せる構成となっている
///
/// 特徴として、アイテムを仮想的に拡張して扱うことで、無限スクロールのような事を再現
/// また、ページングスナップやセル再利用にも対応
///
/// 表示するセルの構成は、呼び出し時に指定する CellProviderクロージャによって柔軟に制御でき、
/// SwiftUI の View を埋め込む構成にも対応している（iOS 13 以降対応）
///
/// - Note:
///   初回表示時はアイテムリストの中央から開始され、
///   スクロール位置が端に近づいた場合には、目に見えないタイミングで中央位置へ再配置される
public final class InfiniteCarouselController<Item>: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Public Types

    /// 各セルの表示処理を構成するための型エイリアス
    ///
    /// 呼び出し元から UICollectionViewIndexPath、アイテムそのものを引数として受け取り、
    /// 対応する UICollectionViewCellを返すクロージャ型
    public typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell

    // MARK: - プロパティー

    /// 表示対象となるオリジナルのアイテム配列
    private let items: [Item]

    /// 各カードの表示幅に対する比率
    private let cardWidthRatio: CGFloat

    /// セル構成を呼び出し側で指定できるようにするためのクロージャ
    private let cellProvider: CellProvider

    /// カルーセル表示用の UICollectionView インスタンス
    private var collectionView: UICollectionView!

    /// 疑似的な無限スクロールを実現するために用いるアイテムの複製回数
    private let loopCount: Int

    /// 実際に使用されるアイテムの拡張配列
    private var expanded: [Item] {
        Array(repeating: items, count: loopCount).flatMap { $0 }
    }

    /// 中央開始位置のインデックス
    private var midIndex: Int {
        items.count * loopCount / 2
    }

    /// 初回中央スクロール実行済みかどうかを示すフラグ
    private var didCenterOnce = false

    /// スクロール形式
    private var scrollMode: UICollectionLayoutSectionOrthogonalScrollingBehavior = .paging

    /// 中央カードが切り替わったタイミングで呼ばれる
    private let onPageChanged: (Item) -> Void


    /// Layout Configuration
    private var lastOffsetX: CGFloat = .greatestFiniteMagnitude
    private var lastSettledOffsetX: CGFloat = 0
    private var stillFrames: Int = 0
    private let settleFrames: Int = 4
    private var pageWidth: CGFloat = 0
    private var lastLogical: Int = 0

    // MARK: - 初期化

    /// 初期化処理（UIKit セル向け）
    ///
    /// - Parameters:
    ///   - items: 表示対象となるアイテム配列を指定
    ///   - cardWidthRatio: 表示する各カードの横幅比率（例：0.75 = 画面の75%）
    ///   - cellProvider: 各セルを構築するためのクロージャを指定
    public init(
        items: [Item],
        cardWidthRatio: CGFloat = 0.75,
        loopCount: Int = 1001,
        scrollMode: UICollectionLayoutSectionOrthogonalScrollingBehavior = .paging,
        onPageChanged: @escaping (Item) -> Void = { _ in },
        cellProvider: @escaping CellProvider) {
        self.items = items
        self.cardWidthRatio = cardWidthRatio
        self.loopCount = loopCount
        self.onPageChanged = onPageChanged
        self.cellProvider = cellProvider
        self.scrollMode = scrollMode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    /// ビュー構築後に UICollectionView を初期化・配置
    public override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    /// レイアウト完了後、初回のみ中央インデックス位置へスクロール
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didCenterOnce else { return }
        didCenterOnce = true
        collectionView.scrollToItem(
            at: .init(item: midIndex, section: 0),
            at: .centeredHorizontally,
            animated: false
        )

        notifyCenterItem()
    }

    // MARK: - メソッド

    /// カスタム Compositional Layout を生成
    ///
    /// 各カードの幅を `cardWidthRatio` に基づいて設定し、
    /// 中央寄せスナップ挙動と、左右の余白（前後カードのチラ見せ）を構成する。
    ///
    /// - Returns: 構成済みの `UICollectionViewCompositionalLayout`
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalHeight(1))
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(cardWidthRatio),
                              heightDimension: .absolute(200)),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = scrollMode

        section.interGroupSpacing = 16

        let side = (1 - cardWidthRatio) / 2 * UIScreen.main.bounds.width
        section.contentInsets = .init(
            top: 0,
            leading: side,
            bottom: 0,
            trailing: side
        )

        section.visibleItemsInvalidationHandler = { [weak self] items, offset, _ in
            guard let self else { return }
            if self.pageWidth == 0, let cardW = items.first?.frame.width {
                self.pageWidth = cardW + section.interGroupSpacing
                self.lastSettledOffsetX = offset.x
                return
            }

            guard self.pageWidth > 0 else { return }
            let moved = offset.x - self.lastSettledOffsetX
            let movedPages = Int((moved - (moved > 0 ? -20 : 20)) / self.pageWidth)

            guard movedPages != 0 else { return }

            for _ in 0..<abs(movedPages) {
                self.lastLogical = (self.lastLogical + (movedPages > 0 ? 1 : -1) + self.items.count) % self.items.count
                self.onPageChanged(self.items[self.lastLogical])
            }

            self.lastSettledOffsetX += CGFloat(movedPages) * self.pageWidth
        }

        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .horizontal
        return layout
    }

    /// スクロール後に端に近づいていた場合、中央位置に瞬間的にリセンター
    ///
    /// 無限スクロール風の見た目を維持するため、
    /// 配列の前後25%領域に入った時点で中央セットへスクロールする。
    private func recenterIfNeeded() {
        guard let first = collectionView.indexPathsForVisibleItems.first else { return }
        let oneSet = items.count, loop = loopCount, idx = first.item
        let threshold = oneSet * loop / 4

        if idx < threshold || idx >= oneSet * (loop - loop / 4) {
            let corrected = (idx % oneSet) + oneSet * loop / 2
            collectionView.scrollToItem(
                at: .init(item: corrected, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }

    /// 画面中央に最も近いアイテムを計算してハンドラへ連携
    private func notifyCenterItem() {
        let centerPoint = view.convert(view.center, to: collectionView)
        guard let idxPath = collectionView.indexPathForItem(at: centerPoint) else { return }
        let logical = idxPath.item % items.count
        onPageChanged(items[logical])
    }

    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        expanded.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = expanded[indexPath.item % items.count]
        return cellProvider(collectionView, indexPath, item)
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        recenterIfNeeded()
        notifyCenterItem()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        recenterIfNeeded()
        notifyCenterItem()
    }
}

// MARK: - SwiftUI View対応イニシャライザ

extension InfiniteCarouselController {

    /// SwiftUI View をセルとして扱うための初期化処理
    ///
    /// `ViewBuilder` によって構築された SwiftUI View を内部的に `UICollectionViewCell` に埋め込んで表示する。
    /// 使用されるホスティング方式は、iOS16 以降では `UIHostingConfiguration`、
    /// iOS13〜15 では `UIHostingController` を利用する。
    ///
    /// - Parameters:
    ///   - items: 表示するアイテムの配列
    ///   - cardWidthRatio: カードの横幅比率（0.0〜1.0）
    ///   - cellView: 各アイテムを SwiftUI View として描画するための ViewBuilder クロージャ
    convenience init<Content: View>(
        items: [Item],
        cardWidthRatio: CGFloat = 0.75,
        loopCount: Int = 1001,
        scrollMode: UICollectionLayoutSectionOrthogonalScrollingBehavior = .paging,
        onPageChanged: @escaping (Item) -> Void = { _ in },
        @ViewBuilder cellView: @escaping (Item) -> Content
    ) {
        self.init(
            items: items,
            cardWidthRatio: cardWidthRatio,
            loopCount: loopCount,
            scrollMode: scrollMode,
            onPageChanged: onPageChanged,
            cellProvider: { collectionView, indexPath, item in

                /// 登録
                collectionView.register(
                    HostingCollectionViewCell.self,
                    forCellWithReuseIdentifier: HostingCollectionViewCell.identifier
                )

                /// セル構築
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HostingCollectionViewCell.identifier,
                    for: indexPath
                ) as? HostingCollectionViewCell
                cell?.set(rootView: cellView(item))
                cell?.layer.cornerRadius = 12
                cell?.layer.masksToBounds = true
                return cell ?? UICollectionViewCell()
            }
        )
    }
}
#endif
