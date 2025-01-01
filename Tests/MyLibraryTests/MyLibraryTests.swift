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
                method: .get([]),
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
            method: .get([]),
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
    
    /// `localized`関数を使用して都道府県名が正しくローカライズされるかのテスト
    func testLocalizedStrings() {
        /// 東京都の名前を日本語で取得してテスト
        let tokyoName = localized("Tokyo", tableName: "Prefecture", bundle: .module)
        XCTAssertEqual(tokyoName, "東京都", "ローカライズされた東京都の名前が期待される値と異なります。")
        
        /// 北海道の名前を日本語で取得してテスト
        let hokkaidoName = localized("Hokkaido", tableName: "Prefecture", bundle: .module)
        XCTAssertEqual(hokkaidoName, "北海道", "ローカライズされた北海道の名前が期待される値と異なります。")
        
        /// 青森県の名前を日本語で取得してテスト
        let aomoriName = localized("Aomori", tableName: "Prefecture", bundle: .module)
        XCTAssertEqual(aomoriName, "青森県", "ローカライズされた青森県の名前が期待される値と異なります。")
        
        /// ネットワークエラーのメッセージをテスト
        let networkErrorMessage = localized("ErrorNetworkUnavailable", tableName: "Error", bundle: .module)
        XCTAssertEqual(networkErrorMessage, "ネットワーク接続がありません。", "ローカライズされたネットワークエラーメッセージが期待される値と異なります。")
        
        /// サーバー応答なしのエラーメッセージをテスト
        let serverErrorMessage = localized("ErrorServerNotResponding", tableName: "Error", bundle: .module)
        XCTAssertEqual(serverErrorMessage, "サーバーが応答していません。", "ローカライズされたサーバーエラーメッセージが期待される値と異なります。")
        
        /// "OK"ボタンのローカライズをテスト
        let okButtonTitle = localized("CommonOK", tableName: "Localizable", bundle: .module)
        XCTAssertEqual(okButtonTitle, "OK", "ローカライズされた'OK'ボタンのテキストが期待される値と異なります。")
        
        /// "キャンセル"ボタンのローカライズをテスト
        let cancelButtonTitle = localized("CommonCancel", tableName: "Localizable", bundle: .module)
        XCTAssertEqual(cancelButtonTitle, "キャンセル", "ローカライズされた'キャンセル'ボタンのテキストが期待される値と異なります。")
    }

    /// 新API通信Async/Awaitのテスト
    func testNewCallAPIAsync() async throws {
        Logger.showLog("testCallAPIAsyncのテスト開始", greepWord: "APIテスト")

        enum NetworkError: Error {
            case urlInvalid
            case serverUnavailable
            case unauthorized
        }

        /// callAPIを呼び出し、結果を取得
        do {
            let resource: APIResource = .init(url: testURL, modelType: PersonData.self)
            let result: PersonData? = try await APIManager.shared.callAPIUsingAsync(resource)
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
