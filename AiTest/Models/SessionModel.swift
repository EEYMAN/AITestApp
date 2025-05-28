import Foundation

// Defines the session model.

struct SessionModel: Identifiable, Codable {
    let id: String
    let title: String
    let summary: String
    let category: SessionCategory
    let date: Date
}

