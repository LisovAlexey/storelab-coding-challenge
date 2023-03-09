//
//  RequestManagerTests.swift
//  StoreLab Coding ChallengeTests
//
//  Created by Alexey Lisov on 09/03/2023.
//

import XCTest
@testable import StoreLab_Coding_Challenge

class RequestManagerTests: XCTestCase {
    private var requestManager: RequestManagerProtocol?
    
    override func setUp() {
        super.setUp()
        guard let userDefaults = UserDefaults(suiteName: #file) else { return }
        userDefaults.removePersistentDomain(forName: #file)
        requestManager = RequestManager(
            apiManager: APIManagerMock()
        )
    }
    
    func testRequestAnimals() async throws {
        guard let imageInfos: [ImageInfo] =
                try await requestManager?.perform(ImageInfoListMock.getImageInfoListById(page: 0)) else { return }

        let first = imageInfos.first
        let last = imageInfos.last
        
        XCTAssertEqual(first?.id, 0)
        XCTAssertEqual(first?.width, 5000)
        XCTAssertEqual(first?.height, 3333)
        XCTAssertEqual(first?.author, "Alejandro Escamilla")
        XCTAssertEqual(first?.downloadUrl, "https://picsum.photos/id/0/5000/3333")
        
        XCTAssertEqual(last?.author, "Paul Jarvis")
        XCTAssertEqual(last?.downloadUrl, "https://picsum.photos/id/19/2500/1667")

    }
}
