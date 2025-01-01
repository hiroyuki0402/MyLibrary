import Foundation

// MARK: - HTTPSレスポンスのステータスコードチェック
public struct StatusCodeValidator {
    private let validRange: ClosedRange<Int>

    /// 初期化
    /// - Parameter validRange: 正常なステータスコードの範囲（デフォルトは 200～299）
    public init(validRange: ClosedRange<Int> = 200...299) {
        self.validRange = validRange
    }

    /// ステータスコードを検証
    /// - Parameters:
    ///   - statusCode: 検証対象のステータスコード
    ///   - data: レスポンスデータ（必要に応じてエラーデータとして利用可能）
    /// - Throws: 範囲外の場合はエラーをスロー
    public func validate(statusCode: Int, data: Data?) throws {
        guard validRange.contains(statusCode) else {
            throw NetworkError.codeValidatoeError(StatusCodeValidatorError.unexpectedStatusCode(statusCode: statusCode, data: data))
        }
    }
}


