import Foundation

public struct APIURLSession {

    private let session: URLSession
    private let contentType: ContentType

    // MARK: -  ライフサイクル
    /// - Parameter contentType: Content-Typeの設定（デフォルトはJSON）
    public init(contentType: ContentType = .json) {
        self.contentType = contentType

        /// URLSessionConfigurationの作成
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": contentType.rawValue]
        self.session = URLSession(configuration: config)
    }

    // MARK: -  メソッド

    /// リクエストを処理するためのデータタスクを提供
    /// - Parameters:
    ///   - request: HTTPリクエスト
    ///   - completionHandler: レスポンスの処理を行うクロージャ
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completionHandler)
    }

    /// 非同期でリクエストを処理
    /// - Parameter request: HTTPリクエスト
    /// - Returns: レスポンスデータとレスポンス
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }

    /// セッションを無効化し、リクエストをキャンセル
    public func invalidateAndCancel() {
        session.invalidateAndCancel()
    }
}

