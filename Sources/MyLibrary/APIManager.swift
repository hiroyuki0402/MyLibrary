import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public class APIManager {
    static let shared = APIManager()
    private init() { }

    /// 非同期で指定されたURLにHTTPリクエストを送信し、結果をデコードして返す
    /// - Parameters:
    ///   - url: リクエストを送信するURL。nilの場合、関数はnilを返す
    ///   - method: 使用するHTTPメソッド（例：.get, .post）
    ///   - body: HTTPリクエストのボディ
    ///   - contentType: リクエストのContent-Typeヘッダ。指定がない場合はヘッダを追加しない
    ///   - type: レスポンスデータをデコードする際のモデルの型
    /// - Returns: 指定された型にデコードされたレスポンスデータ。レスポンスが期待した形式でない場合はエラーを投げる
    func callAPI<T: Codable>(url: URL?, method: HTTPMethod, body: Data? = nil, contentType: ContentType? = nil, type: T.Type) async throws -> T? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

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


    /// 非同期で指定されたURLにHTTPリクエストを送信し、結果をデコードしてCombineのPublisherとして返す
    /// - Parameters:
    ///   - url: リクエストを送信するURL。nilの場合はPublisherがエラーを出力する
    ///   - method: 使用するHTTPメソッド（例：.get, .post）
    ///   - body: HTTPリクエストのボディ
    ///   - contentType: リクエストのContent-Typeヘッダ
    ///   - type: レスポンスデータをデコードする際に期待するモデルの型
    /// - Returns: 指定された型にデコードされたレスポンスデータを出力するAnyPublisher
    func callAPIUsingCombine<T: Codable>(url: URL?, method: HTTPMethod, body: Data? = nil, contentType: String? = nil, type: T.Type) -> AnyPublisher<T, Error> {
           guard let url = url else {
               return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
           }

           var request = URLRequest(url: url)
           request.httpMethod = method.rawValue

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
