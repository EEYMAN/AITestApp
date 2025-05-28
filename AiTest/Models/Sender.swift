import Foundation

// Enum representing the sender of a chat message, either the user or the bot.
// Provides a custom initializer to safely create a Sender from a raw string value,
// defaulting to .bot if the value is unrecognized.

enum Sender: String {
    case user
    case bot

    init(fromRawValue: String) {
        self = Sender(rawValue: fromRawValue) ?? .bot
    }
}

