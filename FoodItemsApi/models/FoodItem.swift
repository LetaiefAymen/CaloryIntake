//
//  FoodItem.swift
//  FoodApi
//
//  Created by Aymen Letaief on 2024-11-10.
//

public struct FoodItem: Decodable, Equatable {
    public let name: String
    public let caloryCount: Int
    public let proteinCount: Double
    public let fatCount: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "food_name"
        case caloryCount = "calories"
        case proteinCount = "protein"
        case fatCount = "fat"
    }
}
