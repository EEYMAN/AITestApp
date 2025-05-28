import Foundation

// Model representing a session.

struct Session: Identifiable, Codable {
    let id: String
    let date: Date
    let title: String
    let category: String
    let summary: String?
}

