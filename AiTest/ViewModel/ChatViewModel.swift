import Foundation
import CoreData
import Combine

// ViewModel responsible for managing chat messages in a given session.
// Handles loading and saving messages to Core Data, as well as simulating bot responses.
// ViewModel for handling chat messages in a session

class ChatViewModel: ObservableObject {
    @Published var messages: [MessageModel] = []

    private let context = PersistenceController.shared.context
    private var cancellables = Set<AnyCancellable>()

    let sessionId: String

    // Initialize with sessionId and load messages from Core Data
    init(sessionId: String) {
        self.sessionId = sessionId
        loadMessages()
    }

    // Send user message and simulate bot response after delay
    func sendMessage(_ content: String) {
        let userMessage = MessageModel(
            id: UUID(),
            sessionId: sessionId,
            content: content,
            timestamp: Date(),
            isFromUser: true
        )
        messages.append(userMessage)
        saveMessage(userMessage)

        let botResponse = MessageModel(
            id: UUID(),
            sessionId: sessionId,
            content: "AI says: \(content)",
            timestamp: Date(),
            isFromUser: false
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messages.append(botResponse)
            self.saveMessage(botResponse)
        }
    }

    // Load all messages for the current session from Core Data
    func loadMessages() {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "sessionId == %@", sessionId)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MessageEntity.timestamp, ascending: true)]

        do {
            let entities = try context.fetch(request)
            messages = entities.compactMap { entity in
                guard let id = entity.id,
                      let content = entity.content,
                      let timestamp = entity.timestamp,
                      let sessionId = entity.sessionId
                else { return nil }

                return MessageModel(
                    id: id,
                    sessionId: sessionId,
                    content: content,
                    timestamp: timestamp,
                    isFromUser: entity.isFromUser
                )
            }
        } catch {
            // Error loading messages from Core Data
            print("Failed to load messages: \(error)")
        }
    }

    // Save a single message to Core Data
    private func saveMessage(_ message: MessageModel) {
        let entity = MessageEntity(context: context)
        entity.id = message.id
        entity.content = message.content
        entity.sessionId = message.sessionId
        entity.timestamp = message.timestamp
        entity.isFromUser = message.isFromUser

        do {
            try context.save()
        } catch {
            // Error saving message to Core Data
            print("Failed to save message: \(error)")
        }
    }
}

