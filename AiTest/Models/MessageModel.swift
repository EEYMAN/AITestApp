
// Represents a chat message in a session.



import Foundation

struct MessageModel: Identifiable, Codable, Equatable {
    let id: UUID
    let sessionId: String
    let content: String
    let timestamp: Date
    let isFromUser: Bool
}
