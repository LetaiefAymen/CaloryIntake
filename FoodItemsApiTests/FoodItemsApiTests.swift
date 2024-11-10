//
//  FoodItemsApiTests.swift
//  FoodItemsApiTests
//
//  Created by Aymen Letaief on 2024-11-10.
//

import XCTest
@testable import FoodItemsApi

final class RemoteFoodItemsApiTests: XCTestCase {
    
    func testSUT_LoaderisNotNil() {
        let (loader, _) = makeSUT()
        XCTAssertNotNil(loader)
    }
    
    @MainActor
    func testSUT_loadFoodItemsTriggersLoadingURL() async {
        let url = URL(string: "www.sampleUrl.com")!
        let (loader, client) = makeSUT(url: url)
        let _ = await loader.loadFoodItems()
        XCTAssertEqual(client.loadedURLs, [url])
    }

    private func makeSUT(url: URL = URL(string: "www.aUrl.com")!) -> (RemoteFoodItemsLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFoodItemsLoader(url: url, client: client), client)
    }

}

private final class HTTPClientSpy: HTTPClient {
    var loadedURLs: [URL] = []
    
    func loadURL(url: URL) async -> Data {
        loadedURLs.append(url)
        return Data()
    }
}
