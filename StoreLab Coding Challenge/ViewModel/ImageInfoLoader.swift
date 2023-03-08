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

    func preloadImage(newImageInfo: inout ImageInfo) async throws {

        if let imageInfoFromStorage = newImageInfo.getExistingImageInfo() {
            newImageInfo = imageInfoFromStorage
            return
        }

        let newImage = try await ImageLoader.shared.image(newImageInfo)
        newImageInfo.image = newImage
        setLastLoadedId(id: newImageInfo.id)
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
        var newImageInfos: [ImageInfo] = try await RequestManager.shared.perform(request)

        for index in newImageInfos.indices {
            try await preloadImage(newImageInfo: &newImageInfos[index])

            let loadedImage = newImageInfos[index]

            await MainActor.run {
                imageInfos.append(loadedImage)
            }
        }

//        try await imageInfoStore.save(imageInfos: imageInfos)

        await toggleLoadingImages()
    }

}
