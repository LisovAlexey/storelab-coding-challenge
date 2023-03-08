//
//  Parser.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import Foundation

protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

class DataParser: DataParserProtocol {
    private var jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func parse<T: Decodable>(data: Data) throws -> T {
        print(String(decoding: data, as: UTF8.self))
        return try jsonDecoder.decode(T.self, from: data)
    }
}
