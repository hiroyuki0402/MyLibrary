import SwiftUI

/// ハイライトさせない
public struct NoHighlightButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(1.0)
    }
}
