import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    let width: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.2 : 1.0)
            .frame(width: width)
            .padding(.vertical, 12)
            .cornerRadius(4)
            .background(isEnabled ? Color.black : Color.black.opacity(0.4))
            .foregroundColor(.white)
    }
}
