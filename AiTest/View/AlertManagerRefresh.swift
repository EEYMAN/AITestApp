import SwiftUI
import Combine

// Aler for button refresh - Done Refresh Sessions

final class AlertManagerRefresh: ObservableObject {
    @Published var isShowingAlert = false
    @Published var alertMessage: String = ""

    func showAlert(message: String) {
        alertMessage = message
        isShowingAlert = true
    }
}
