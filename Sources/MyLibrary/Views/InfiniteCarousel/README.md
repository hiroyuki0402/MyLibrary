# InfiniteCarousel

SwiftUI / UIKit 両対応の汎用カルーセルビューコンポーネント
内部的にUICollectionView + CompositionalLayoutを使い、スナップ付きの横スクロール表示

## 特徴

- SwiftUI View / UIKitのUICollectionViewCell両方に対応
- 中央スナップ・ページネーション挙動
- 無限スクロール風の見た目
- 表示セルの自由なカスタマイズ

## 対応環境

- iOS 13.0+（UIKit モード）
- iOS 16.0+（SwiftUI HostingConfiguration）
- Swift 5.10+

## 使い方
### （SwiftUI View）
```swift
InfiniteCarousel(
    items: MyItem.allCases,
    selection: $selectedItem
) { item in
    MyCardView(item: item)
}
````

### （UIKit セル）
```swift
InfiniteCarouselUIKit(
    items: myItems,
    selection: $selected,
    cellProvider: { collectionView, indexPath, item in
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell {
        cell.configure(with: item)
        return cell
        }
        return UICollectionViewCell()
    }
)
```

### 全体例
```swift
/// UIKItのセルを使用した場合(CollectionViewCell)
struct CarouselExampleUIKit: View {
    @State private var current: SampleItem = .home
    
    var body: some View {
        VStack(spacing: 24) {
            InfiniteCarouselUIKit(
                items: SampleItem.allCases,
                selection: $current,
                cardWidthRatio: 0.8,
                scrollMode: .groupPagingCentered
            ) { collectionView, indexPath, item in

                collectionView
                    .register(StatusCell.self, forCellWithReuseIdentifier: StatusCell.reuseID)

                if let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: StatusCell.reuseID,for: indexPath) as? StatusCell {

                    cell.configure(with: item)
                    return cell
                }
                return UICollectionViewCell()
            }
            .frame(height: 220)

            Text("選択中: \(current.title)")
                .font(.title2.bold())
        }
    }
}

/// SwiftUI
struct CarouselExampleSwiftUI: View {
    @State private var current: SampleItem = .home

    var body: some View {
        VStack(spacing: 24) {
            InfiniteCarousel(
                items: SampleItem.allCases,
                selection: $current,
                cardWidthRatio: 0.8,
                scrollMode: .groupPaging
            ) { item in
                Group {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(item.color)
                        Text(item.title)
                            .font(.title.bold())
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(height: 220)

            Text("選択中: \(current.title)")
                .font(.title2.bold())
        }
    }
}

```



## パラメータ

| パラメータ            | 説明                              | 型                                                      | デフォルト                  | 使用例                                                       |
| ---------------- | ------------------------------- | ------------------------------------------------------ | ---------------------- | --------------------------------------------------------- |
| `items`          | 表示するアイテムの配列                     | `[Item]`                                               | -                      | `MyEnum.allCases`（※`MyEnum: CaseIterable`）                |
| `selection`      | 選択状態のバインディング（選択されたアイテムを親から受け渡す） | `Binding<Item>`                                        | -                      | `$selectedItem`（`@State var selectedItem: MyEnum = .foo`） |
| `cardWidthRatio` | 表示カードの幅（0〜1の割合）                 | `CGFloat`                                              | `0.75`                 | `0.8` → 幅80%になる                                           |
| `scrollMode`     | 横スクロール挙動                        | `UICollectionLayoutSectionOrthogonalScrollingBehavior` | `.groupPagingCentered` | `.paging` `.continuous` など                                |


---

## メンテナンス

* InfiniteCarousel.swift: SwiftUI View 対応
* InfiniteCarouselUIKit.swift: UIKit Cell 対応
* InfiniteCarouselController.swift: 内部ロジック
* HostingCollectionViewCell.swift: SwiftUI→UICollectionViewCell ラップ用

---
