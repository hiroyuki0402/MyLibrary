import Foundation

extension UserDefaults {

    /// 任意の Codable オブジェクトを UserDefaults に保存
    ///
    /// オブジェクトはまず JSON にエンコードし、それを UserDefaults に保存する
    /// 保存時にはキーに加えて、オプションで UID などを組み合わせてユニークなキーとして使うことができる
    ///
    /// - Parameters:
    ///   - object: 保存する Codable オブジェクトを指定する
    ///   - key: オブジェクトを関連付けるためのキーを指定する
    ///   - uid: 保存時にキーと組み合わせて使う追加の文字列を指定する
    /// - Throws: エンコードに失敗した場合にエラーを投げる
    ///
    /// - Example:
    ///   以下の例では、キー "passwordDatas" と UID "12345" でパスワード情報を保存する
    /// ```
    /// let passwordInfo = PasswordData(username: "user1", password: "pass123")
    /// try? set(object: passwordInfo, forKey: Keys.passwordDatas, uid: "12345")
    /// ```
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

    /// UserDefaults から Codable オブジェクトを取得する
    ///
    /// 指定したキーとオプションの UID に関連付けられたデータを取得し、指定された型にデコードする
    ///
    /// - Parameters:
    ///   - key: 取得するオブジェクトに関連付けられたキーを指定する
    ///   - type: デコードするオブジェクトの型を指定する
    ///   - uid: 保存時にキーと組み合わせた追加の文字列を指定する
    /// - Returns: 指定された型のオブジェクトを返す。該当するデータが UserDefaults に存在しない場合は `nil` を返す
    /// - Throws: デコードに失敗した場合にエラーを投げる
    ///
    /// - Example:
    ///   以下の例では、キー "passwordDatas" と UID "12345" で保存されたパスワード情報を取得する
    /// ```
    /// let retrievedPasswordInfo = try? getObject(forKey: Keys.passwordDatas, castTo: PasswordData.self, uid: "12345")
    /// ```
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

    /// オブジェクトを配列に追加する
    ///
    /// 指定されたキーに関連付けられた配列に新たなオブジェクトを追加する
    /// 配列がまだ存在しない場合は新規作成する
    /// 追加するオブジェクトがすでに配列に含まれていない場合のみ追加される
    ///
    /// - Parameters:
    ///   - object: 追加する Codable & Equatable オブジェクトを指定する
    ///   - key: オブジェクトを関連付けるためのキーを指定する
    /// - Throws: エンコードに失敗した場合にエラーを投げる
    ///
    /// - Example:
    ///   以下の例では、新しいパスワード情報を既存の配列に追加する
    /// ```
    /// let newPasswordInfo = PasswordData(username: "user2", password: "pass456")
    /// try? addObject(object: newPasswordInfo, forKey: Keys.passwordDatas)
    /// ```
    func addObject<T: Codable & Equatable>(object: T, forKey key: String) throws {
        var objects: [T] = (try? getObjects(forKey: key, castTo: [T].self)) ?? []
        if !objects.contains(object) {
            objects.append(object)
            try saveObjects(objects, forKey: key)
        }
    }

    /// 指定されたオブジェクトを配列から削除する
    ///
    /// 指定されたキーに関連付けられた配列から特定のオブジェクトを削除する
    /// 配列が存在しない場合や、指定されたオブジェクトが含まれていない場合は何もしない
    ///
    /// - Parameters:
    ///   - object: 削除する Codable & Equatable オブジェクトを指定する
    ///   - key: オブジェクトを関連付けるためのキーを指定する
    /// - Throws: エンコードに失敗した場合にエラーを投げる
    ///
    /// - Example:
    ///   以下の例では、特定のパスワード情報を配列から削除する
    /// ```
    /// let passwordToRemove = PasswordData(username: "user1", password: "pass123")
    /// try? removeObject(object: passwordToRemove, forKey: Keys.passwordDatas)
    /// ```
    func removeObject<T: Codable & Equatable>(object: T, forKey key: String) throws {
        var objects: [T] = (try? getObjects(forKey: key, castTo: [T].self)) ?? []
        if let index = objects.firstIndex(of: object) {
            objects.remove(at: index)
            try saveObjects(objects, forKey: key)
        }
    }

    /// オブジェクトの配列を UserDefaults に保存する
    ///
    /// 指定されたキーに関連付けられた配列を JSON データとして UserDefaults に保存する
    ///
    /// - Parameters:
    ///   - objects: 保存する Codable オブジェクトの配列を指定する
    ///   - key: オブジェクトを関連付けるためのキーを指定する
    /// - Throws: エンコードに失敗した場合にエラーを投げる
    ///
    /// - Example:
    ///   以下の例では、パスワード情報の配列を保存する
    /// ```
    /// let passwordList = [PasswordData(username: "user1", password: "pass123"),
    ///                     PasswordData(username: "user2", password: "pass456")]
    /// try? saveObjects(passwordList, forKey: Keys.passwordDatas)
    /// ```
    private func saveObjects<T: Codable>(_ objects: [T], forKey key: String) throws {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(objects)
            self.set(data, forKey: key)
        } catch {
            throw error
        }
    }

    /// UserDefaults からオブジェクトの配列を取得する
    ///
    /// 指定されたキーに関連付けられた JSON データを配列としてデコードし、オブジェクトの配列を取得する
    ///
    /// - Parameters:
    ///   - key: 取得するオブジェクトに関連付けられたキーを指定する
    ///   - type: デコードするオブジェクトの型を指定する
    /// - Returns: 指定された型のオブジェクトの配列を返す。該当するデータが UserDefaults に存在しない場合は `nil` を返す
    /// - Throws: デコードに失敗した場合にエラーを投げる
    ///
    /// - Example:
    ///   以下の例では、保存されたパスワード情報の配列を取得する
    /// ```
    /// let passwordList = try? getObjects(forKey: Keys.passwordDatas, castTo: [PasswordData].self)
    /// ```
    func getObjects<T: Codable>(forKey key: String, castTo type: [T].Type) throws -> [T]? {
        guard let data = self.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        do {
            let objects = try decoder.decode(type, from: data)
            return objects
        } catch {
            throw error
        }
    }
}

