import SwiftUI

// View representing a single chat message row with alignment and styling based on sender

struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack {
            if message.sender == .user {
                Spacer() 
                Text(message.text)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                Spacer()
            }
        }
    }
}

