//
//  MealEntry.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 2024-11-11.
//

import Foundation
import CoreData

public struct MealEntry: Equatable {
    public var id: UUID
    public var mealName: String
    public var foodItems: [FoodItem]
}
