//
//  PhotoInfoRequest.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

enum PhotoInfoRequest: RequestProtocol {
    case getPhotoInfoById(id: Int)

    var path: String {
        switch self {
        case let .getPhotoInfoById(id):
            return "/id/\(id)/info"
        }
    }

    var urlParams: [String: String?] {
        return [:]
    }

    var requestType: RequestType {
        .GET
    }
}
