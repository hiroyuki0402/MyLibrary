import XCTest
import Combine
import Foundation
@testable import MyLibrary

final class MyLibraryTests: XCTestCase {
    /// テスト用のURL(サンプルURL)
    let testURL = URL(string: "https://umayadia-apisample.azurewebsites.net/api/persons")

    /// API通信Async/Awaitのテスト
    func testCallAPIAsync() async throws {
        Logger.showLog("testCallAPIAsyncのテスト開始", greepWord: "APIテスト")

        enum NetworkError: Error {
            case urlInvalid
            case serverUnavailable
            case unauthorized
        }

        /// callAPIを呼び出し、結果を取得
        do {
            let result: PersonData? = try await APIManager.shared.callAPI(
                url: testURL,
                method: .get,
                type: PersonData.self
            )
            Logger.showLog("testCallAPIAsync取得データ: \(String(describing: result))", greepWord: "APIテスト")
            XCTAssertNotNil(result)

        } catch let error as NetworkError {
            switch error {
            case .urlInvalid:
                XCTFail("URLが無効")

            case .serverUnavailable:
                XCTFail("サーバーが利用不可")

            case .unauthorized:
                XCTFail("認証エラー")
            }
        } catch {
            XCTFail("予想外エラー: \(error)")
        }
    }

    /// API通信Async/Awaitコンバインのテスト
    func testCallAPIUsingCombine() {
        Logger.showLog("testCallAPIUsingCombineのテスト開始", greepWord: "APIテスト")
        /// 非同期テストの期待を設定
        let expectation = XCTestExpectation(description: "通信の完了")

        var cancellables = Set<AnyCancellable>()

        APIManager.shared.callAPIUsingCombine(
            url: testURL,
            method: .get,
            type: PersonData.self
        )
        .sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Requestエラー: \(error)")
                }
                expectation.fulfill()
            },
            receiveValue: { value in
                Logger.showLog("testCallAPIUsingCombine取得データ: \(String(describing: value))", greepWord: "APIテスト")
            }
        )
        .store(in: &cancellables)

        /// 非同期テストの期待を待つ
        wait(for: [expectation], timeout: 10.0)
    }
}

// MARK: - テスト用構造体

///  - note: サンプルのURLの構造体 https://umayadia-apisample.azurewebsites.net/api/persons
struct PersonData: Codable {
    let success: Bool
    let data: [Datum]
}

struct Datum: Codable {
    let name, note: String
    let age: Int
    let registerDate: String
}
