//
//  PhotoInfoList.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import SwiftUI

enum PhotoInfoListRequest: RequestProtocol {
    case getPhotoInfoListById(page: Int, limit: Int)

    var path: String {
        return "/v2/list"
    }

    var urlParams: [String: String?] {
        var params: [String: String?] = [:]

        switch self {
        case let .getPhotoInfoListById(page, limit):
            params["page"] = String(page)
            params["limit"] = String(limit)
        }
        return params
    }

    var requestType: RequestType {
        .GET
    }
}
