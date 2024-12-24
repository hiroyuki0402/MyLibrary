import SwiftUI
#if canImport(UIKit)
import UIKit

public extension UIColor {
    /// UIColorをSwiftUIのColorに変換するプロパティ
    ///
    /// このプロパティは、UIKitのUIColorをSwiftUIのColor型に変換
    ///
    /// - Note: このプロパティを使用することで、UIColorを直接Color型としてSwiftUIビューで利用可能になる
    ///
    /// - Example:
    /// ```
    /// let uiColor = UIColor.red
    /// let swiftUIColor = uiColor.toColor
    /// ```
    /// この例では、`UIColor.red` がSwiftUIの `Color.red` として利用可能になる
    var toColor: Color {
        return Color(uicolor: self)
    }
    
    /// RGB値を使用してUIColorを初期化するコンビニエンスイニシャライザ
    ///
    /// 指定されたRGB値（0〜255）およびアルファ値（0.0〜1.0）を使用してUIColorを生成
    /// RGB値が範囲外の場合、アサーションに失敗する
    ///
    /// - Parameters:
    ///   - red: 赤の成分（0〜255）
    ///   - green: 緑の成分（0〜255）
    ///   - blue: 青の成分（0〜255）
    ///   - alpha: 透明度の値（0.0〜1.0）
    ///
    /// - Example:
    /// ```
    /// let color = UIColor(red: 255, green: 200, blue: 150, alpha: 0.8)
    /// ```
    /// この例では、RGBA(255, 200, 150, 0.8)のUIColorが作成されます。
    public convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    /// 16進数の値を使用してUIColorを初期化するコンビニエンスイニシャライザ
    ///
    /// 16進数カラーコード（例：0xFFFFFF）を使用してUIColorを生成
    /// 赤、緑、青の成分は16進数から分離され、それぞれの成分が0〜255の範囲にマッピング
    ///
    /// - Parameter hex: 16進数形式で表されたカラーコード（例：0xFFFFFF）
    ///
    /// - Example:
    /// ```
    /// let color = UIColor(hex: 0xFF5733)
    /// ```
    /// この例では、16進カラーコード0xFF5733に対応するUIColorが作成される
    public convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}


#endif
