import SwiftUI
/// `SwipeActionModifier`は、SwiftUIでスワイプアクションを可能にするViewModifier
/// 任意のラベルビューを表示可能で、スワイプ操作に基づくアクション（例: 削除）を実装
/// スワイプ中に他のアイテムがアクティブになると現在のアイテムのスワイプをリセット
/// ボタンの角丸やスワイプの閾値をカスタマイズ可能
/// 使用例:
/// ```swift
/// Text("Swipe Me")
///     .modifier(SwipeActionModifier(
///         offset: $offset,
///         activeItem: $activeItem,
///         id: "unique_id",
///         threshold: 100,
///         onDelete: { print("Deleted") },
///         label: {
///             Image(systemName: "trash")
///                 .foregroundColor(.white)
///         }
///     ))
/// ```
public struct SwipeActionModifier<Label: View>: ViewModifier {

    /// スワイプ操作によるコンテンツのオフセットを管理
    @Binding public var offset: CGFloat

    /// 現在アクティブなスワイプアイテムを追跡
    @Binding public var activeItem: String?

    /// このアイテムを一意に識別するためのID
    public let id: String

    /// スワイプが確定するための閾値
    public let threshold: CGFloat

    /// スワイプアクションに基づいて実行される削除処理
    public let onDelete: () -> Void

    /// ボタンやコンテンツの角丸を設定
    public let cornerRadius: CGFloat = 8

    /// スワイプアクションのボタンに表示されるカスタムラベル
    public let label: () -> Label

    // MARK: - ボディー

    public func body(content: Content) -> some View {
        ZStack {
            /// スワイプ時に表示される背景ボタン
            HStack {
                Spacer()
                Button(action: onDelete) {
                    label()
                        .padding()
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                }
                .padding(.trailing)
            }

            /// スワイプ可能なコンテンツ
            content
                .background(Color.white)
                .cornerRadius(cornerRadius)
                .shadow(radius: 1)
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            withAnimation {
                                /// 他のアイテムがスワイプ中の場合、このアイテムをアクティブに設定し、スワイプをリセット
                                if activeItem != id {
                                    activeItem = id
                                    offset = 0
                                }
                                /// スワイプ量を計算し、閾値を超えないように調整
                                offset = max(min(gesture.translation.width, 0), -threshold)
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                /// スワイプ位置が閾値を超えた場合、スワイプを確定
                                if offset < -threshold / 2 {
                                    offset = -threshold
                                } else {
                                    /// スワイプが戻された場合、オフセットとアクティブ状態をリセット
                                    offset = 0
                                    if activeItem == id {
                                        activeItem = nil
                                    }
                                }
                            }
                        }
                )
                .onChange(of: activeItem) { oldValue, newValue in
                    withAnimation {
                        /// 他のアイテムがアクティブになった場合、このアイテムのスワイプをリセット
                        if newValue != id {
                            offset = 0
                        }
                    }
                }
        }
    }
}

