#if canImport(UIKit)
import UIKit
#endif

#if canImport(UIKit)
public extension UIView {

    /// 個別のビューに対して、読み上げ情報を一括設定する
    ///
    /// - Parameters:
    ///   - label: ビューにフォーカスした際、読み上げる文言
    ///   - hint: 追加の説明や操作ヒントがあれば設定する
    ///   - traits: ボタンや見出しなど特別な役割 (.button, .header) を指定する場合に設定
    ///   - hidden: `true` にすると、このビューを読み上げ対象外 にする
    ///
    /// - Example:
    ///   ```
    ///   /// ラベルを読み上げ対象に
    ///   nameLabel.applyVoiceOver(
    ///       label: "ユーザー名",
    ///       hint: "ここをダブルタップして入力開始",
    ///       traits: .header
    ///   )
    ///
    ///   /// ラベルを読み上げ対象外に
    ///   nameLabel.applyVoiceOver(
    ///       hidden: true
    ///   )
    ///   ```
    func applyVoiceOver(
        label: String? = nil,
        hint: String? = nil,
        traits: UIAccessibilityTraits? = nil,
        hidden: Bool = false
    ) {
        /// hidden が true なら読み上げ対象外に
        isAccessibilityElement = !hidden

        /// ラベル・ヒントを設定
        accessibilityLabel = label
        accessibilityHint = hint

        /// 特別なトレイトが指定されていれば付与
        if let traits = traits {
            accessibilityTraits = traits
        }
    }

    /// 自身を「アクセシビリティコンテナ」とみなし、指定したサブビューを順番に読み上げさせる
    ///
    /// - Parameters:
    ///   - elements: このコンテナが読み上げ対象として管理したい `UIView` の配列
    ///                配列に追加した順番が、そのままVoiceOverで読み上げられる順番になる
    ///   - hidesContainerItself: `true` の場合、このコンテナ自身を読み上げ対象外にする
    ///     (コンテナ自体を読み上げたい場合は `false` を指定し、別途`isAccessibilityElement = true` や `accessibilityLabel`を設定する)
    ///
    /// - Important:
    ///   - `elements` に含まれるサブビュー(またはそのサブビュー階層)は、必ず
    ///     `isAccessibilityElement = true` や `accessibilityLabel` 等を前もって設定しておく必要がある
    ///   - VoiceOver は最初にこのコンテナへフォーカスが当たった際、内部要素を
    ///     先頭の `elements[0]` から順に探索して読み上げる
    ///     もし画面遷移後などで「特定の要素から読み上げを開始したい」場合は、
    ///     `UIAccessibility.post(notification: .screenChanged, argument: yourView)` を使って
    ///     フォーカスを当てることも可能
    ///
    /// - `Example:`
    ///
    ///   ```swift
    ///   let label = UILabel()
    ///   label.applyVoiceOver(label: "氏名入力ラベル")
    ///
    ///   let button = UIButton()
    ///   button.applyVoiceOver(label: "確定ボタン", traits: .button)
    ///
    ///   /// containerView内で label -> button の順に読み上げさせたい
    ///   containerView.arrangeAccessibilityElements([label, button])
    ///   ```
    ///
    /// - Note:
    ///   このメソッドは ユーザーが次／前へ移動する際にたどる順序 を明示的に制御したい
    ///   場合に使う
    ///   特にスクロールビューとか複雑なビュー階層だと
    ///   システムの自動解析だけでは意図した順序にならないことがあるため、
    ///   こちらを利用して確実に順番を指定することが可能になる
    func arrangeAccessibilityElements(_ elements: [UIView], hidesContainerItself: Bool = true) {
        /// コンテナ自身を読み上げ要素から外すかどうか
        isAccessibilityElement = !hidesContainerItself

        /// 明示的に読み上げ順序を設定
        accessibilityElements = elements
    }

}
#endif
