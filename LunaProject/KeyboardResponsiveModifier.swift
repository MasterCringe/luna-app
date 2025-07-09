
import SwiftUI
import Combine

// Ce ViewModifier permet à une vue de réagir à l’apparition et disparition du clavier
struct KeyboardResponsiveModifier: ViewModifier {
    @State private var offset: CGFloat = 0

    // Notifications système pour le clavier
    private let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    private let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset) // Applique un décalage vers le haut égal à la hauteur du clavier
            .onReceive(keyboardWillShow) { notification in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation {
                        offset = frame.height
                    }
                }
            }
            .onReceive(keyboardWillHide) { _ in
                withAnimation {
                    offset = 0
                }
            }
    }
}

// Extension pratique à utiliser dans n’importe quelle vue SwiftUI
extension View {
    func keyboardResponsive() -> some View {
        self.modifier(KeyboardResponsiveModifier())
    }
}
