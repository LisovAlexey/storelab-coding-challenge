//
//  Persistance.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 07/03/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static let datamodelName = "ImageInfoSave"
    static let storeType = "sqlite"
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        var imageInfo = ImageInfo.mock
        imageInfo.toManagedObject(context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Self.datamodelName)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        // Todo: check
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static func save() {
        let context =
        PersistenceController.shared.container.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            fatalError("""
        \(#file), \
        \(#function), \
        \(error.localizedDescription)
      """)
        }
    }
    
    static func loadStores() {
        shared.container.loadPersistentStores(completionHandler: { (nsPersistentStoreDescription, error) in
            guard let error = error else {
                return
            }
            fatalError(error.localizedDescription)
        })
    }
    
    private static let url: URL = {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("\(datamodelName).\(storeType)")
        
        assert(FileManager.default.fileExists(atPath: url.path))
        
        return url
    }()

    
    static func deleteAndRebuild() {
        try! shared.container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: storeType)
        
        loadStores()
    }
}

