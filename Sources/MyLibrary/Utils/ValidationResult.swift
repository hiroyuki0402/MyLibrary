/// データ検証を行うためのモジュール
///
/// 正規表現を使った汎用的な検証から、パスワードの形式を確認するためのバリデータ
/// メールアドレスや電話番号、URLといった入力形式を簡単に検証するユーティリティが含まれている
///
/// 検証時にメッセージをカスタマイズしたい場合は、引数の `errorWords` を利用して
/// 独自のエラーメッセージを上書きすることが可能（実装によってはそのまま使用しないものもある）
///
/// - Important:
///   - バリデーション結果は `ValidationResult` を通して返され、`isValid` が `true` であれば成功、
///     `false` であれば何らかのバリデーションエラーを含むことを示す
///   - 詳細なエラー理由を伝えたい場合は `ValidationResult.log` にメッセージを格納する
///   - 例外が発生する可能性がある実装（正規表現の評価など）の場合は `ValidationResult.error` に
///     `Error` オブジェクトが入る可能性がある
///
/// - Example:
/// ```swift
/// /// メールアドレスの形式を検証
/// let emailValidator = Validators.email
/// let emailResult = emailValidator.validate("test@example.com")
/// print(emailResult.isValid)   →    // true (有効なメールアドレス)
/// print(emailResult.log ?? "")  →   // "検証成功: test@example.com" など
///
/// /// パスワードの形式を検証（エラーメッセージをカスタマイズする例）
/// let passwordValidator = Validators.password
/// let passwordResult = passwordValidator.validate("WeakPass", errorWords: "パスワード要件を満たしていない")
/// print(passwordResult.isValid)  →  // false (強度が足りない場合)
/// print(passwordResult.log ?? "") → // "パスワード要件を満たしていない"（カスタムメッセージ）
///
/// /// 任意の正規表現で検証できるカスタムValidatorを生成
/// let customValidator = Validators.customRegex(pattern: "^[A-Z]{3}\\d{2}$")
/// let customResult = customValidator.validate("ABC12", errorWords: "フォーマットが違う")
/// print(customResult.isValid)   →   // true (定義したパターンに合致する場合)
/// print(customResult.log ?? "")  →  // "検証成功: ABC12" など
/// ```


import Foundation

/// バリデーションを表すプロトコル
public protocol Validator {
    associatedtype Input

    /// 入力値を検証
    /// - Parameters:
    ///   - input: 検証対象の値
    ///   - errorWords: エラーメッセージをカスタマイズする場合に使用
    /// - Returns: 検証結果を表す `ValidationResult`
    func validate(_ input: Input, errorWords: String) -> ValidationResult
}

/// バリデーション結果を表す構造体
public struct ValidationResult {

    /// 検証が成功したかどうか
    public let isValid: Bool

    /// 検証の結果に関するログメッセージ
    public let log: String?

    /// 検証中に発生したエラー（エラーがない場合は`nil`）
    public let error: Error?

    /// バリデーション結果を初期化
    /// - Parameters:
    ///   - isValid: 検証が成功したかどうか
    ///   - log: 検証の結果に関するログメッセージ
    ///   - error: 検証中に発生したエラー
    public init(isValid: Bool, log: String?, error: Error?) {
        self.isValid = isValid
        self.log = log
        self.error = error
    }
}

/// 正規表現を使用した汎用バリデータ
public struct RegexValidator: Validator {
    public typealias Input = String
    private let pattern: String

    /// 正規表現バリデータを初期化
    /// - Parameter pattern: 検証に使用する正規表現パターン
    public init(pattern: String) {
        self.pattern = pattern
    }

    /// 入力値を正規表現で検証
    /// - Parameter input: 検証対象の文字列
    /// - Returns: 検証結果を表す `ValidationResult`
    public func validate(_ input: String, errorWords: String) -> ValidationResult {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: input.utf16.count)
            let isMatch = regex.firstMatch(in: input, options: [], range: range) != nil

            return ValidationResult(
                isValid: isMatch,
                log: isMatch ? "検証成功: \(input)" : "検証失敗: 入力形式が正しくありません: \(input)",
                error: nil
            )
        } catch {
            return ValidationResult(
                isValid: false,
                log: "正規表現の評価中にエラーが発生しました: \(input)",
                error: error
            )
        }
    }
}

/// パスワード用バリデータ
public struct PasswordValidator: Validator {
    public typealias Input = String

    /// パスワードの最小文字数
    private let minLength: Int

    /// 大文字を必須とするかどうか
    private let requiresUppercase: Bool

    /// 小文字を必須とするかどうか
    private let requiresLowercase: Bool

    /// 数字を必須とするかどうか
    private let requiresNumber: Bool

    /// 記号を必須とするかどうか
    private let requiresSpecialCharacter: Bool

