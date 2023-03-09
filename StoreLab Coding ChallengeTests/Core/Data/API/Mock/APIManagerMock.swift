//
//  APIManagerMock.swift
//  StoreLab Coding ChallengeTests
//
//  Created by Alexey Lisov on 09/03/2023.
//

import XCTest
@testable import StoreLab_Coding_Challenge

struct APIManagerMock: APIManagerProtocol {

    func perform(_ request: RequestProtocol) async throws -> Data {
        print("\(request.path)")
        return try Data(contentsOf: URL(fileURLWithPath: request.path), options: .mappedIfSafe)
    }
    
}
