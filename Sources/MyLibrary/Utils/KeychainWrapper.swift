import SwiftUI
import Security

/// Keychain への保存・取得・削除を行うユーティリティ
public struct KeychainWrapper<T: Codable> {

    // MARK: - Set

    /// 指定したキーに値を保存
    ///
    /// Keychain に保存できるデータ型は Codable に準拠している必要がある
    /// 成功・失敗の結果やログを受け取りたい場合は、`handler` を指定して使用する
    ///
    /// - Parameters:
    ///   - value: 保存したい値 (Codable)
    ///   - key: 保存に使うユニークなキー文字列
    ///   - handler: 成功/失敗/ログを受け取るクロージャ
    ///     - `success`: 保存に成功したかどうか
    ///     - `error`: 発生した `Error`（ない場合は `nil`）
    ///     - `log`: 追加情報（文字列などを想定。`Any?` なので拡張利用可）
    ///
    /// - Returns: 成功時に `true`、失敗時に `false`
    ///
    /// - Example:
    /// ```swift
    /// /// 例1: クロージャを省略
    /// KeychainWrapper<String>.set("my token", for: "jwt_token_key")
    /// KeychainWrapper.set("my token", for: "jwt_token_key")
    ///
    /// /// 例2: クロージャを指定（成功/失敗のログを確認）
    /// KeychainWrapper<String>.set("my token", for: "jwt_token_key") { success, error, log in
    ///     if success {
    ///         print("Set OK:", log ?? "")
    ///     } else {
    ///         print("Set FAILED:", error?.localizedDescription ?? "Unknown error")
    ///         print("Log:", log ?? "No log")
    ///     }
    /// }
    /// ```
    @discardableResult
    public static func set(
        _ value: T,
        for key: String,
        handler: (_ success: Bool, _ error: Error?, _ log: Any?) -> Void = { _,_,_ in }
    ) -> Bool {
        do {
            let data = try JSONEncoder().encode(value)

            /// すでに同じキーで保存されている場合は削除してから再セット
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: data,
                kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
            ]
            SecItemDelete(query as CFDictionary)

            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                handler(true, nil, "Keychain への保存に成功: \(key)")
                return true
            } else {
                /// ステータスを文字列に変換してデバッグ出力
                if let errorMessage = SecCopyErrorMessageString(status, nil) {
                    handler(false, nil, "Keychain の保存処理でエラーが発生: \(errorMessage)")
                } else {
                    handler(false, nil, "Keychain の保存処理でエラーが発生: OSStatus(\(status))")
                }
                return false
            }
        } catch {
            handler(false, error, "Keychain への保存中にエンコードエラーが発生: \(key)")
            return false
        }
    }

    // MARK: - Get

    /// 指定したキーの値を取得
    ///
    /// Keychain からデータを取り出し、Codable を使ってデコードを行う
    /// 成功・失敗の結果やログを受け取りたい場合は、`handler` を指定して使用する
    ///
    /// - Parameters:
    ///   - key: 取得対象のキー
    ///   - handler: 成功/失敗/ログを受け取るクロージャ
    ///     - `success`: 取得に成功したかどうか
    ///     - `error`: 発生した `Error`（ない場合は `nil`）
    ///     - `log`: 追加情報（文字列などを想定。`Any?` なので拡張利用可）
    ///
    /// - Returns: 取得できた値（`T?`：存在しない場合は `nil`）
    ///
    /// - Example:
    /// ```swift
    /// /// 例1: クロージャを省略
    /// var token: String? = KeychainWrapper<String>.get(for: "jwt_token_key")
    /// var token2: String? = KeychainWrapper.get(for: "jwt_token_key")
    /// var token3: String?
    /// token3 = KeychainWrapper<String>.get(for: "jwt_token_key")
    ///
    /// /// 例2: 非オプショナルな変数に if let でアンラップして代入
    /// if let actualToken = KeychainWrapper<String>.get(for: "jwt_token_key") {
    ///     // actualToken は String として扱える
    ///     print("Actual token:", actualToken)
    /// }
    ///
    /// /// 例3: クロージャで結果を受け取る
    /// let token4 = KeychainWrapper.get(for: "jwt_token_key") { success, error, log in
    ///     if success {
    ///         print("Get OK:", log ?? "")
    ///     } else {
    ///         print("Get FAILED:", error?.localizedDescription ?? "Unknown error")
    ///         print("Log:", log ?? "No log")
    ///     }
    /// }
    /// ```
    public static func get(
        for key: String,
        handler: (_ success: Bool, _ error: Error?, _ log: Any?) -> Void = { _,_,_ in }
    ) -> T? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess {
            guard let data = item as? Data else {
                handler(false, nil, "Keychain からのデータ取得に失敗: \(key)")
                return nil
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                handler(true, nil, "Keychain からの取得に成功: \(key)")
                return decoded
            } catch {
                handler(false, error, "Keychain から取得したデータのデコードに失敗: \(key)")
                return nil
            }
        } else {
            if let errorMessage = SecCopyErrorMessageString(status, nil) {
                handler(false, nil, "Keychain の取得処理でエラーが発生: \(errorMessage)")
            } else {
                handler(false, nil, "Keychain の取得処理でエラーが発生: OSStatus(\(status))")
            }
            return nil
        }
    }

    // MARK: - Delete

    /// 指定したキーの値を削除します
    ///
    /// Keychain から該当キーのデータを削除
    /// 成功・失敗の結果やログを受け取りたい場合は、`handler` を指定する
    ///
    /// - Parameters:
    ///   - key: 削除対象のキー
    ///   - handler: 成功/失敗/ログを受け取るクロージャ
    ///     - `success`: 削除に成功したかどうか
    ///     - `error`: 発生した `Error`（ない場合は `nil`）
    ///     - `log`: 追加情報（文字列などを想定。`Any?` なので拡張利用可）
    ///
    /// - Returns: 成功時に `true`、失敗時に `false`
    ///
    /// - Example:
    /// ```swift
    /// /// 例1: 単純に削除
    /// KeychainWrapper<String>.delete(key: "jwt_token_key")
    ///
    /// /// 例2: 削除結果をクロージャで受け取る
    /// KeychainWrapper<String>.delete(key: "jwt_token_key") { success, error, log in
    ///     if success {
    ///         print("Delete OK:", log ?? "")
    ///     } else {
    ///         print("Delete FAILED:", error?.localizedDescription ?? "Unknown error")
    ///         print("Log:", log ?? "No log")
    ///     }
    /// }
    /// ```
    @discardableResult
    public static func delete(
        key: String,
        handler: (_ success: Bool, _ error: Error?, _ log: Any?) -> Void = { _,_,_ in }
    ) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            handler(true, nil, "Keychain からの削除に成功: \(key)")
            return true
        } else {
            if let errorMessage = SecCopyErrorMessageString(status, nil) {
                handler(false, nil, "Keychain の削除処理でエラーが発生: \(errorMessage)")
            } else {
                handler(false, nil, "Keychain の削除処理でエラーが発生: OSStatus(\(status))")
            }
            return false
        }
    }
}
