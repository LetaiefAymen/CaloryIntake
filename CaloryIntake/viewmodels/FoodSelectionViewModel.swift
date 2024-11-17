//
//  CaloryIntakeViewModel.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 2024-11-10.
//

import Foundation
import CaloryIntakeCore

final class FoodSelectionViewModel: ObservableObject {
    
    let loader: RemoteFoodItemsLoader
    let mealStoreHelper: MealStoreHelper
    @Published
    var foodItems: [FoodItem] = []
    @Published
    var selectedFoodItems: [FoodItem] = []
    var mealName: String
    
    init(
        mealName: String,
        mealStoreHelper: MealStoreHelper = InMemoryMealStoreHelper(),
        loader: RemoteFoodItemsLoader = RemoteFoodItemsLoader(
            url: AppEnvironment.shared.foodItemsUrl,
            client: URLSessionHTTPClient(
                session: URLSession(configuration: .default)
            )
        )
    ) {
        self.loader = loader
        self.mealName = mealName
        self.mealStoreHelper = mealStoreHelper
    }
    
    func loadItems() {
        Task { @MainActor in
            do {
                let remoteFoodItems = try await loader.loadFoodItems()
                foodItems = remoteFoodItems.map({ $0.toFoodItem() })
                print(foodItems)
            } catch {
                print("Error happened: \(error.localizedDescription)")
            }
        }
    }
    
    func select(_ foodItem: FoodItem) {
        selectedFoodItems.append(foodItem)
    }
    
    func saveMeal() {
        Task { @MainActor in
            guard !selectedFoodItems.isEmpty else { return }
            let _ = await mealStoreHelper.persist(
                mealEntry: MealEntry(
                    id: UUID(),
                    mealName: mealName,
                    foodItems: selectedFoodItems
                )
            )
        }
        
    }
}
