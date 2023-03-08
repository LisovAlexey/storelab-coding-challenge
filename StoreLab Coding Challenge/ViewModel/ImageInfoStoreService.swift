//
//  ImageInfoStoreService.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 07/03/2023.
//

import Foundation
import CoreData

protocol ImageInfoStore {
    func save(imageInfos: [ImageInfo]) async throws
}

struct ImageInfoStoreService {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension ImageInfoStoreService: ImageInfoStore {
    func save(imageInfos: [ImageInfo]) async throws {
        for var imageInfo in imageInfos {
            imageInfo.toManagedObject(context: context)
        }
        try context.save()
    }
}
