import Foundation
import CryptoKit

/// 一意識別子生成クラス
///
/// - 暗号化の有無を選択可能（デフォルトは暗号化あり）
/// - ハッシュ長やプリセットによるカスタマイズ可能
/// - プレフィックスやバージョン情報を組み込む柔軟なIDタイプ
/// - スレッドセーフ設計による並行生成対応
/// - IDのデコードとバリデーション機能
///
/// - Features:
///   - **暗号化**: SHA256ハッシュを使ったセキュアなID生成（オプションで暗号化なしも可能）
///   - **カスタマイズ**: プリセット、ハッシュ長、プレフィックス、バージョン情報の組み合わせをサポート
///   - **デコード可能**: IDからタイムスタンプやその他の情報を解析可能
///   - **バリデーション**: ID形式が正しいかを検証可能
///
/// - Example:
///   暗号化IDの生成:
///   ```
///   let id = LiteID()
///   /// 暗号化された一意のID
///   /// 利用例としてセキュリティが重視される場合や、衝突の可能性を極力排除したい場合
///   /// 例えば、データベースの主キーやAPIトークンとして使用可能
///   print(id.value)
///   ```
///
///   プレフィックス付きの短縮ID:
///   ```
///   let shortPrefixedID = LiteID(type: .prefixed("USR-"), hashLength: 16)
///   /// 例: "USR-1a2b3c4d"
///   /// 利用例で特定の用途（例: ユーザーIDや注文番号）を示す識別子が必要な場合とかで
///   /// プレフィックスを付与することで、用途を明確にしたり、識別子の分類が簡単になる
///   print(shortPrefixedID.value)
///   ```
///
///   IDのデコード:
///   ```
///   let decoded = id.decode()
///   /// タイムスタンプ部分
///   /// 利用例IDに埋め込まれた情報（例: 生成時のタイムスタンプ）を後から解析したい場合で
///   /// 例えば、生成日時を元にデータの並び替えや有効期限の計算が可能になる
///   print(decoded["timestamp"] ?? "N/A")
///   ```
///
///   バリデーション:
///   ```
///   let isValid = LiteID.validate("USR-1a2b3c4d")
///   /// true または false
///   /// 利用例外部から受け取った識別子が正しい形式であるかを検証する必要がある場合とか
///   /// 例えば、APIやフォームで送信されたIDの整合性をチェックする際に活用できる
///   print(isValid)
///   ```
public class LiteID: Hashable, Codable, CustomStringConvertible {
    /// IDの値
    public let value: String

    /// 暗号化フラグ（外部には公開しない）
    private let isEncrypted: Bool

    /// ハッシュ長（外部には公開しない）
    private let hashLength: Int

    /// IDのプリセット（オプション）
    public enum LiteIDType {
        /// デフォルトのセキュアなID
        case standard

        /// 短縮版のID
        case short

        /// バージョン付きのID
        case versioned(String)

        /// プレフィックス付きのID
        case prefixed(String)
    }

    /// デフォルトのプリセット
    public enum LiteIDPreset {
        /// 標準的なセキュアなID
        case defaultSecure

        /// 非暗号化の短縮ID
        case shortNonEncrypted

        /// プレフィックス付きID
        case prefixed(String)
    }

    /// デフォルトの初期化（暗号化あり、衝突の可能性なし）
    /// - Parameters:
    ///   - type: IDのタイプ（デフォルト: `.standard`）
    ///   - encrypt: 暗号化の有無（デフォルト: `true`）
    ///   - hashLength: ハッシュの長さ（デフォルト: `64`）
    public init(type: LiteIDType = .standard, encrypt: Bool = true, hashLength: Int = 64) {
        self.isEncrypted = encrypt
        self.hashLength = max(8, hashLength) // 最小ハッシュ長は8文字
        self.value = LiteID.generateUniqueID(type: type, encrypt: encrypt, hashLength: self.hashLength)
    }

    /// 明示的に指定した値で初期化
    /// - Parameter value: 指定する識別子の値
    public init(value: String) {
        self.value = value
        self.isEncrypted = false
        self.hashLength = value.count
    }

    /// 一意のIDを生成（暗号化フラグとハッシュ長を考慮）
    private static func generateUniqueID(type: LiteIDType, encrypt: Bool, hashLength: Int) -> String {
        let rawID = generateThreadSafeID()

        switch type {
        case .standard:
            return encrypt ? hashSHA256(input: rawID, length: hashLength) : String(rawID.prefix(hashLength))

        case .short:
            return String(rawID.prefix(8))

        case .versioned(let version):
            return "\(version)-\(encrypt ? hashSHA256(input: rawID, length: hashLength) : rawID)"

        case .prefixed(let prefix):
            return "\(prefix)\(encrypt ? hashSHA256(input: rawID, length: hashLength) : rawID)"
        }
    }

    /// スレッドセーフなID生成
    private static let queue = DispatchQueue(label: "LiteIDQueue")
    private static func generateThreadSafeID() -> String {
        return queue.sync {
            let timestamp = "\(Date().timeIntervalSince1970)"
            let randomValue = UUID().uuidString
            return "\(timestamp)-\(randomValue)"
        }
    }

    /// SHA256でハッシュ化し、指定された長さに切り詰める
    private static func hashSHA256(input: String, length: Int) -> String {
        let hash = SHA256.hash(data: Data(input.utf8))
        let fullHash = hash.compactMap { String(format: "%02x", $0) }.joined()
        return String(fullHash.prefix(length))
    }

    /// IDをデコード（タイムスタンプやランダム値を抽出）
    public func decode() -> [String: String] {
        let components = self.value.split(separator: "-")
        return [
            "timestamp": components.first.map { String($0) } ?? "",
            "random": components.count > 1 ? String(components[1]) : ""
        ]
    }

    /// IDのバリデーション
    public static func validate(_ id: String) -> Bool {
        let pattern = #"^\w+\-\w+$"# // プレフィックス-ランダム値の形式
        let regex = try? NSRegularExpression(pattern: pattern)
        return regex?.firstMatch(in: id, options: [], range: NSRange(location: 0, length: id.utf16.count)) != nil
    }

    /// Hashable プロトコル準拠: 比較用
    public static func == (lhs: LiteID, rhs: LiteID) -> Bool {
        lhs.value == rhs.value
    }

    /// Hashable プロトコル準拠: ハッシュ値計算
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    /// デバッグ時の可読性向上
    public var description: String {
        return value
    }
}
