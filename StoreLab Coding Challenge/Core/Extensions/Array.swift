//
//  Array.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 09/03/2023.
//

import Foundation

extension Array {
    func getChunks(withSize chunkSize: Int) -> [SubSequence] {
        
        guard !self.isEmpty else {
            return []
        }
        var chunks: [SubSequence] = []
        
        for (chunkStart, chunkEnd) in zip(
            stride(from: 0, to: self.count, by: chunkSize),
            stride(from: chunkSize, to: self.count + 1, by: chunkSize)) {
            chunks.append(self[chunkStart..<chunkEnd])
        }
        
        return chunks
        
    }
}
