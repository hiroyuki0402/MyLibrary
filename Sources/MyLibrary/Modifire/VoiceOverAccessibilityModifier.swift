import SwiftUI

/// `VoiceOverAccessibilityModifier` は、SwiftUIのビューに対して
/// VoiceOver 用のアクセシビリティ情報を設定するための `ViewModifier`.
///
/// - Overview:
///   このModifierでは、`label`・`hint`・`traits`・`hidden` をまとめて指定することで、
///   ユーザーが VoiceOver を利用してビューにフォーカスした際に読み上げる内容や操作ヒント、
///   さらに「読み上げ対象から外す」設定などを一括制御
///
/// - Parameters:
///   - label: ビューにフォーカスが当たった際に読み上げる文字列
///   - hint: 追加の操作説明や補足説明
///   - traits: 「ボタン」「見出し」などの特別な役割を示すための `AccessibilityTraits`
///   - hidden: `true` にすると、VoiceOver からこのビューを隠し、読み上げ対象外にする
///
/// - Note:
///   - `label` や `hint` は実際の画面上のテキストではなく、音声ガイド用 に使われる説明文
///   - `traits` には `.isButton` や `.isHeader` などを指定することで、
///     スワイプ移動時の音声フィードバック(「ボタン」等)を追加可能
///   - `hidden` に `true` を指定すると、画面には表示されていても VoiceOver の読み上げリストから除外されるため、
///     「視覚には見せたいが音声説明は不要」といったケース
///
/// - Example:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         VStack {
///             Text("ユーザー名:")
///                 .modifier(VoiceOverAccessibilityModifier(
///                     label: "名前入力欄のラベル",
///                     hint: "ダブルタップで編集を開始してください",
///                     traits: .isHeader
///                 ))
///
///             TextField("例) 佐藤太郎", text: $userName)
///                 .modifier(VoiceOverAccessibilityModifier(
///                     label: "名前入力フィールド",
///                     hint: "ここにお名前を入力してください"
///                 ))
///
///             Button("登録") {
///                 /// 登録処理
///             }
///             .modifier(VoiceOverAccessibilityModifier(
///                 label: "登録ボタン",
///                 hint: "ダブルタップで入力内容を送信",
///                 traits: .isButton
///             ))
///         }
///     }
/// }
/// ```
public struct VoiceOverAccessibilityModifier: ViewModifier {

    /// ビューに対して読み上げるラベル(テキスト)
    private let label: String?

    /// 操作説明など補足的に読み上げるヒント
    private let hint: String?

    /// ボタンや見出しなどのアクセシビリティ特性
    private let traits: AccessibilityTraits?

    /// `true` の場合、このビューをVoiceOverの対象から隠す
    /// (画面には表示されるが、音声ガイドには含まれなくなる)
    private let hidden: Bool

    // MARK: - 初期化

    /// VoiceOverAccessibilityModifier のイニシャライザ
    ///
    /// - Parameters:
    ///   - label: フォーカス時に読み上げるテキスト
    ///   - hint: 追加の操作説明や補足
    ///   - traits: ボタンなどの特別な役割を示すトレイト
    ///   - hidden: ビューをVoiceOver対象外にするかどうか
    public init(label: String? = nil,
                hint: String? = nil,
                traits: AccessibilityTraits? = nil,
                hidden: Bool = false) {
        self.label = label
        self.hint = hint
        self.traits = traits
        self.hidden = hidden
    }

    // MARK: - body
    /// Modifier適用後に実際にビューへ反映される処理
    ///
    /// - Parameter content: Modifierを適用する元のView
    /// - Returns: VoiceOver設定を付与したView
    public func body(content: Content) -> some View {
        content
            /// VoiceOver対象から隠すかどうか
            .accessibility(hidden: hidden)

            /// ラベル(読み上げる文言)
            .accessibilityLabel(label ?? "")

            /// ヒント(操作説明)
            .accessibilityHint(hint ?? "")

            /// トレイト
            .accessibilityAddTraits(traits ?? [])
    }
}
