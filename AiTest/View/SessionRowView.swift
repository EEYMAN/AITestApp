import SwiftUI

// View representing a single session row in a list
// Displays session title, category, and formatted date

struct SessionRowView: View {
    let session: SessionModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(session.category.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(dateFormatted(session.date)) // Display formatted date string
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

    // Formats a Date object into a user-friendly string representation
    // Returns a string with medium date style and short time style
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // e.g. Jan 1, 2024
        formatter.timeStyle = .short   // e.g. 3:45 PM
        return formatter.string(from: date)
    }
}

