//
//  ImageInfo.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

import UIKit

struct ImageInfo: Codable, Identifiable, Equatable {
    init(id: Int, author: String, width: Int, height: Int, url: String, downloadUrl: String, isFavourite: Bool) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadUrl = downloadUrl

        self.isFavourite = isFavourite

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(String(id), forKey: .id)
        try container.encode(author, forKey: .author)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(url, forKey: .url)
        try container.encode(downloadUrl, forKey: .downloadUrl)
        try container.encode(isFavourite, forKey: .isFavourite)
        try container.encode(image?.pngData(), forKey: .image)
    }
    
    func addImage(image: UIImage?) -> ImageInfo {
        var imageInfoCopy = self
        imageInfoCopy.image = image
        return imageInfoCopy
    }

    static let mock = ImageInfo(
        id: 220, author: "Robin Röcker", width: 3872, height: 2416,
        url: "https://unsplash.com/photos/qUToqliACNA",
        downloadUrl: "https://picsum.photos/id/220/200/200",
        isFavourite: true
    )

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url, downloadUrl, isFavourite, image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = Int(try container.decode(String.self, forKey: .id)) ?? -1
        self.author = try container.decode(String.self, forKey: .author)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.url = try container.decode(String.self, forKey: .url)
        self.downloadUrl = try container.decode(String.self, forKey: .downloadUrl)
        self.isFavourite = (try? container.decode(Bool.self, forKey: .isFavourite)) ?? false
        if let imageData = try? container.decode(Data.self, forKey: .image) {
            self.image = UIImage(data: imageData)
        }
    }

    var id: Int
    var author: String
    var width: Int
    var height: Int
    var url: String
    var downloadUrl: String

    var image: UIImage?

    var isFavourite: Bool
}
