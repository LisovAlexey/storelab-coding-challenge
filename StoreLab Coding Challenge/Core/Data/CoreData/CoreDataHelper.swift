//
//  CoreDataHelper.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 07/03/2023.
//

import Foundation
import CoreData

enum CoreDataHelper {
    static let context = PersistenceController.shared.container.viewContext
    static let previewContext = PersistenceController.preview.container.viewContext
    
    static func clearDatabase() {
        let entities = PersistenceController.shared.container.managedObjectModel.entities
        entities.compactMap(\.name).forEach(clearTable)
    }
    
    private static func clearTable(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
