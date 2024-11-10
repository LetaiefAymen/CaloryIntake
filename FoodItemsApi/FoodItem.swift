//
//  FoodItem.swift
//  FoodApi
//
//  Created by Aymen Letaief on 2024-11-10.
//

struct FoodItem: Decodable, Equatable {
    let name: String
    let caloryCount: Int
    let proteinCount: Double
    let fatCount: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "food_name"
        case caloryCount = "calories"
        case proteinCount = "protein"
        case fatCount = "fat"
    }
}
