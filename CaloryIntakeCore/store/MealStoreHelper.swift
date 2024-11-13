//
//  FoodItemsStore.swift
//  FoodItemsStore
//
//  Created by Aymen Letaief on 2024-11-10.
//

public protocol MealStoreHelper {
    func persist(mealEntry: MealEntry) async -> Bool
    func retrieveMeals() async -> [MealEntry]
    func deleteMeals() async -> Bool
}
