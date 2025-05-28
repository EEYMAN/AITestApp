import SwiftUI

struct ChatView: View {
    @StateObject private var vm: ChatViewModel
    @State private var input = ""
    @FocusState private var isInputFocused: Bool

    init(sessionId: String) {
        _vm = StateObject(wrappedValue: ChatViewModel(sessionId: sessionId))
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(vm.messages, id: \.id) { message in
                            ChatBubbleView(
                                text: message.content,
                                isFromCurrentUser: message.isFromUser,
                                timestamp: message.timestamp
                            )
                            .id(message.id)
                        }
                    }
                    .padding(.top)
                }
                .onChange(of: vm.messages) { _ in
                    scrollToBottom(proxy: proxy)
                }
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }

                HStack {
                    TextField("Message...", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isInputFocused)
                        .submitLabel(.send)
                        .onSubmit {
                            sendMessage()
                        }

                    Button("Send") {
                        sendMessage()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Session")
        .onAppear {
            // Focus on the input field on load, if needed

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isInputFocused = true
            }
        }
    }

    private func sendMessage() {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        vm.sendMessage(text)
        input = ""

        // Refocus on the input field after sending the message

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isInputFocused = true
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastId = vm.messages.last?.id {
            withAnimation {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }
}

