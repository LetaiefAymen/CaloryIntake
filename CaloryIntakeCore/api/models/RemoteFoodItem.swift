//
//  FoodItem.swift
//  FoodApi
//
//  Created by Aymen Letaief on 2024-11-10.
//

import Foundation

public struct RemoteFoodItem: Decodable, Equatable {
    public let name: String
    public let caloryCount: Double
    public let proteinCount: Double
    public let fatCount: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "food_name"
        case caloryCount = "calories"
        case proteinCount = "protein"
        case fatCount = "fat"
    }
}

extension RemoteFoodItem {
    public func toFoodItem() -> FoodItem {
        FoodItem(
            id: UUID(),
            name: name,
            caloryCount: caloryCount,
            proteinCount: proteinCount,
            fatCount: fatCount
        )
    }
}

extension FoodItem {
    public var remote: RemoteFoodItem {
        RemoteFoodItem(
            name: name,
            caloryCount: caloryCount,
            proteinCount: proteinCount,
            fatCount: fatCount
        )
    }
}
