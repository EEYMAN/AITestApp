import SwiftUI

// Displays a chat message bubble aligned left or right based on the sender.
// Shows message text with timestamp formatted as HH:mm.

struct ChatBubbleView: View {
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date

    // Cache DateFormatter for better performance

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer() }

            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(text)
                    .padding(12)
                    .background(isFromCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isFromCurrentUser ? .white : .black)
                    .cornerRadius(18)

                Text(Self.formatter.string(from: timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            if !isFromCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
}


