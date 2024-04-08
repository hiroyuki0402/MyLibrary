import Foundation

extension Date {

    /// 日本のデバイス時刻を表すDateFormatterを返す
    var jpDeviceDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }

    /// デバイスの現在の時刻を表すDateFormatterを返す
    var deviceDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }


    /// 指定された日付フォーマットに基づいて、日付をフォーマット
    /// - Parameter dateFormat: 日付フォーマット
    /// - Returns: フォーマットされた日付文字列
    func makeFormat(dateFormat: JPDateFormat) -> String {
        let deviceDateFormatter = self.deviceDateFormatter
        deviceDateFormatter.dateFormat = dateFormat.rawValue
        let dateFormatter = deviceDateFormatter.string(from: self)
        return dateFormatter
    }
    
    /// 指定された日付文字列を、日本の日付フォーマットに変換。
    ///
    /// この関数は、入力された日付文字列を解析し、指定された出力フォーマットに従って
    /// 日本のロケールに適した日付文字列に変換を行う。変換は、入力と出力のフォーマット、
    /// およびロケール識別子に基づいて行われる
    ///
    /// - Parameters:
    ///   - dateString: 変換対象の日付文字列
    ///   - inputFormat: 入力された日付文字列のフォーマットを指定(IUデフォルトは`.iso8601`)
    ///   - outputFormat: 出力される日付文字列のフォーマットを指定します(デフォルトは`.dateOnly`)
    ///   - inputLocaleID: 入力された日付文字列のロケール識別子を指定しま(デフォルトは`.enUSPOSIX`)
    ///   - outputLocaleID: 出力される日付文字列のロケール識別子を指定します(デフォルトは`.jaJP`)
    ///
    /// - Returns: 指定されたフォーマットとロケールに基づいて変換された日付文字列を返す
    ///   変換に成功した場合は変換後の文字列を、失敗した場合は空文字列("")を返す
    ///
    /// 使用例：
    /// ```
    /// let inputDateString = "2023-12-04"
    /// let formattedDateString = DateFormatter.toCustomDateString(from: inputDateString,
    ///                                                            inputFormat: .iso8601,
    ///                                                            outputFormat: .fullAndTime,
    ///                                                            inputLocaleID: .enUSPOSIX,
    ///                                                            outputLocaleID: .jaJP)
    /// print(formattedDateString) // "2023年12月4日 00時00分"
    /// ```
    static func toCustomDateString(from dateString: String,
                                   inputFormat: JPDateFormat = .iso8601,
                                   outputFormat: JPDateFormat = .dateOnly,
                                   inputLocaleID: LocaleIdentifier = .enUSPOSIX,
                                   outputLocaleID: LocaleIdentifier = .jaJP) -> String {
        
        /// 入力フォーマットに基づき、DateFormatterを設定
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat.rawValue
        inputFormatter.locale = Locale(identifier: inputLocaleID.rawValue)
        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }

        /// 出力フォーマットに基づき、DateFormatterを設定
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat.rawValue
        outputFormatter.locale = Locale(identifier: outputLocaleID.rawValue)
        return outputFormatter.string(from: date)
    }
}

/// 日付フォーマットを表す列挙型
enum JPDateFormat: String {
    case iso8601 = "yyyy-MM-dd"
    case fullAndTime = "yyyy年MM月dd日 HH時mm分"
    case fullDateOnly = "yyyy年MM月dd日"
    case dateOnly = "dd日 HH時mm分"
    case dayofweek = ""
}

/// Locale
enum LocaleIdentifier: String {
    case enUSPOSIX = "en_US_POSIX"
    case jaJP = "ja_JP"
    case enUS = "en_US"
    case enGB = "en_GB"
    case frFR = "fr_FR"
    case deDE = "de_DE"
    case itIT = "it_IT"
    case esES = "es_ES"
    case zhHans = "zh_Hans"
    case zhHant = "zh_Hant"
}
