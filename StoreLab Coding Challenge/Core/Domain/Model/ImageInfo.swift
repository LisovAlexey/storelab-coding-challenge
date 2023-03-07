//
//  ImageInfo.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

import UIKit

struct ImageInfo: Decodable, Identifiable, Equatable {
    init(id: Int, author: String, width: Int, height: Int, url: String, downloadUrl: String) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadUrl = downloadUrl
    }
    
    static let mock = ImageInfo(
        id: 220, author: "Robin Röcker", width: 3872, height: 2416,
        url: "https://unsplash.com/photos/qUToqliACNA",
        downloadUrl: "https://picsum.photos/id/220/200/200"
    )
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url, downloadUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = Int(try container.decode(String.self, forKey: .id))!
        self.author = ""
        self.width = 200
        self.height = 200
        self.url = "200"
        self.downloadUrl = try container.decode(String.self, forKey: .downloadUrl)
    }
    
    var id: Int
    var author: String
    var width: Int
    var height: Int
    var url: String
    var downloadUrl: String
    
    var image: UIImage?
    
//    var previewDownloadUrl: URL? {
////        print(try? PhotoRequest.getPhotoByIdSquare(id: id, squareSize: 400).createURLRequest())
//        return try? PhotoRequest.getPhotoByIdSquare(id: id, squareSize: 400).createURLRequest().url
//    }
}
