//
//  FoodItemsLoader.swift
//  FoodApi
//
//  Created by Aymen Letaief on 2024-11-10.
//

import Foundation

protocol FoodItemsLoader {
    func loadFoodItems() async -> [FoodItem]
}

protocol HTTPClient {
    func loadURL(url: URL) async -> Data
}

class RemoteFoodItemsLoader: FoodItemsLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func loadFoodItems() async -> [FoodItem] {
        await client.loadURL(url: url)
        return []
    }
    
}
