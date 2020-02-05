import Foundation
import CoreData

// MARK: - CD Stack
class CoreDataStack {
    
    private init() {}
    
    /// Some shared variable
    static let shared = CoreDataStack()
    
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var privateContext: NSManagedObjectContext {
        let newConetxt = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        newConetxt.parent = mainContext
        return newConetxt
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FindingTaylorSwift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    
    /// Saving the main context
    ///
    /// - Returns: True if context was saved, else false
    @discardableResult
    func saveContext() -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }
}


