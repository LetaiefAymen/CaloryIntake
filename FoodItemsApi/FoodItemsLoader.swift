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

enum RemoteFoodItemError: Error, Equatable {
    case invalidResponse
    case parsingError(reason: String)
}

class RemoteFoodItemsLoader: FoodItemsLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func loadFoodItems() async throws -> [FoodItem] {
        let (data, response) = try await client.loadURL(url: url)
        if let response = response as? HTTPURLResponse {
            return try FoodItemsResultMapper.map(data, from: response)
        } else {
            throw RemoteFoodItemError.invalidResponse
        }
    }
    
    class FoodItemsResultMapper {
        static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FoodItem] {
            guard response.statusCode == 200 else {
                throw RemoteFoodItemError.invalidResponse
            }
            do {
                let foodItems = try JSONDecoder().decode([FoodItem].self, from: data)
                return foodItems
            } catch {
                throw RemoteFoodItemError.parsingError(reason: error.localizedDescription)
            }
        }
    }
}
