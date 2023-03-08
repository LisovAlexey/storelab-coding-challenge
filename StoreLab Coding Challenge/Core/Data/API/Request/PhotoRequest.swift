//
//  photoInfoRequest.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

enum PhotoRequest: RequestProtocol {
    case getPhotoById(id: Int)
    case getPhotoByIdSquare(id: Int, squareSize: Int)
    case getPhotoByIdWidthHeight(id: Int, width: Int, height: Int)

    var path: String {
        switch self {
        case let .getPhotoById(id):
            return "/id/\(id)"

        case let .getPhotoByIdSquare(id, squareSize):
            return "/id/\(id)/\(squareSize)/\(squareSize)"

        case let .getPhotoByIdWidthHeight(id, width, height):
            return "/id/\(id)/\(width)/\(height)"
        }
    }

    var urlParams: [String: String?] {
        return [:]
    }

    var requestType: RequestType {
        .GET
    }
}
