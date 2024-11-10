//
//  FoodItemsLoader.swift
//  FoodApi
//
//  Created by Aymen Letaief on 2024-11-10.
//

import Foundation

protocol FoodItemsLoader {
    func loadFoodItems() async throws -> [FoodItem]
}

protocol HTTPClient {
    func loadURL(url: URL) async throws -> (Data, URLResponse)
}

enum RemoteFoodItemError: Error {
    case invalidResponseCode
}

class RemoteFoodItemsLoader: FoodItemsLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func loadFoodItems() async throws -> [FoodItem] {
        let (_, response) = try await client.loadURL(url: url)
        if let response = response as? HTTPURLResponse {
            if response.statusCode != 200 {
                throw RemoteFoodItemError.invalidResponseCode
            }
        }
        return []
    }
    
}
