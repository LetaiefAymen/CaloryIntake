//
//  InMemoryMealStoreHelper.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//

class InMemoryMealStoreHelper: MealStoreHelper {
    
    private var meals: [MealEntry] = []
    
    func persist(mealEntry: MealEntry) async -> Bool {
        meals.append(mealEntry)
        return true
    }
    
    func retrieveMeals() async -> [MealEntry] {
        meals
    }
    
    func deleteMeals() async -> Bool {
        meals.removeAll()
        return true
    }
    
}
    
