import Foundation

extension UserDefaults {
    
    enum Keys {
        static let passwordDatas = "passwordDatas"
        static let paymentDatas = "paymentDatas"
    }
    
    /// 任意の Codable オブジェクトを UserDefaults に保存
    /// オブジェクトはまず JSON にエンコードされ、その後 UserDefaults に保存
    /// - Parameters:
    ///   - object: 保存する Codable オブジェクト
    ///   - key: オブジェクトを関連付けるためのキー
    ///   - uid: 保存時に　Keyと組み合わせて使う文字列
    /// - Throws: エンコードに失敗した場合にエラーを投げる
    func set<T: Codable>(object: T, forKey key: String, uid: String? = nil) throws {
        guard let uid = uid else { return }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            self.set(data, forKey: key + uid)
        } catch {
            throw error
        }
    }
    
    /// UserDefaults から Codable オブジェクトを取得
    /// UserDefaults に保存されている JSON データは指定された型にデコード
    /// - Parameters:
    ///   - key: 取得するオブジェクトに関連付けられたキー
    ///   - type: デコードするオブジェクトの型
    ///   - uid: 保存時に　Keyと組み合わせて使う文字列
    /// - Returns: 指定された型のオブジェクト。該当するデータが UserDefaults に存在しない場合は `nil` を返す
    /// - Throws: デコードに失敗した場合にエラーを投げる
    func getObject<T: Codable>(forKey key: String, castTo type: T.Type, uid: String? = nil) throws -> T? {
        guard let uid = uid, let data = self.data(forKey: key + uid) else { return nil }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw error
        }
    }
}
