
import Foundation

// Enum representing the category of a session, conforming to Codable for easy encoding/decoding,
// Identifiable for use in SwiftUI lists, and CaseIterable for iterating over all cases.

enum SessionCategory: String, CaseIterable, Identifiable, Codable {
    case career
    case emotions
    case productivity
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .career: return "Career"
        case .emotions: return "Emotions"
        case .productivity: return "Productivity"
        case .other: return "Other"
        }
    }
}
