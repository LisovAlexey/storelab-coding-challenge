//
//  request.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

enum RequestType: String {
    case GET
    case POST
}

protocol RequestProtocol {
    var path: String { get }
    var requestType: RequestType { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
}

extension RequestProtocol {
    var host: String {
        APIConstants.host
    }

    var params: [String: Any] {
        [:]
    }

    var urlParams: [String: String?] {
        [:]
    }

    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path

        if !urlParams.isEmpty {
            components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
        }

        guard let url = components.url else { throw NetworkError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }

        return urlRequest
    }
}
