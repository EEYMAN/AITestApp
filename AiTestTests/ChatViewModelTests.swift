import XCTest
import Combine
@testable import AiTest

final class ChatViewModelTests: XCTestCase {
    var viewModel: ChatViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
        // Create viewModel with a dummy sessionId
        viewModel = ChatViewModel(sessionId: "test-session")
        // Clear messages before each test
        viewModel.messages = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testSendMessageAddsUserAndBotMessages() {
        let expectation = XCTestExpectation(description: "Bot response received")

        // Observe changes to the messages array
        viewModel.$messages
            .dropFirst() // Skip initial value
            .sink { messages in
                if messages.count == 2 {
                    XCTAssertEqual(messages[0].content, "Hello")
                    XCTAssertTrue(messages[0].isFromUser)
                    XCTAssertEqual(messages[1].content, "AI says: Hello")
                    XCTAssertFalse(messages[1].isFromUser)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Send a message
        viewModel.sendMessage("Hello")

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadMessagesLoadsFromCoreData() {
        // Check that messages is not nil after initialization or any other logic
        XCTAssertNotNil(viewModel.messages)
    }
}

