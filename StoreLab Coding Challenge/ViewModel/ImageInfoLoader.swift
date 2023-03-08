//
//  ImageInfoLoader.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 07/03/2023.
//

import Foundation
import UIKit

actor ImageInfoLoader: ObservableObject {
    @Published @MainActor private(set) var imageInfos: [ImageInfo] = []
    @Published @MainActor private(set) var favourites: [ImageInfo] = []

    func addToFavourite(id: Int) async {
        await MainActor.run {
            if !favourites.filter({$0.id == id}).isEmpty {
                favourites.removeAll(where: {$0.id == id})
            } else {
                favourites.append(contentsOf: imageInfos.filter({$0.id == id}))
            }
        }
    }

    private let imageInfoStore: ImageInfoStore

    init(imageInfoStore: ImageInfoStore) {
        self.imageInfoStore = imageInfoStore
    }

    private var page = 0

    private var limit = 20
    private let downloadBefore = 20

    private(set) var lastLoadedId = 0

    private func setLastLoadedId(id: Int) {
        lastLoadedId = id
    }

    private func nextPage() {
        page += 1
    }

    func preloadImage(imageInfo: ImageInfo) async throws -> UIImage? {

        if let imageInfoFromStorage = imageInfo.getExistingImageInfo() {
            return imageInfoFromStorage.image
        }

        return try await ImageLoader.shared.image(imageInfo)
        
    }

    var loadingImages: Bool = false

    func toggleLoadingImages() {
        loadingImages.toggle()
    }

    nonisolated func loadImagesIfNeeded(imageInfo: ImageInfo) async throws {
        await print(imageInfo.id, self.lastLoadedId, max(self.lastLoadedId - downloadBefore, downloadBefore))
        guard await imageInfo.id >= max(self.lastLoadedId - downloadBefore, downloadBefore / 2)  else {
            return
        }

        print("Start loading new portion")

        try await loadImages()
    }

    nonisolated func loadImages() async throws {

        guard await !loadingImages else {
            print("already loading new images")
            return
        }

        await toggleLoadingImages()
        await nextPage()

        let request = await PhotoInfoListRequest.getPhotoInfoListById(page: page, limit: limit)
        let newImageInfos: [ImageInfo] = try await RequestManager.shared.perform(request)
        
        try await withThrowingTaskGroup(of: (ImageInfo, UIImage?).self) { group in
            for imageInfo in newImageInfos {
                group.addTask { [self] in
                    let image = try await preloadImage(imageInfo: imageInfo)
                    return (imageInfo, image)
                }
            }
            
            for try await (imageInfo, image) in group {
                let imageInfoCopy = imageInfo.addImage(image: image)
                
                await MainActor.run {
                    imageInfos.append(imageInfoCopy)
                }
                
                await setLastLoadedId(id: imageInfoCopy.id)
            }
        }

        await toggleLoadingImages()
    }

}
