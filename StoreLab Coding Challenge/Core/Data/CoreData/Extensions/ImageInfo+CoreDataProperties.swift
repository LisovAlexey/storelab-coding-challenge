//
//  ImageInfo+CoreDataProperties.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 07/03/2023.
//
//

import Foundation
import CoreData
import UIKit

extension ImageInfoEntity {
    func getImageInfo() -> ImageInfo {
        return ImageInfo.init(managedObject: self)
    }
}

extension ImageInfo {
    init(managedObject: ImageInfoEntity) {
        self.author = managedObject.author ?? ""
        self.id = Int(managedObject.id)
        self.url = managedObject.url ?? ""
        self.downloadUrl = managedObject.downloadUrl ?? ""
        self.width = Int(managedObject.width)
        self.height = Int(managedObject.height)
        self.image = UIImage(data: managedObject.image ?? Data())
        self.isFavourite = managedObject.isFavourite
    }

    private func checkForExistingImageInfo(id: Int, context: NSManagedObjectContext) throws -> Bool {
        let fetchRequest = ImageInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)

        let results = try context.fetch(fetchRequest)

        if !results.isEmpty
//           let firstResult = results.first as? ImageInfoEntity
        {
            return true
        }
        return false

    }

    func getExistingImageInfo(context: NSManagedObjectContext =
                              PersistenceController.shared.container.viewContext) -> ImageInfo? {
        let fetchRequest = ImageInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", self.id)

        guard let results = try? context.fetch(fetchRequest),
              let firstResult = results.first,
              firstResult.image != nil else {

            return nil
        }
        print("Image in base")

        return firstResult.getImageInfo()
    }

    func toManagedObject(context: NSManagedObjectContext) {
        do {
            guard try checkForExistingImageInfo(id: id, context: context) == false else {
                print("Object already in database")
                return
            }
        } catch {
            print("Can't save new model: cant't check existance")
        }

        let persistedValue = ImageInfoEntity.init(context: context)

        persistedValue.id = Int64(self.id)
        persistedValue.height = Int32(self.height)
        persistedValue.width = Int32(self.width)
        persistedValue.downloadUrl = self.downloadUrl
        persistedValue.url = self.url
        persistedValue.author = self.author
        persistedValue.image = self.image?.pngData()
        persistedValue.isFavourite = self.isFavourite

    }
}
