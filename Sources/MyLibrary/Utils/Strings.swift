import Foundation

/// 指定されたキーに対応するローカライズされた文字列を返すメソッド
/// - Parameters:
///   - key: ローカライズされた文字列を検索するキー
///   - tableName: 使用する.stringsファイルの名前、指定しない場合はnil
///   - bundle: ローカライズされたリソースが含まれるバンドル、デフォルトはメインバンドル
///   - value: キーに対応する文字列が見つからない場合に使用するデフォルト値
///   - comment: ローカライズファイル内での翻訳者向けのコメント
/// - Returns: 指定されたキーに基づいてローカライズされた文字列
public func localized(_ key: String, tableName: String? = nil, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
    let string = NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
    return string
}

