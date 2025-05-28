import CoreData

// Singleton controller to manage Core Data stack and context
final class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // Convenient access to the main context
    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "Model") // Core Data model name
        
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true // Enable automatic migration
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }

    // Save context changes if any
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Save error: \(error)")
            }
        }
    }
}


