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
    
    let chunkSize = 4

    func addToFavourite(id: Int) async {
        await MainActor.run {
            if !favourites.filter({$0.id == id}).isEmpty {
                favourites.removeAll(where: {$0.id == id})
            } else {
                favourites.append(contentsOf: imageInfos.filter({$0.id == id}))
            }
        }
        
        do {
            try await favouritesStore.save(imageInfos: favourites)
        } catch {
            print("Failed to save favourites")
        }
        
    }

//    private let imageInfoStore: ImageInfoStore
    private let favouritesStore: ImageInfoStore

    init(imageInfoStore: ImageInfoStore,
         favouritesStore: ImageInfoStore) {
//        self.imageInfoStore = imageInfoStore
        self.favouritesStore = favouritesStore
        
        Task {
            await MainActor.run {
                favourites = (try? favouritesStore.load()) ?? []
            }
        }
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

        let request = await ImageInfoListRequest.getImageInfoListById(page: page, limit: limit)
        let fullImageInfos: [ImageInfo] = try await RequestManager.shared.perform(request)

        for imageInfoChunk in fullImageInfos.getChunks(withSize: chunkSize) {
            
            let sortedChunk = try await withThrowingTaskGroup(of: (ImageInfo, UIImage?).self) { group in
                for imageInfo in imageInfoChunk {
                    group.addTask { [self] in
                        let image = try await preloadImage(imageInfo: imageInfo)
                        return (imageInfo, image)
                    }
                }
                
                let chunkImageInfos = try await group.reduce(into: [(ImageInfo, UIImage?)]()) { $0.append($1) }
                
                return chunkImageInfos.sorted { $0.0.id < $1.0.id }
                
            }
            
            for (imageInfo, newImage) in sortedChunk {
                let imageInfoCopy = imageInfo.addImage(image: newImage)
                
                await MainActor.run {
                    imageInfos.append(imageInfoCopy)
                }
                
//                try imageInfoStore.save(imageInfos: [imageInfoCopy])
                
                await setLastLoadedId(id: imageInfoCopy.id)
            }
        }

        await toggleLoadingImages()
    }
    
    nonisolated func loadChunk() async throws {
        
    }

}
