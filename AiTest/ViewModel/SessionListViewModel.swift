import Combine
import CoreData

// ViewModel managing sessions list with caching and loading from local JSON mock

class SessionsListViewModel: ObservableObject {
    @Published var groupedSessions: [Date: [SessionModel]] = [:] // Sessions grouped by date
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let persistence = PersistenceController.shared
    
    // Load sessions: first try Core Data cache, if empty load from JSON mock
    func loadSessions() {
        isLoading = true

        let cachedSessions = fetchSessionsFromCoreData()
        if !cachedSessions.isEmpty {
            groupAndPublish(sessions: cachedSessions)
            isLoading = false
            return // Return early to avoid overwriting Core Data with JSON data
        }

        // Core Data empty - fetch from mock API (JSON)
        fetchSessionsFromAPI()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    print("Failed to load sessions: \(error)")
                }
            } receiveValue: { sessions in
                self.saveSessionsToCoreData(sessions)
                self.groupAndPublish(sessions: sessions)
            }
            .store(in: &cancellables)
    }

    // Fetch sessions from Core Data
    private func fetchSessionsFromCoreData() -> [SessionModel] {
        let context = persistence.context
        let request: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { entity in
                guard
                    let id = entity.id,
                    let date = entity.date,
                    let title = entity.title,
                    let summary = entity.summary,
                    let categoryRaw = entity.category,
                    let category = SessionCategory(rawValue: categoryRaw)
                else { return nil }
                
                return SessionModel(
                    id: id,
                    title: title,
                    summary: summary,
                    category: category,
                    date: date
                )
            }
        } catch {
            print("CoreData fetch error: \(error)")
            return []
        }
    }
    
    // Save sessions to Core Data, clearing old data first
    private func saveSessionsToCoreData(_ sessions: [SessionModel]) {
        let context = persistence.context
        
        // Delete old session entities
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SessionEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(deleteRequest)
        
        // Save new sessions
        for session in sessions {
            let entity = SessionEntity(context: context)
            entity.id = session.id
            entity.date = session.date
            entity.title = session.title
            entity.category = session.category.rawValue
            entity.summary = session.summary
        }
        
        persistence.save()
    }
    
    // Simulate API fetch by loading local JSON file asynchronously
    private func fetchSessionsFromAPI() -> AnyPublisher<[SessionModel], Error> {
        Future { promise in
            DispatchQueue.global().async {
                guard let url = Bundle.main.url(forResource: "MockSessions", withExtension: "json") else {
                    promise(.failure(URLError(.badURL)))
                    return
                }
                do {
                    let data = try Data(contentsOf: url)
                    let sessions = try JSONDecoder.withISO8601Date.decode([SessionModel].self, from: data)
                    promise(.success(sessions))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Group sessions by day for UI presentation, с сортировкой внутри групп и по датам групп
    private func groupAndPublish(sessions: [SessionModel]) {
        let calendar = Calendar.current
        
        // Группируем сессии по дате без времени
        let grouped = Dictionary(grouping: sessions) { session in
            calendar.startOfDay(for: session.date)
        }
        
        // Сортируем сессии внутри каждой группы от новых к старым
        let sortedGrouped = grouped.mapValues { sessions in
            sessions.sorted(by: { $0.date > $1.date })
        }
        
        // Обновляем published property на главном потоке
        DispatchQueue.main.async {
            self.groupedSessions = sortedGrouped
        }
    }
    func deleteSession(_ session: SessionModel) {
        // Получаем все сессии плоским массивом
        var allSessions = groupedSessions.values.flatMap { $0 }
        // Удаляем нужную сессию
        allSessions.removeAll { $0.id == session.id }
        // Перегруппируем и обновляем опубликованные данные
        groupAndPublish(sessions: allSessions)
        // Обновляем Core Data
        saveSessionsToCoreData(allSessions)
    }


    // Add new session to existing list and update Core Data
    func addSession(_ session: SessionModel) {
        var allSessions = groupedSessions.values.flatMap { $0 }
        allSessions.append(session)
        groupAndPublish(sessions: allSessions)
        saveSessionsToCoreData(allSessions)
    }
}

// JSONDecoder configured for ISO8601 date decoding
extension JSONDecoder {
    static var withISO8601Date: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

