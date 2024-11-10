//
//  FoodItemsApiTests.swift
//  FoodItemsApiTests
//
//  Created by Aymen Letaief on 2024-11-10.
//

import XCTest
@testable import FoodItemsApi

@MainActor
final class RemoteFoodItemsApiTests: XCTestCase {
    
    func testSUT_LoaderisNotNil() {
        let (loader, _) = makeSUT()
        XCTAssertNotNil(loader)
    }
    
    func testSUT_loadFoodItemsTriggersLoadingURL() async throws {
        let url = URL(string: "www.sampleUrl.com")!
        let (loader, client) = makeSUT(url: url)
        XCTAssertEqual(client.loadedURLs, [], "client should not load any urls initially")
        let _ = try await loader.loadFoodItems()
        XCTAssertEqual(client.loadedURLs, [url])
    }
    
    func testSUT_LoaderFailsWhenClientFails() async throws {
        let url = URL(string: "https://www.sampleUrl.com")!
        let (loader, client) = makeSUT(url: url)
        let error = NSError(domain: "triggeredError", code: 1)
        client.triggerError = error
        await expect(loader: loader, toThrow: error, when: {
            _ = try await loader.loadFoodItems()
        })
    }
    
    func testSUT_loaderThrowsErrorOnInvalidResponse() async throws {
        let url = URL(string: "https://www.sampleUrl.com")!
        let (loader, client) = makeSUT(url: url)
        let invalidResponses = [400,500,199,304,208].map(
            {
                HTTPURLResponse(
                    url: url,
                    statusCode: $0,
                    httpVersion: nil,
                    headerFields: nil
                )
            }
        )
        
        for invalidResponse in invalidResponses {
            client.returnedResponse = invalidResponse
            await expect(loader: loader,toThrow: RemoteFoodItemError.invalidResponseCode, when: {
                _ = try await loader.loadFoodItems()
            })
        }
    }
    
    private func expect<T: Error & Equatable>(loader: RemoteFoodItemsLoader, toThrow expectedError: T, when: () async throws -> Void) async {
        do {
            try await when()
            XCTFail("Expected error, but loader completed successfully")
        } catch {
            XCTAssertEqual(error as? T, expectedError, "Expected the triggered error to be thrown.")
        }
    }
    
    private func makeSUT(url: URL = URL(string: "www.aUrl.com")!) -> (RemoteFoodItemsLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFoodItemsLoader(url: url, client: client), client)
    }
}

private final class HTTPClientSpy: HTTPClient {
    var loadedURLs: [URL] = []
    var triggerError: Error?
    var returnedResponse: URLResponse?
    
    func loadURL(url: URL) async throws -> (Data, URLResponse) {
        loadedURLs.append(url)
        if let triggerError {
            throw triggerError
        }
        return (Data(),returnedResponse ?? URLResponse())
    }
}
