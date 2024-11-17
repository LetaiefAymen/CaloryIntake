//
//  DailyIntakeViewModel.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 13.11.24.
//

import CaloryIntakeCore
import SwiftUI

class DailyIntakeViewModel: ObservableObject {
    
    let helper: MealStoreHelper
    
    @Published var totalCalories: Int = 0
    @Published var totalFats: Double = 0
    @Published var totalProteins: Double = 0
    
    init(helper: MealStoreHelper, totalCalories: Int = 0, totalFats: Double = 0, totalProteins: Double = 0) {
        self.helper = helper
        self.totalCalories = totalCalories
        self.totalFats = totalFats
        self.totalProteins = totalProteins
    }
    
    func loadData() {
        Task { @MainActor in
            let meals = await helper.retrieveMeals()
            totalFats = calculateTotal(meals: meals, for: \.fatCount)
            totalProteins = calculateTotal(meals: meals, for: \.proteinCount)
            totalCalories = Int(calculateTotal(meals: meals, for: \.caloryCount))
        }
    }
    
    private func calculateTotal<T: Numeric>(meals: [MealEntry], for keyPath: KeyPath<FoodItem, T>) -> T {
        return meals
            .flatMap { $0.foodItems }
            .map { $0[keyPath: keyPath] }
            .reduce(0, +)
    }
}
