import XCTest
import Combine
@testable import AiTest

final class SessionsListViewModelTests: XCTestCase {
    var viewModel: SessionsListViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
        viewModel = SessionsListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadSessionsLoadsAndGroupsSessions() {
        let expectation = XCTestExpectation(description: "Sessions loaded and grouped")

        // Subscribe to changes in groupedSessions, skip initial empty value
        viewModel.$groupedSessions
            .dropFirst()
            .sink { groupedSessions in
                // When groupedSessions is not empty, check keys count and fulfill expectation
                if !groupedSessions.isEmpty {
                    XCTAssertTrue(groupedSessions.keys.count > 0)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Trigger loading of sessions
        viewModel.loadSessions()

        // Wait for expectations with timeout
        wait(for: [expectation], timeout: 5.0)
    }

    func testAddAndDeleteSessionUpdatesGroupedSessions() {
        let testSession = SessionModel(
            id: UUID().uuidString,
            title: "Test Session",
            summary: "Summary",
            category: .other,
            date: Date()
        )

        // Expectations for add and delete operations
        let addExpectation = XCTestExpectation(description: "Session added to groupedSessions")
        let deleteExpectation = XCTestExpectation(description: "Session deleted from groupedSessions")

        var step = 0

        // Observe groupedSessions for changes after adding and deleting session
        viewModel.$groupedSessions
            .dropFirst()
            .sink { groupedSessions in
                // Check if testSession exists in groupedSessions
                let contains = groupedSessions.values.flatMap { $0 }.contains(where: { $0.id == testSession.id })

                if step == 0 {
                    // After adding, if session found fulfill addExpectation and proceed to delete
                    if contains {
                        addExpectation.fulfill()
                        step += 1
                        self.viewModel.deleteSession(testSession)
                    }
                } else if step == 1 {
                    // After deletion, if session no longer found fulfill deleteExpectation
                    if !contains {
                        deleteExpectation.fulfill()
                    }
                }
            }
            .store(in: &cancellables)

        // Add test session to trigger updates
        viewModel.addSession(testSession)

        // Wait for both add and delete expectations with timeout
        wait(for: [addExpectation, deleteExpectation], timeout: 5.0)
    }
}

