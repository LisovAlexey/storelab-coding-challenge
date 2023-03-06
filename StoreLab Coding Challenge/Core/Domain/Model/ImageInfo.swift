//
//  ImageInfo.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

struct ImageInfo: Codable {
    var id: Int
    var author: String
    var width: Int
    var height: Int
    var url: URL
    var downloadUrl: URL
}
