//
//  InMemoryMealStoreHelper.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//

public class InMemoryMealStoreHelper: MealStoreHelper {
    
    private var meals: [MealEntry] = []
    
    public init() {}
    
    public func persist(mealEntry: MealEntry) async -> Bool {
        meals.append(mealEntry)
        return true
    }
    
    public func retrieveMeals() async -> [MealEntry] {
        meals
    }
    
    public func deleteMeals() async -> Bool {
        meals.removeAll()
        return true
    }
    
}
    
