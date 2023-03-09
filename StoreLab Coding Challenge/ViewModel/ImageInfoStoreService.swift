//
//  ImageInfoStoreService.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 07/03/2023.
//

import Foundation
import CoreData

enum ImageInfoStoreError: Error {
    case not
}

protocol ImageInfoStore {
    func save(imageInfos: [ImageInfo]) throws
    func load() throws -> [ImageInfo]
}

struct ImageInfoStoreService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension ImageInfoStoreService: ImageInfoStore {
    func save(imageInfos: [ImageInfo]) throws {
        for imageInfo in imageInfos {
            imageInfo.toManagedObject(context: context)
        }
        try context.save()
    }

    func load() throws -> [ImageInfo] {
        return try ImageInfoEntity.loadAllImageInfos(context: context)
    }
}
