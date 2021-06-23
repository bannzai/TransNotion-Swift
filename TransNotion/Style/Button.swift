import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    let width: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.2 : 1.0)
            .frame(width: width)
            .padding(.vertical, 14)
            .background(isEnabled ? Color.appPrimary : Color.appPrimary.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(4)
    }
}
