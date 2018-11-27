import Foundation
import CoreData

class CDHelper{
    
    static let sharedInstance = CDHelper()
    
    lazy var storesDirectory: URL = {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as URL
    }()
    lazy var localStoreURL: URL = {
        let url = self.storesDirectory.appendingPathComponent("WhaleTalk.sqlite")
        return url
    }()
    lazy var modelURL: URL = {
        let bundle = Bundle.main
        if let url = bundle.url(forResource: "Model", withExtension: "momd") {
            return url
        }
        print("CRITICAL - Managed Object Model file not found")
        abort()
    }()
    
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOf:self.modelURL)!
    }()
    
    lazy var coordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.localStoreURL, options: nil)
        } catch {
            print("Could not add the peristent store")
            abort()
        }
        
        return coordinator
    }()
}
