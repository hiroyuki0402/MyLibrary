import Foundation
import Combine

public struct APIResource<T: Codable> {
    public let url: URL?
    public var method: HTTPMethod = .get([])
    public var headers: [String: String]? = nil
    public var modelType: T.Type
    public var normalStatusCode: ClosedRange<Int> = 200...299
}

public class APIManager {
    public static let shared = APIManager()
    private let apiSession: APIURLSession
    private var statusCodeValidator: StatusCodeValidator
    public init(contentType: ContentType = .json, statusCodeValidator: StatusCodeValidator = StatusCodeValidator()) {
        self.apiSession = APIURLSession(contentType: contentType)
        self.statusCodeValidator = statusCodeValidator
    }

    /// 非同期で指定されたURLにHTTPリクエストを送信し、結果をデコードして返す
    /// - Parameters:
    ///   - url: リクエストを送信するURL。nilの場合、関数はnilを返す
    ///   - method: 使用するHTTPメソッド（例：.get, .post）
    ///   - body: HTTPリクエストのボディ
    ///   - contentType: リクエストのContent-Typeヘッダ
    ///   - type: レスポンスデータをデコードする際のモデルの型
    /// - Returns: 指定された型にデコードされたレスポンスデータ
    public func callAPI<T: Codable>(url: URL?, method: HTTPMethod, body: Data? = nil, contentType: ContentType? = nil, type: T.Type) async throws -> T? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.name

        if let requestBody = body {
            request.httpBody = requestBody
            if let contentTypeValue = contentType {
                request.addValue(contentTypeValue.rawValue, forHTTPHeaderField: "Content-Type")
            }
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
        }

        let decodedData = try JSONDecoder().decode(type.self, from: data)
        return decodedData
    }

    /// 非同期で指定されたURLにHTTPリクエストを送信し、結果をデコードして返す
    /// - Parameter resource: リクエスト時の各設定
    /// - Returns: 指定された型にデコードされたレスポンスデータ
    public func callAPIUsingAsync<T: Codable>(_ resource: APIResource<T>) async throws -> T? {
        guard let url = resource.url else {
            throw NetworkError.badURL
        }

        var request = URLRequest(url: url)

        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }
            request.url = url

        case .post(let data), .put(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data

        case .delete:
            request.httpMethod = resource.method.name
        }


        if let headers = resource.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        let (data, response) = try await apiSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        try statusCodeValidator.validate(statusCode: httpResponse.statusCode, data: data)

        do {
            let result = try JSONDecoder().decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }

    }

    /// 非同期で指定されたURLにHTTPリクエストを送信し、結果をデコードしてCombineのPublisherとして返す
    /// - Parameters:
    ///   - url: リクエストを送信するURL。nilの場合はPublisherがエラーを出力する
    ///   - method: 使用するHTTPメソッド（例：.get, .post）
    ///   - body: HTTPリクエストのボディ
    ///   - contentType: リクエストのContent-Typeヘッダ
    ///   - type: レスポンスデータをデコードする際に期待するモデルの型
    /// - Returns: 指定された型にデコードされたレスポンスデータを出力するAnyPublisher
    public func callAPIUsingCombine<T: Codable>(url: URL?, method: HTTPMethod, body: Data? = nil, contentType: String? = nil, type: T.Type) -> AnyPublisher<T, Error> {
           guard let url = url else {
               return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
           }

           var request = URLRequest(url: url)
            request.httpMethod = method.name

           if let requestBody = body {
               request.httpBody = requestBody
               if let contentTypeValue = contentType {
                   request.addValue(contentTypeValue, forHTTPHeaderField: "Content-Type")
               }
           }

           return URLSession.shared.dataTaskPublisher(for: request)
               .tryMap { result in
                   guard let httpResponse = result.response as? HTTPURLResponse,
                         httpResponse.statusCode == 200 else {
                       throw URLError(.badServerResponse)
                   }
                   return result.data
               }
               .decode(type: T.self, decoder: JSONDecoder())
               .receive(on: DispatchQueue.main)
               .eraseToAnyPublisher()
       }
}
