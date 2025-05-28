import SwiftUI

// View displaying a list of chat sessions grouped by date.
// Supports creating new sessions, refreshing the list, navigating to chat,
// and deleting sessions with confirmation alerts.

struct SessionsListView: View {
    @StateObject private var vm = SessionsListViewModel()
    @StateObject private var alertManager = AlertManagerRefresh()

    @State private var selectedSessionId: String? = nil
    @State private var isCreateSessionPresented = false
    
    // For displaying the delete confirmation alert
    
    @State private var sessionToDelete: SessionModel? = nil
    @State private var isShowingDeleteAlert = false

    private var sortedDates: [Date] {
        vm.groupedSessions.keys.sorted(by: >)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(sortedDates, id: \.self) { date in
                    Section(header: Text(date, style: .date)) {
                        if let sessions = vm.groupedSessions[date]?.sorted(by: { $0.date > $1.date }) {
                            ForEach(sessions) { session in
                                NavigationLink(destination: ChatView(sessionId: session.id)) {
                                    SessionRowView(session: session)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        sessionToDelete = session
                                        isShowingDeleteAlert = true
                                    } label: {
                                        Label("Delete Session", systemImage: "trash")
                                    }
                                }
                                .onLongPressGesture {
                                    sessionToDelete = session
                                    isShowingDeleteAlert = true
                                }
                            }
                            .onDelete { indexSet in
                                // Удаляем сессию по свайпу
                                if let index = indexSet.first {
                                    let session = sessions[index]
                                    sessionToDelete = session
                                    isShowingDeleteAlert = true
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("AI Sessions")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Refresh") {
                        vm.loadSessions()
                        alertManager.showAlert(message: "List updated")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start new session") {
                        isCreateSessionPresented = true
                    }
                }
            }
            .sheet(isPresented: $isCreateSessionPresented) {
                CreateSessionView { topic, categoryRaw, summary in
                    let newSession = SessionModel(
                        id: UUID().uuidString,
                        title: topic,
                        summary: summary,
                        category: SessionCategory(rawValue: categoryRaw) ?? .career,
                        date: Date()
                    )
                    vm.addSession(newSession)
                    isCreateSessionPresented = false
                    selectedSessionId = newSession.id
                }
            }
            .background(
                NavigationLink(
                    destination: Group {
                        if let sessionId = selectedSessionId {
                            ChatView(sessionId: sessionId)
                        } else {
                            EmptyView()
                        }
                    },
                    tag: selectedSessionId ?? "",
                    selection: Binding(
                        get: { selectedSessionId },
                        set: { selectedSessionId = $0 }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            )
            .onAppear {
                vm.loadSessions()
            }
            .overlay {
                if vm.isLoading {
                    ProgressView()
                }
            }
            // Сам алерт успешного действия
            .alert(isPresented: $alertManager.isShowingAlert) {
                Alert(
                    title: Text("Successful"),
                    message: Text(alertManager.alertMessage),
                    dismissButton: .default(Text("Done"))
                )
            }
            
            // Session deletion confirmation alert
            .alert("Delete session?",
                   isPresented: $isShowingDeleteAlert,
                   presenting: sessionToDelete) { session in
                Button("Delete", role: .destructive) {
                    vm.deleteSession(session)
                    sessionToDelete = nil
                }
                Button("Cancel", role: .cancel) {
                    sessionToDelete = nil
                }
            } message: { session in
                Text("Are you sure you want to delete \"\(session.title)\"?")
            }
        }
    }
}

