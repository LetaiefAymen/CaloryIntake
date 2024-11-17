//
//  MealEntry.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 2024-11-11.
//

import Foundation

public struct MealEntry: Equatable {
    public let id: UUID
    public let mealName: String
    public let foodItems: [FoodItem]
    
    public init(id: UUID, mealName: String, foodItems: [FoodItem]) {
        self.id = id
        self.mealName = mealName
        self.foodItems = foodItems
    }
}
