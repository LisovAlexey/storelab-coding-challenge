//
//  ImageInfo.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

struct ImageInfo: Codable {
    
    static let mock = ImageInfo(
        id: 220, author: "Robin Röcker", width: 3872, height: 2416,
        url: URL(string: "https://unsplash.com/photos/qUToqliACNA")!,
        downloadUrl: URL(string: "https://picsum.photos/id/220/200/200")!
    )
    
    var id: Int
    var author: String
    var width: Int
    var height: Int
    var url: URL
    var downloadUrl: URL
}
