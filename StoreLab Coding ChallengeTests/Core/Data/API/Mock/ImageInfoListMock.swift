//
//  ImageInfoListMock.swift
//  StoreLab Coding ChallengeTests
//
//  Created by Alexey Lisov on 09/03/2023.
//

import Foundation
@testable import StoreLab_Coding_Challenge

enum ImageInfoListMock: RequestProtocol {
    
    static let limit = 20
    
    case getImageInfoListById(page: Int)
    
    var path: String {
        switch self {
        case let .getImageInfoListById(page):
            let mockFileName = "ImageInfoListMock_\(ImageInfoListMock.limit)_\(page)"
            guard let result = Bundle.main.path(forResource: mockFileName,
                                                ofType: "json") else {
                print("Warning, no such mock file with name: \(mockFileName)")
                return ""
            }
            return result
        }
    }
    
    var requestType: RequestType {
        .GET
    }
}
