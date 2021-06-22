import SwiftUI

extension View {
    @ViewBuilder func placeholder(when showPlaceholder: Bool) -> some View {
        if showPlaceholder {
            redacted(reason: .placeholder)
        } else {
            unredacted()
        }
    }
}
