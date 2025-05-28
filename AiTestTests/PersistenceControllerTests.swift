import XCTest
import CoreData
@testable import AiTest // Замени AiTest на имя твоего модуля

final class PersistenceControllerTests: XCTestCase {
    var persistence: PersistenceController!

    override func setUp() {
        super.setUp()
        persistence = PersistenceController(inMemory: true) // in-memory для изоляции тестов
    }

    override func tearDown() {
        persistence = nil
        super.tearDown()
    }

    func testSaveAndFetch() throws {
        let context = persistence.context
        
        // Создаем тестовую сессию
        let session = SessionEntity(context: context)
        session.id = UUID().uuidString
        session.title = "Test Session"
        session.date = Date()
        session.category = "test"
        session.summary = "Testing save"
        
        // Сохраняем в контекст
        persistence.save()
        
        // Фетчим сессии из Core Data
        let request = SessionEntity.fetchRequest()
        let results = try context.fetch(request)
        
        XCTAssertEqual(results.count, 1, "Should have exactly one session saved")
        XCTAssertEqual(results.first?.title, "Test Session", "Session title should match")
    }
}

