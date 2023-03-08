//
//  ImageInfo.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

import UIKit


struct ImageInfo: Decodable, Identifiable, Equatable {
    init(id: Int, author: String, width: Int, height: Int, url: String, downloadUrl: String, isFavourite: Bool) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadUrl = downloadUrl
        
        self.isFavourite = isFavourite
        
    }
    
    static let mock = ImageInfo(
        id: 220, author: "Robin Röcker", width: 3872, height: 2416,
        url: "https://unsplash.com/photos/qUToqliACNA",
        downloadUrl: "https://picsum.photos/id/220/200/200",
        isFavourite: true
    )
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url, downloadUrl, isFavourite
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
