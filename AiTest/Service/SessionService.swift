import Foundation

// Service responsible for loading session data from local JSON file
class SessionService {
    // Loads sessions asynchronously from "MockSessions.json" in app bundle
    // Calls completion handler with an array of SessionModel or empty array if failed
    static func loadSessions(completion: @escaping ([SessionModel]) -> Void) {
        guard let url = Bundle.main.url(forResource: "MockSessions", withExtension: "json") else {
            print("MockSessions.json not found")
            completion([])
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let sessions = try decoder.decode([SessionModel].self, from: data)
            completion(sessions)
        } catch {
            print("Error decoding sessions: \(error)")
            completion([])
        }
    }
}

