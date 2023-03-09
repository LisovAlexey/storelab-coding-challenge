//
//  CoreDataTests.swift
//  StoreLab Coding ChallengeTests
//
//  Created by Alexey Lisov on 09/03/2023.
//

import XCTest

@testable import StoreLab_Coding_Challenge

final class CoreDataTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testImageInfoEntityToManagedObject() throws {
        let previewContext = PersistenceController.preview.container.viewContext
        let fetchRequest = ImageInfoEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ImageInfoEntity.author, ascending: true)]
        
        guard let results = try? previewContext.fetch(fetchRequest),
              let first = results.first else { return }
        
        XCTAssert(first.author == ImageInfo.mock.author, "Author of mock didn't match, was exepecting \(ImageInfo.mock.author)")
    }
    
    func testDeleteManagedObject() throws {
        let previewContext = PersistenceController.preview.container.viewContext
        
        let fetchRequest = ImageInfoEntity.fetchRequest()
        guard let results = try? previewContext.fetch(fetchRequest),
              let first = results.first else { return }
        
        let expectedResult = results.count - 1
        previewContext.delete(first)
        
        guard let resultsAfterDeletion = try? previewContext.fetch(fetchRequest) else { return }
        
        XCTAssertEqual(expectedResult, resultsAfterDeletion.count,
                       "The number of results was expected to be \(expectedResult) after deletion, was \(results.count)")
    }
    
    func testFetchManagedObject() throws {
        let previewContext = PersistenceController.preview.container.viewContext
        let fetchRequest = ImageInfoEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %d", ImageInfo.mock.id)
        guard let results = try? previewContext.fetch(fetchRequest),
              let first = results.first else { return }
        XCTAssert(first.author == ImageInfo.mock.author,
    "Image info author did not match, expecting \(ImageInfo.mock.author), got \(String(describing: first.author))")
        
        XCTAssert(first.width == ImageInfo.mock.width,
                  "Image info width did not match, expecting \(ImageInfo.mock.width), got \(String(describing: first.width))")
        
        XCTAssert(first.height == ImageInfo.mock.height,
                  "Image info author did not match, expecting \(ImageInfo.mock.author), got \(String(describing: first.height))")
        
        XCTAssert(first.downloadUrl == ImageInfo.mock.downloadUrl,
                  "Image info width did not match, expecting \(ImageInfo.mock.downloadUrl), got \(String(describing: first.downloadUrl))")
        
        XCTAssert(first.url == ImageInfo.mock.url,
                  "Image info author did not match, expecting \(ImageInfo.mock.url), got \(String(describing: first.url))")
    }

}
