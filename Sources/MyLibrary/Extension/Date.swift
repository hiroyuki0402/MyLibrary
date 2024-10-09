import Foundation

public extension Date {

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

    /// 年の値を取得するプロパティ
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// 月の値を取得するプロパティ
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    /// 日の値を取得するプロパティ
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// 昨日の日付を取得するプロパティ
    var yesterday: Date? {
        let day = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return day
    }

    /// 明日の日付を取得するプロパティ
    var tomorrow: Date? {
        let day = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return day
    }

    /// 1週間前の日付を取得するプロパティ
    var oneWeekBefore: Date? {
        let day = Calendar.current.date(byAdding: .day, value: -7, to: self)
        return day
    }

    /// 1週間後の日付を取得するプロパティ
    var oneWeekAfter: Date? {
        let day = Calendar.current.date(byAdding: .day, value: 7, to: self)
        return day
    }

    /// 1ヶ月前の日付を取得するプロパティ
    var oneMonthBefore: Date? {
        let day = Calendar.current.date(byAdding: .month, value: -1, to: self)
        return day
    }

    /// 1ヶ月後の日付を取得するプロパティ
    var oneMonthAfter: Date? {
        let day = Calendar.current.date(byAdding: .month, value: 1, to: self)
        return day
    }

    /// 1年前の日付を取得するプロパティ
    var oneYearBefore: Date? {
        let day = Calendar.current.date(byAdding: .year, value: -1, to: self)
        return day
    }

    /// 1年後の日付を取得するプロパティ
    var oneYearAfter: Date? {
        let day = Calendar.current.date(byAdding: .year, value: 1, to: self)
        return day
    }

    /// 月の初日を取得するプロパティ
    var beginningOfTheMonth: Date? {
        let component = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: component)
    }

    /// 月の最終日を取得するプロパティ
    var endOfTheMonth: Date? {
        if let beginningOfTheMonth = self.beginningOfTheMonth {
            let add = DateComponents(month: 1, day: -1)
            return Calendar.current.date(byAdding: add, to: beginningOfTheMonth)
        }
        return nil
    }

    /// 年の初日を取得するプロパティ
    var beginningOfTheYear: Date? {
        let component = Calendar.current.dateComponents([.year], from: self)
        return Calendar.current.date(from: component)
    }

    /// 年の最終日を取得するプロパティ
    var endOfTheYear: Date? {
        if let beginningOfTheYear = self.beginningOfTheYear {
            let add = DateComponents(year: 1, day: -1)
            return Calendar.current.date(byAdding: add, to: beginningOfTheYear)
        }
        return nil
    }

    /// 曜日のインデックス（0: 日曜, 1: 月曜, ...）を取得するプロパティ
    var weekDayIndex: Int? {
        guard let weekday = (Calendar.current as NSCalendar)
            .components( .weekday, from: self)
            .weekday else { return nil }
        return weekday - 1
    }

    /// 曜日を取得するプロパティ
    var weekDay: WeekDay? {
        if let weekDayIndex = weekDayIndex, let weekDay = WeekDay(rawValue: weekDayIndex) {
            return weekDay
        }
        return nil
    }

    /// 日曜日かどうかを判定するプロパティ
    var isSunday: Bool {
        return weekDay == .sunday
    }

    /// 月曜日かどうかを判定するプロパティ
    var isMonday: Bool {
        return weekDay == .monday
    }

    /// 火曜日かどうかを判定するプロパティ
    var isTuesday: Bool {
        return weekDay == .tuesday
    }

    /// 水曜日かどうかを判定するプロパティ
    var isWednesday: Bool {
        return weekDay == .wednesday
    }

    /// 木曜日かどうかを判定するプロパティ
    var isThursday: Bool {
        return weekDay == .thursday
    }

    /// 金曜日かどうかを判定するプロパティ
    var isFriday: Bool {
        return weekDay == .friday
    }

    /// 土曜日かどうかを判定するプロパティ
    var isSaturday: Bool {
        return weekDay == .saturday
    }

    /// 指定秒数前の日付を取得する
    /// - Parameter second: 秒数
    /// - Returns: 指定秒数前の日付
    func secondBefore(_ second: Int) -> Date? {
        let day = Calendar.current.date(byAdding: .second, value: -second, to: self)
        return day
    }

    /// 指定秒数後の日付を取得する
    /// - Parameter second: 秒数
    /// - Returns: 指定秒数後の日付
    func secondAfter(_ second: Int) -> Date? {
        let day = Calendar.current.date(byAdding: .second, value: second, to: self)
        return day
    }

    /// 指定分前の日付を取得する
    /// - Parameter minute: 分数
    /// - Returns: 指定分前の日付
    func minuteBefore(_ minute: Int) -> Date? {
        let day = Calendar.current.date(byAdding: .minute, value: -minute, to: self)
        return day
    }

    /// 指定分後の日付を取得する
    /// - Parameter minute: 分数
    /// - Returns: 指定分後の日付
    func minuteAfter(_ minute: Int) -> Date? {
        let day = Calendar.current.date(byAdding: .minute, value: minute, to: self)
        return day
    }

    /// 指定時間前の日付を取得する
    /// - Parameter hour: 時間
    /// - Returns: 指定時間前の日付
    func hourBefore(_ hour: Int) -> Date? {
        let day = Calendar.current.date(byAdding: .hour, value: -hour, to: self)
        return day
    }

    /// 指定時間後の日付を取得する
    /// - Parameter hour: 時間
    /// - Returns: 指定時間後の日付
    func hourAfter(_ hour: Int) -> Date? {
        let day = Calendar.current.date(byAdding: .hour, value: hour, to: self)
        return day
    }

    /// 当日の開始時刻を取得する
    var startTime: Date? {
        return Calendar.current.startOfDay(for: self)
    }
}

/// 日付フォーマットを表す列挙型
public enum JPDateFormat: String {
    case iso8601 = "yyyy-MM-dd"
    case fullAndTime = "yyyy年MM月dd日 HH時mm分"
    case fullDateOnly = "yyyy年MM月dd日"
    case dateOnly = "dd日 HH時mm分"
    case dayofweek = ""
}

/// Locale
public enum LocaleIdentifier: String {
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

/// 曜日
public enum WeekDay: Int {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
}
