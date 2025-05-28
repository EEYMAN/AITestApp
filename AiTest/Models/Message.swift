import Foundation

// Model representing a chat message, conforming to Identifiable for use in lists.
// Contains a unique id, the message text, timestamp, and the sender (user or bot).

struct Message: Identifiable {
    let id: String
    let text: String
    let timestamp: Date
    let sender: Sender

    init(id: String = UUID().uuidString, text: String, timestamp: Date = Date(), sender: Sender) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.sender = sender
    }
}
