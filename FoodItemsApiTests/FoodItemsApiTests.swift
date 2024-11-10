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
        let triggeredError = NSError(domain: "triggeredError", code: 1)
        client.triggerError = triggeredError
        
        do {
            _ = try await loader.loadFoodItems()
            XCTFail("Expected error, but loader completed successfully")
        } catch {
            XCTAssertEqual(error as NSError, triggeredError, "Expected the triggered error to be thrown.")
        }
        
        XCTAssertEqual(client.loadedURLs, [url], "The loader should have attempted loading from the specified URL.")
    }
    
    func testSUT_loaderThrowsErrorOnInvalidResponse() async throws {
        let url = URL(string: "https://www.sampleUrl.com")!
        
        let (loader, client) = makeSUT(url: url)
        client.returnedResponse = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        do {
            _ = try await loader.loadFoodItems()
            XCTFail("Expected error, but loader completed successfully")
        } catch {
            XCTAssertEqual(error as? RemoteFoodItemError, .invalidResponseCode, "Expected the triggered error to be thrown.")
        }
        
        XCTAssertEqual(client.loadedURLs, [url], "The loader should have attempted loading from the specified URL.")
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
