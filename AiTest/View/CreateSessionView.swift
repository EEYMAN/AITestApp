import SwiftUI

// View for creating a new session with topic and category selection

struct CreateSessionView: View {
    @State private var topic = ""
    @State private var selectedCategory: SessionCategory = .career

    // Closure called when session creation is requested
    var onCreate: (String, String, String) -> Void

    var body: some View {
        NavigationView {
            Form {
                // Input for session topic
                Section(header: Text("Session Topic")) {
                    TextField("Enter a topic", text: $topic)
                }

                // Picker for selecting session category
                Section(header: Text("Category")) {
                    Picker("Select category", selection: $selectedCategory) {
                        ForEach(SessionCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Button to start session, disabled if topic is empty
                Button("Start Session") {
                    onCreate(topic, selectedCategory.rawValue, "New session started")
                }
                .disabled(topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .navigationTitle("New Session")
        }
    }
}

