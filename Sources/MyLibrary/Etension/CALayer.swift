import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(UIKit)
extension CALayer {

    /// 影をつける
    /// - Parameters:
    ///   - shadowOffset: 影の方向
    ///   - shadowColor: 影の色
    ///   - shadowOpacity: 影の透明度(最大値1.0)
    ///   - shadowRadius: 影の幅
    public func addShadow(shadowOffset: CGSize, shadowColor: CGColor, shadowOpacity: Float, shadowRadius: CGFloat) {
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
    }
}
#endif
