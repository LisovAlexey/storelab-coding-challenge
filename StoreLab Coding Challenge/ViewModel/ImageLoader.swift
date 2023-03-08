//
//  ImageLoader.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 07/03/2023.
//

import Foundation
import UIKit

actor ImageLoader: ObservableObject {
    
    static let shared = ImageLoader()
    
    enum DownloadState {
        case inProgress(Task<UIImage, Error>)
        case completed(UIImage)
        case failed
    }
    
    private(set) var cache: [String: DownloadState] = [:]
    
    func add(_ image: UIImage, forKey key: String) {
        cache[key] = .completed(image)
    }
    
    func image(_ imageInfo: ImageInfo) async throws -> UIImage {
        
        let cacheKey = imageInfo.downloadUrl
        
        if let cached = cache[cacheKey] {
            switch cached {
            case .completed(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            case .failed:
                print("Download failed") //throw "Download failed"
            }
        }
        
        let download: Task<UIImage, Error> = Task.detached {
            
            let request = PhotoRequest.getPhotoByIdSquare(id: imageInfo.id, squareSize: 400)
            
            print("Download: \(imageInfo.id)")
            let data = try await RequestManager.shared.apiManager.perform(request)
            
            guard let image = UIImage(data: data) else {
                print("Image decoding failed")
                return UIImage()
            }
            return image
        }
        
        cache[cacheKey] = .inProgress(download)
        
        do {
            let result = try await download.value
            add(result, forKey: cacheKey)
            return result
        } catch {
            cache[cacheKey] = .failed
            throw error
        }
    }
    
    func clear() {
        cache.removeAll()
    }
}
