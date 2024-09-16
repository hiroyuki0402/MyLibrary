import Foundation

#if canImport(UIKit)
import UIKit
#endif

public extension String {
    
    /// 文字列を整数に変換し、指定された範囲内にあるかどうかを判断する
    ///
    /// このメソッドは文字列を`Int`に変換しようと試み、変換が成功した場合にのみ、
    /// 範囲チェックを行います。変換に失敗した場合や、値が指定された範囲外の場合は`false`を返する
    ///
    /// - Parameter range: `ClosedRange<Int>`型で指定される範囲
    ///   例えば`1...31`を渡すと、1から31の間の整数のみを`true`になる
    ///
    /// - Returns: 文字列が指定された整数の範囲内にある場合は`true`、そうでない場合は`false`
    ///   文字列が整数に変換できない場合も`false`を返却
    ///
    /// 使用例:
    /// ```
    /// let stringValue = "23"
    /// let isWithinRange = stringValue.isInteger(in: 1...31) // trueを返す
    /// ```
    func isInteger(in range: ClosedRange<Int>) -> Bool {
        guard let intValue = Int(self) else { return false }
        return range.contains(intValue)
    }
    
    /// この文字列を指定されたフォーマットの日付文字列に変換
    ///
    /// 入力された日付文字列を解析し、指定された出力フォーマットに従って変換
    /// この変換プロセスでは、入力と出力の日付フォーマットおよび
    /// ロケール識別子を基に変換が行われる
    ///
    /// - Parameters:
    ///   - inputFormat: 入力された日付文字列のフォーマットを指定(IUデフォルトは`.iso8601`)
    ///   - outputFormat: 出力される日付文字列のフォーマットを指定します(デフォルトは`.dateOnly`)
    ///   - inputLocaleID: 入力された日付文字列のロケール識別子を指定しま(デフォルトは`.enUSPOSIX`)
    ///   - outputLocaleID: 出力される日付文字列のロケール識別子を指定します(デフォルトは`.jaJP`)
    ///
    /// - Returns: 入力された日付文字列を出力フォーマットに基づいて変換した文字列
    ///   日付の解析に失敗した場合は空文字列("")を返す
    ///
    /// 使用例：
    /// ```
    /// let inputDateString = "2023-12-04"
    /// let formattedDateString = inputDateString.toCustomDateString(
    ///     inputFormat: .iso8601,
    ///     outputFormat: .fullAndTime,
    ///     inputLocaleID: .enUSPOSIX,
    ///     outputLocaleID: .jaJP)
    /// print(formattedDateString) // 出力: "2023年12月04日 00時00分"
    /// ```
    func toCustomDateString(inputFormat: JPDateFormat = .iso8601,
                            outputFormat: JPDateFormat = .dateOnly,
                            inputLocaleID: LocaleIdentifier = .enUSPOSIX,
                            outputLocaleID: LocaleIdentifier = .jaJP) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat.rawValue
        inputFormatter.locale = Locale(identifier: inputLocaleID.rawValue)

        guard let date = inputFormatter.date(from: self) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat.rawValue
        outputFormatter.locale = Locale(identifier:outputLocaleID.rawValue)
        return outputFormatter.string(from: date)
    }
    
#if canImport(UIKit)
    /// 文字列内の指定した文字のフォントサイズを変更する
    /// - Parameters:
    ///   - targetText: 変更したい文字列
    ///   - targetFontSize: 変更したいフォント
    /// - Returns: 変更した内容をNSMutableAttributedStringで返却
    func reFontsize(targetText: String, targetFontSize: UIFont, targetColor: UIColor? = nil) -> NSMutableAttributedString {
        
        let fullText = self
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: targetText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.font, value: targetFontSize, range: nsRange)
            
            if let color = targetColor {
                attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
            }
        }
        return attributedString
    }
#endif
}
