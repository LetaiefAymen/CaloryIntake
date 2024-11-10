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
        let _ = try? await loader.loadFoodItems()
        XCTAssertEqual(client.loadedURLs, [url])
    }
    
    func testSUT_LoaderFailsWhenClientFails() async throws {
        let url = URL(string: "https://www.sampleUrl.com")!
        let (loader, client) = makeSUT(url: url)
        let error = NSError(domain: "triggeredError", code: 1)
        client.completeWith(response: .failure(error: error))
        await expect(loader: loader, toThrow: error, when: {
            _ = try await loader.loadFoodItems()
        })
    }
    
    func testSUT_loaderThrowsErrorOnInvalidResponseFromClient() async throws {
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
            client.completeWith(response: .success(Data(), invalidResponse!))
            await expect(loader: loader, toThrow: RemoteFoodItemError.invalidResponse, when: {
                _ = try await loader.loadFoodItems()
            })
        }
    }
    
    func testSUT_loaderReturnsFoodItemsOnSuccessfulClientResponse() async throws {
        let url = URL(string: "https://www.sampleUrl.com")!
        let (loader, client) = makeSUT(url: url)
        let foodItem1 = makeItem(name: "Apple", caloryCount: 52, proteinCount: 0.3, fatCount: 0.5)
        let foodItem2 = makeItem(name: "Orange", caloryCount: 53, proteinCount: 0.4, fatCount: 0.6)
        
        let jsonData = makeItemsJSON([foodItem1.json,foodItem2.json])
        client.completeWith(response: .success(jsonData,makeHTTPResponse(url: url, statusCode: 200)))
        
        let result = try await loader.loadFoodItems()
        
        XCTAssertEqual(result, [foodItem1.model,foodItem2.model])
    }
    
    private func makeItem(name: String, caloryCount: Int, proteinCount: Double, fatCount: Double) -> (model: FoodItem, json: [String: Any]) {
        let item = FoodItem(name: name, caloryCount: caloryCount, proteinCount: proteinCount, fatCount: fatCount)

        let json = [
            "food_name": name,
            "calories": caloryCount,
            "protein": proteinCount,
            "fat": fatCount
        ] as [String : Any]

        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
    private func makeHTTPResponse(url: URL, statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    private func expect<T: Error & Equatable>(
        loader: RemoteFoodItemsLoader,
        toThrow expectedError: T,
        when: () async throws -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            try await when()
            XCTFail("Expected error, but loader completed successfully", file: file,line: line)
        } catch {
            XCTAssertEqual(error as? T, expectedError, "Expected the triggered error to be thrown.", file: file,line: line)
        }
    }
    
    private func makeSUT(url: URL = URL(string: "www.aUrl.com")!) -> (RemoteFoodItemsLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFoodItemsLoader(url: url, client: client), client)
    }
}

private final class HTTPClientSpy: HTTPClient {
    
    enum ClientResponse {
        case failure(error: Error)
        case success(Data, URLResponse)
    }
    
    var loadedURLs: [URL] = []
    var response: ClientResponse = .success(Data(), URLResponse())
    
    func completeWith(response: ClientResponse) {
        self.response = response
    }
    
    func loadURL(url: URL) async throws -> (Data, URLResponse) {
        loadedURLs.append(url)
        switch response {
        case .failure(let error):
            throw error
        case .success(let data, let response):
            return (data,response)
        }
    }
}