    /// 記号の正規表現パターン
    private let specialCharacterPattern = "[!@#$%^&*(),.?\":{}|<>]"

    /// パスワードバリデータを初期化
    /// - Parameters:
    ///   - minLength: パスワードの最小文字数
    ///   - requiresUppercase: 大文字を必須とするかどうか
    ///   - requiresLowercase: 小文字を必須とするかどうか
    ///   - requiresNumber: 数字を必須とするかどうか
    ///   - requiresSpecialCharacter: 記号を必須とするかどうか
    public init(minLength: Int = 8, requiresUppercase: Bool = true, requiresLowercase: Bool = true, requiresNumber: Bool = true, requiresSpecialCharacter: Bool = true) {
        self.minLength = minLength
        self.requiresUppercase = requiresUppercase
        self.requiresLowercase = requiresLowercase
        self.requiresNumber = requiresNumber
        self.requiresSpecialCharacter = requiresSpecialCharacter
    }

    /// パスワードの形式を検証
    /// - Parameters:
    ///   - input: 検証対象のパスワード
    ///   - errorWords: エラーメッセージを上書きする場合に指定
    /// - Returns: 検証結果を表す `ValidationResult`
    public func validate(_ input: String, errorWords: String = "") -> ValidationResult {
        var errors: [String] = []

        /// パスワードの長さを検証
        if input.count < minLength {
            let errorWord = errorWords.isEmpty ? "パスワードは最低\(minLength)文字必要です": errorWords
            errors.append(errorWord)
        }

        /// 大文字の有無を検証
        if requiresUppercase && input.range(of: "[A-Z]", options: .regularExpression) == nil {
            let errorWord = errorWords.isEmpty ? "パスワードには少なくとも1つの大文字が必要です": errorWords
            errors.append(errorWord)
        }

        /// 小文字の有無を検証
        if requiresLowercase && input.range(of: "[a-z]", options: .regularExpression) == nil {
            let errorWord = errorWords.isEmpty ? "パスワードには少なくとも1つの小文字が必要です": errorWords
            errors.append(errorWord)
        }

        /// 数字の有無を検証
        if requiresNumber && input.range(of: "[0-9]", options: .regularExpression) == nil {
            let errorWord = errorWords.isEmpty ? "パスワードには少なくとも1つの数字が必要です": errorWords
            errors.append(errorWord)
        }

        /// 記号の有無を検証
        if requiresSpecialCharacter && input.range(of: specialCharacterPattern, options: .regularExpression) == nil {
            let errorWord = errorWords.isEmpty ? "パスワードには少なくとも1つの記号が必要です（例: !, @, #, $）": errorWords
            errors.append(errorWord)
        }

        if errors.isEmpty {
            return ValidationResult(
                isValid: true,
                log: "パスワードは有効です",
                error: nil
            )
        } else {
            return ValidationResult(
                isValid: false,
                log: errors.joined(separator: "\n"),
                error: nil
            )
        }
    }
}

/// メール、電話番号、URL、パスワード用のバリデータを提供するユーティリティ
public struct Validators {

    /// メールアドレス形式を検証するバリデータ
    public static let email = RegexValidator(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")

    /// 電話番号形式を検証するバリデータ
    public static let phone = RegexValidator(pattern: "^[0-9]{10,15}$")

    /// URL形式を検証するバリデータ
    public static let url = RegexValidator(pattern: "^(https?|ftp)://[^\\s/$.?#].[^\\s]*$")

    /// パスワード形式を検証するバリデータ
    public static let password = PasswordValidator()

    // MARK: - カスタムValidator生成

    /// 任意の正規表現パターンで検証するカスタムバリデータを生成
    /// - Parameter pattern: 正規表現パターン
    /// - Returns: `RegexValidator`
    public static func customRegex(pattern: String) -> RegexValidator {
        return RegexValidator(pattern: pattern)
    }

    /// パスワード検証の条件をカスタマイズして生成するバリデータ
    /// - Parameters:
    ///   - minLength: 最小文字数
    ///   - requiresUppercase: 大文字必須フラグ
    ///   - requiresLowercase: 小文字必須フラグ
    ///   - requiresNumber: 数字必須フラグ
    ///   - requiresSpecialCharacter: 記号必須フラグ
    /// - Returns: `PasswordValidator`
    public static func customPassword(
        minLength: Int = 8,
        requiresUppercase: Bool = true,
        requiresLowercase: Bool = true,
        requiresNumber: Bool = true,
        requiresSpecialCharacter: Bool = true
    ) -> PasswordValidator {
        return PasswordValidator(
            minLength: minLength,
            requiresUppercase: requiresUppercase,
            requiresLowercase: requiresLowercase,
            requiresNumber: requiresNumber,
            requiresSpecialCharacter: requiresSpecialCharacter
        )
    }
}

