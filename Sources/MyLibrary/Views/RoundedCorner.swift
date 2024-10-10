#if canImport(UIKit)
import Foundation
import SwiftUI
import UIKit

public struct RoundedCorner: Shape {
    /// 各角の角丸の半径を定義
    public var topLeading: CGFloat = 0.0
    public var topTrailing: CGFloat = 0.0
    public var bottomLeading: CGFloat = 0.0
    public var bottomTrailing: CGFloat = 0.0
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners

    /// 指定された矩形範囲で角の丸みを持つパスを生成する
    /// UIKitの `UIBezierPath` を使用して指定された角に対して丸みを適用する
    /// - Parameter rect: パスを生成するビューの矩形範囲
    /// - Returns: 指定された角丸みを持つ SwiftUI の Path オブジェクト
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }

    /// ビューのパスを定義する
    /// - Parameter rect: ビューの矩形範囲
    /// - Returns: 定義されたパス
    public func viewPath(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.size.width
        let height = rect.size.height

        /// 上部中央から始め、右上の角丸までのパスを描く
        path.move(to: CGPoint(x: width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: width - topTrailing, y: 0))
        path.addArc(center: CGPoint(x: width - topTrailing, y: topTrailing), radius: topTrailing,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        /// 右上の角から右下の角丸までのパスを描く
        path.addLine(to: CGPoint(x: width, y: height - bottomTrailing))
        path.addArc(center: CGPoint(x: width - bottomTrailing, y: height - bottomTrailing), radius: bottomTrailing,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        /// 右下の角から左下の角丸までのパスを描く
        path.addLine(to: CGPoint(x: bottomLeading, y: height))
        path.addArc(center: CGPoint(x: bottomLeading, y: height - bottomLeading), radius: bottomLeading,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        /// 左下の角から左上の角丸までのパスを描く
        path.addLine(to: CGPoint(x: 0, y: topLeading))
        path.addArc(center: CGPoint(x: topLeading, y: topLeading), radius: topLeading,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        /// パスを閉じる
        path.closeSubpath()

        return path
    }
}
#endif
