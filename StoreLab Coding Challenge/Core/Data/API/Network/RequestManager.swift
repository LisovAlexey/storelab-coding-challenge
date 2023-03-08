//
//  RequestManager.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

final class RequestManager: RequestManagerProtocol {

    static let shared = RequestManager()

    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol

    init(
        apiManager: APIManagerProtocol = APIManager(),
        parser: DataParserProtocol = DataParser()
    ) {
        self.apiManager = apiManager
        self.parser = parser
    }

    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        let data = try await apiManager.perform(request)
        print("Data getting successful")
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
}
